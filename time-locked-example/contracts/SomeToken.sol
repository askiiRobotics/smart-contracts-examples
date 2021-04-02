// SomeToken.sol
// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract SomeToken is ERC20 {
    constructor() ERC20('Some Token', 'Some') public {
        _setupDecimals(18);
        _mint(msg.sender, 94697000000000000000000000);  
    }

}
