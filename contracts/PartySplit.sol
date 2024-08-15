// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract Party {
    error IsAlreadyRSVP();

    uint256 public depositAmount;
    mapping(address => bool) public rsvps;
    address[] public rsvpList;

    constructor(uint256 _amount) {
        //This is the amount to be paid by the participants to join the party
        depositAmount = _amount;
    }

    //RSVP for the party
    function rsvp() external payable {
        //make sure the amount is the exact deposit amount
        require(
            msg.value == depositAmount,
            "You need to send exact deposit amount"
        );
        // Check is the friend already RSVPed
        if (rsvps[msg.sender] == true) {
            revert IsAlreadyRSVP();
        }

        rsvps[msg.sender] = true;
        rsvpList.push(msg.sender);
    }

    //Share Expenses
    function payBill(address _venue, uint _amount) external {
        require(
            _amount <= address(this).balance,
            "The Cummulated balance is lower than the amount to be paid"
        );

        //Pay the venue
        (bool success, ) = payable(_venue).call{value: _amount}(" ");
        require(success, "Venue paid");

        //share the remaining balance among the remain friends
        uint toBeSharedBalance = address(this).balance / rsvpList.length;
        for (uint i = 0; i < rsvpList.length; i++) {
            (bool successShared, ) = payable(rsvpList[i]).call{
                value: toBeSharedBalance
            }(" ");
            require(successShared);
        }
    }
}
