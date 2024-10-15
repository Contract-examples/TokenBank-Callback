// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface ITokenReceiver {
    function tokensReceived(address from, uint256 amount) external returns (bool);
}
