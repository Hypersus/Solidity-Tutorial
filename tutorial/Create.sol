// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract PairFactory{
    mapping(address => mapping(address => address)) public getPair; // search Pair address through the 2 token addresses
    address[] public allPairs; // save all Pair address

    function createPair(address tokenA, address tokenB) external returns (address pairAddr) {
        // create a new contract
        Pair pair = new Pair(); 
        // call initialize function of the new contract
        pair.initialize(tokenA, tokenB);
        // update map
        pairAddr = address(pair);
        allPairs.push(pairAddr);
        getPair[tokenA][tokenB] = pairAddr;
        getPair[tokenB][tokenA] = pairAddr;
    }
}

contract Pair{
    address public factory; // address of factory contract
    address public token0; 
    address public token1; 

    constructor() payable {
        factory = msg.sender;
    }

    // called once by the factory at time of deployment
    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, 'UniswapV2: FORBIDDEN'); // sufficient check
        token0 = _token0;
        token1 = _token1;
    }
}