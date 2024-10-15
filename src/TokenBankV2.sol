// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./TokenBank.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./ITokenReceiver.sol";

contract TokenBankV2 is TokenBank, ITokenReceiver {
    using Address for address;

    // error
    error NotFromTokenContract();

    constructor(address _token) TokenBank(_token) { }

    function tokensReceived(address from, uint256 amount) external override returns (bool) {
        // check if the sender is the token contract
        if (msg.sender != address(token)) {
            revert NotFromTokenContract();
        }

        // Update balance
        balances[from] += amount;

        // Emit deposit event
        emit Deposit(from, amount);

        return true;
    }

    // override deposit function if user want to deposit
    function deposit(uint256 amount) public override {
        super.deposit(amount);
    }
}
