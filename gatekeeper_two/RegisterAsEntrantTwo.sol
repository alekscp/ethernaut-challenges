// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.0;

contract RegisterAsEntrantTwo {
    constructor(address _gateKeeperTwo) public {
        GatekeeperTwo gateKeeperTwo = GatekeeperTwo(_gateKeeperTwo);
        
        bytes8 gateKey = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ uint64(0) - 1);
        
        gateKeeperTwo.enter(gateKey);
    }
}

contract TestCasting {
    
    event LogInt(uint idx, uint val);
    event LogBytes(uint idx, bytes val);
    event LogBytes8(uint idx, bytes8 val);
    event LogBytes32(uint idx, bytes32 val);
    event LogBool(uint idx, bool val);
    
    // Testing things out to wrap my head around gateThree()
    function test() public {
        uint64 one = uint64(0) - 1;
        bytes memory two = abi.encodePacked(msg.sender);
        bytes32 three = keccak256(two);
        bytes8 four = bytes8(three);
        uint64 five = uint64(four);
        
        emit LogInt(1, one); // Right hand side of equality comparison
        emit LogBytes(1, two);
        emit LogBytes32(1, three);
        emit LogBytes8(1, four);
        emit LogInt(2, five); // First element of left hand side equality comparison
        
        uint64 six = five ^ one;
        uint64 seven = five ^ six;
        
        emit LogInt(3, six);
        emit LogInt(4, seven);
        
        bool eight = seven == one;
        
        LogBool(1, eight);
        
        bytes8 nine = bytes8(seven);
        
        LogBytes8(2, nine);
        
        // If A xor B = C, then A xor C = B
        bytes8 gateKey = bytes8(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(0) - 1);
        
        LogBytes8(3, gateKey);
        
        bool eleven = uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(gateKey) == uint64(0) - 1;
        
        LogBool(2, eleven); // true
    }
}

contract GatekeeperTwo {

    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        uint x;
        assembly { x := extcodesize(caller()) }
        require(x == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == uint64(0) - 1);
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}