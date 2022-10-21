// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract OnlyEven{
    constructor(uint a){
        require(a != 0, "invalid number");
        assert(a != 1);
    }

    function onlyEven(uint256 b) external pure returns(bool success){
        // when the input is odd, revert
        require(b % 2 == 0, "Ups! Reverting");
        success = true;
    }
}

contract TryCatch {

    // success event
    event SuccessEvent();

    // failed event
    event CatchEvent(string message);
    event CatchByte(bytes data);

    // declare OnlyEven contract variables
    OnlyEven even;

    constructor() {
        even = new OnlyEven(2);
    }

    // use try-catch in external calls
    function execute(uint amount) external returns (bool success) {
        try even.onlyEven(amount) returns(bool _success){
            // when call succeed
            emit SuccessEvent();
            return _success;
        } catch Error(string memory reason){
            // when call failed
            emit CatchEvent(reason);
        }
    }

    // Use try-catch when creating new contracts
    // executeNew(0) will fail and emit `CatchEvent`
    // executeNew(1) will fail and emit `CatchByte`
    // executeNew(2) will success and `SuccessEvent`
    function executeNew(uint a) external returns (bool success) {
        try new OnlyEven(a) returns(OnlyEven _even){
            // when call succeed
            emit SuccessEvent();
            success = _even.onlyEven(a);
        } catch Error(string memory reason) {
            // catch revert() and require()
            emit CatchEvent(reason);
        } catch (bytes memory reason) {
            // catch assert()
            emit CatchByte(reason);
        }
    }

    

}
