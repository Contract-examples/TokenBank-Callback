// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./TokenBank.sol";
import "@openzeppelin/contracts/interfaces/IERC1363Receiver.sol";

contract TokenBankV2 is TokenBank, IERC1363Receiver {
    // error
    error NotFromTokenContract();

    constructor(address _token) TokenBank(_token) { }

    function onTransferReceived(
        address operator,
        address from,
        uint256 amount,
        bytes memory
    )
        external
        override
        returns (bytes4)
    {
        // check if the sender is the token contract
        if (msg.sender != address(token)) {
            revert NotFromTokenContract();
        }

        // Update balance
        balances[from] += amount;

        // Emit deposit event
        emit Deposit(from, amount);

        // return the selector of the onTransferReceived function
        return IERC1363Receiver.onTransferReceived.selector;
    }

    // override deposit function if user want to deposit
    function deposit(uint256 amount) public override {
        super.deposit(amount);
    }
}
