// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "./BaseContracts.sol";

contract Collectible is Ownable, Transferable {
    uint public price;

    function markPrice(uint _price) external onlyOwner {
        price = _price;
    }
}
