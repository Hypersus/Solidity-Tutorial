// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract SelfDestruct {

    uint public value = 10;

    constructor() payable {}

    receive() external payable {}

    function deleteContract() external {
        // call selfdestruct to destruct the contract and transfer the remained ETH to msg.sender
        selfdestruct(payable(msg.sender));
    }

    function getBalance() external view returns(uint balance){
        balance = address(this).balance;
    }

}