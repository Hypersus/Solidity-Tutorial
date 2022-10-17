// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract OtherContract {
    uint256 private _x = 0; // state variables _x
    // events emitted when receiving eth, recording amount and gas
    event Log(uint amount, uint gas);
    
    // get the balance of the contract
    function getBalance() view public returns(uint) {
        return address(this).balance;
    }

    // a function that can change the state variable _x, and payable
    function setX(uint256 x) external payable{
        _x = x;
        // emit Log event if ETH is transferred
        if(msg.value > 0){
            emit Log(msg.value, gasleft());
        }
    }

    // Reading _x
    function getX() external view returns(uint x){
        x = _x;
    }
}

contract CallContract {
    function callSetX(address _Address, uint256 x) external {
        OtherContract(_Address).setX(x);
    }

    function callGetX(OtherContract _Address) external view returns(uint x) {
        x = _Address.getX();
    }

    function callGetX2(address _Address) external view returns(uint x) {
        OtherContract oc = OtherContract(_Address);
        x = oc.getX();
    }

    function setXTransferETH(address otherContract, uint256 x) payable external {
        OtherContract(otherContract).setX{value: msg.value}(x);
    }
}