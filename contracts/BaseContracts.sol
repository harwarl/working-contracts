// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

contract Ownable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

contract Transferable is Ownable {
    address public previousOwner;

    function transfer(address _recipient) external {
        require(owner == msg.sender, "You are not the owner");
        previousOwner = owner;
        owner = _recipient;
    }
}
