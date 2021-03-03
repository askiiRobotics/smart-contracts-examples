pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Pausable.sol";

contract CrowdsaleToken is ERC20Detailed, ERC20Pausable {

    constructor (string memory name, string memory symbol, uint8 decimals, uint256 supply) public ERC20Detailed(name, symbol, decimals) {
        _mint(msg.sender, supply * (10 ** uint256(decimals)));
    }
}
