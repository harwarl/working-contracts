// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract MultiSig {
    address[] public owners;
    uint256 public required;
    mapping(uint => mapping(address => bool)) public confirmations;

    struct Transaction {
        address receiver;
        uint256 value;
        bool executed;
        bytes data;
    }

    Transaction[] public transactions;

    constructor(address[] memory _owners, uint256 _required) {
        require(_owners.length > 0, "Owners Should be more than 0");
        require(_required > 0, "Set a number of confirmations greater than 0");
        require(
            _required <= _owners.length,
            "No of confirmations should not be more than the no of owners"
        );
        owners = _owners;
        required = _required;
    }

    //Get the transactions count
    function transactionCount() public view returns (uint) {
        return transactions.length;
    }

    //Adding a new transaction to the list of transactions
    function addTransaction(
        address _destination,
        uint256 _value,
        bytes calldata _data
    ) internal returns (uint) {
        transactions.push(Transaction(_destination, _value, false, _data));
        uint transactionsNo = transactionCount();
        return transactionsNo - 1;
    }

    function confirmTransaction(uint _transactionId) public {
        require(_transactionId < transactions.length);
        require(isOwner(msg.sender), "Has to be a owner to confirm");
        require(
            !confirmations[_transactionId][msg.sender],
            "Transaction already confirmed by this owner"
        );

        confirmations[_transactionId][msg.sender] = true;

        if (isConfirmed(_transactionId)) {
            executeTransaction(_transactionId);
        }
    }

    function getConfirmationsCount(
        uint _transactionId
    ) public view returns (uint256) {
        uint256 noOfConfirmations = 0;
        for (uint i = 0; i < owners.length; i++) {
            if (confirmations[_transactionId][owners[i]] == true) {
                noOfConfirmations += 1;
            }
        }
        return noOfConfirmations;
    }

    function submitTransaction(
        address _destination,
        uint _value,
        bytes calldata _data
    ) external {
        //Add the transaction
        uint256 idx = addTransaction(_destination, _value, _data);
        confirmTransaction(idx);
    }

    function isConfirmed(uint _transactionId) public view returns (bool) {
        uint256 confirmationsNo = getConfirmationsCount(_transactionId);
        if (confirmationsNo >= required) {
            return true;
        }
        return false;
    }

    function executeTransaction(uint _transactionId) public {
        require(_transactionId >= 0, "Invalid Transaction Id");
        require(isOwner(msg.sender), "Has to be a owner to execute txn");
        require(
            isConfirmed(_transactionId),
            "Only execute txns that is confirmed"
        );
        //execute treansaction by transfering the values to the receiver
        transactions[_transactionId].receiver.call{
            value: transactions[_transactionId].value
        }(transactions[_transactionId].data);

        //Storing ERC-20 tokens means adding it as a calldata
        //change the executed to true
        transactions[_transactionId].executed = true;
    }

    receive() external payable {}

    // Helper function to check if an address is an owner
    function isOwner(address _account) internal view returns (bool) {
        for (uint i = 0; i < owners.length; i++) {
            if (owners[i] == _account) {
                return true;
            }
        }
        return false;
    }
}
