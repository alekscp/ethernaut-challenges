// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.0;

contract EarlyExit {
    
    NaughtCoin naughtCoin;
    address private player;
    
    modifier onlyPlayer() {
        require(msg.sender == player);
        _;
    }
    
    constructor(address _naughtCoin) public {
        naughtCoin = NaughtCoin(_naughtCoin);
        player = msg.sender;
    }
    
    function withdraw() public {
        uint256 playerBalance = naughtCoin.balanceOf(player);
        
        naughtCoin.transferFrom(msg.sender, address(this), playerBalance);
    }
    
    function transfer(address payable recipient) public onlyPlayer {
        recipient.transfer(address(this).balance);
    }
    
    receive() external payable {}
}

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/solc-0.6/contracts/token/ERC20/ERC20.sol';

contract NaughtCoin is ERC20 {

    // string public constant name = 'NaughtCoin';
    // string public constant symbol = '0x0';
    // uint public constant decimals = 18;
    uint public timeLock = now + 10 * 365 days;
    uint256 public INITIAL_SUPPLY;
    address public player;

    constructor(address _player) 
    ERC20('NaughtCoin', '0x0')
    public {
        player = _player;
        INITIAL_SUPPLY = 1000000 * (10**uint256(decimals()));
        // _totalSupply = INITIAL_SUPPLY;
        // _balances[player] = INITIAL_SUPPLY;
        _mint(player, INITIAL_SUPPLY);
        emit Transfer(address(0), player, INITIAL_SUPPLY);
    }
  
    function transfer(address _to, uint256 _value) override public lockTokens returns(bool) {
        super.transfer(_to, _value);
    }

    // Prevent the initial owner from transferring tokens until the timelock has passed
    modifier lockTokens() {
        if (msg.sender == player) {
            require(now > timeLock);
            _;
        } else {
            _;
        }
    } 
} 