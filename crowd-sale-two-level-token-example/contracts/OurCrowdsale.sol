pragma solidity ^0.5.0;

import "@openzeppelin/contracts/crowdsale/validation/TimedCrowdsale.sol";

contract OurCrowdsale is Crowdsale, TimedCrowdsale {

  constructor (uint256 _startTime, uint256 _endTime, uint256 _rate, address payable _wallet, IERC20 _token)
  	TimedCrowdsale(_startTime, _endTime)
  	Crowdsale(_rate, _wallet, _token)
  	public
  {
  }
}
