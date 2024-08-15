// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract Switch {
    address public owner;
    address public recipient;

    //timer start
    uint256 public pingStart;

    constructor(address _recipient) payable {
        owner = msg.sender;
        recipient = _recipient;
        pingStart = block.timestamp;
    }

    function withdraw() external {
        //Inactivity must be more than 52 weeks before recipient can with draw
        require((block.timestamp - pingStart) > 52 weeks, "Not long enough");
        (bool success, ) = recipient.call{value: address(this).balance}(" ");
        require(success);
    }

    function ping() external onlyOwner {
        // Restart the counter
        pingStart = block.timestamp;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}
