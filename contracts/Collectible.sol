// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Collectible {
    event Deployed(address indexed _addr);
    event Transfer(address indexed _addr1, address indexed _addr2);
    event ForSale(uint _x, uint _y);
    event Purchase(uint _x, address indexed _buyer);

    address public owner;
    address public previousOwner;
    bool public isForSale;
    bool public isSold;
    mapping(address => uint) askingPrices;

    constructor() {
        owner = msg.sender;
        isForSale = false;
        emit Deployed(owner);
        isSold = false;
    }

    //transfer the collectible to some recipient
    function transfer(address _recipient) external {
        require(owner == msg.sender, "You are not the owner");

        previousOwner = owner;
        owner = _recipient;

        emit Transfer(msg.sender, _recipient);
    }

    //set an asking price for the collectible
    function markPrice(uint _askingPrice) external {
        require(msg.sender == owner);
        require(_askingPrice > 0);
        askingPrices[owner] = _askingPrice;
        isForSale = true;
        emit ForSale(_askingPrice, block.timestamp);
    }

    //buy the stuff from someone that needs it
    function purchase() external payable {
        require(isForSale == true);
        require(isSold == false);
        require(msg.value == askingPrices[owner]);

        (bool success, ) = owner.call{value: msg.value}(" ");
        require(success);

        askingPrices[owner] = 0;

        owner = msg.sender;
        isForSale = false;
        isSold == true;

        emit Purchase(msg.value, msg.sender);
    }
}
