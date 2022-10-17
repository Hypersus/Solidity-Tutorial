// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

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

contract PairFactory2{
    mapping(address => mapping(address => address)) public getPair; // search Pair address through the 2 token addresses
    address[] public allPairs; // save all Pair address

    function createPair2(address tokenA, address tokenB) external returns (address pairAddr) {
        require(tokenA!=tokenB, 'IDENTICAL_ADDRESS'); // avoid collision of tokenA and tokenB
        // compute salt by tokenA address and tokenB address
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        // create a new contract using create2
        Pair pair = new Pair{salt: salt}(); 
        // call initialize function of the new contract
        pair.initialize(tokenA, tokenB);
        // update map
        pairAddr = address(pair);
        allPairs.push(pairAddr);
        getPair[tokenA][tokenB] = pairAddr;
        getPair[tokenB][tokenA] = pairAddr;
    }

    // Compute address of Pair beforhand
    function calculateAddr(address tokenA, address tokenB) public view returns(address predictedAddress){
        require(tokenA != tokenB, 'IDENTICAL_ADDRESSES'); //avoid collision of tokenA and tokenB
        // compute salt by tokenA address and tokenB address
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA); //将tokenA和tokenB按大小排序
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        // compute hash
        predictedAddress = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            salt,
            keccak256(type(Pair).creationCode)
        )))));
    }
}