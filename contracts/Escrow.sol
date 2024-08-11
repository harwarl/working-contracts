// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract Escrow {
    address payable public depositor;
    address payable public beneficiary;
    address public arbiter;
    uint private balance;
    bool public isApproved;

    event Approved(uint _amountSent);

    constructor(address _arbiter, address _beneficiary) payable {
        depositor = payable(msg.sender);
        beneficiary = payable(_beneficiary);
        arbiter = _arbiter;
        isApproved = false;
    }

    //A way for the arbiter to approve tthe transfer of funds to the beneficiary account
    //Only the arbiter can approve
    function approve() external {
        //Check if the arbiter is the one approving
        require(arbiter == msg.sender, "Only the arbiter can approve");
        //check if this has already been approved
        require(!isApproved, "Funds already approved");

        //change the state of isApproved
        isApproved = true;
        //transfer the balance of contract to the beneficiary
        balance = address(this).balance;
        (bool success, ) = beneficiary.call{value: balance}(" ");
        require(success);

        emit Approved(balance);
    }
}
