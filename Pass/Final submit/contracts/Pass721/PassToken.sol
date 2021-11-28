// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FestToken is Context, ERC20 {
    constructor() public ERC20("FestToken", "FEST") {
        _mint(_msgSender(), 10000 * (10**uint256(decimals())));
    }
}
