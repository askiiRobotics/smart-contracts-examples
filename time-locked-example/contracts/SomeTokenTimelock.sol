// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./SomeToken.sol";

import "@openzeppelin/contracts/token/ERC20/TokenTimelock.sol";

contract SomeTokenTimelock is TokenTimelock {
    constructor(SomeToken token, address beneficiary, uint256 releaseTime)
        public
        TokenTimelock(token, beneficiary, releaseTime)
    {}
}