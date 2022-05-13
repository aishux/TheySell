// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TheyCoin is ERC20 {

    address owner;

    constructor(uint256 initialSupply) ERC20("TheyCoin", "TC") {
        _mint(msg.sender, initialSupply);
        _approve(msg.sender, address(this), initialSupply);
        owner = msg.sender;
    }

    function payUser (address token, address _toUser, uint256 _amount) payable public {

        IERC20 paymentToken = IERC20(token);

        require(paymentToken.transferFrom(owner, _toUser, _amount),"transfer Failed");

    }
}