// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./ITokenReceiver.sol";

contract SimpleToken is ERC20 {
    using Address for address;

    // error
    error TransferFailedForDeposit();
    error TransferFailedForDeposit2();

    constructor(uint256 initialSupply) ERC20("SimpleToken2", "STK2") {
        _mint(msg.sender, initialSupply);
    }

    function transferWithCallback(address to, uint256 amount) public returns (bool) {
        _transfer(_msgSender(), to, amount);

        try ITokenReceiver(to).tokensReceived(_msgSender(), amount) returns (bool success) {
            if (!success) {
                revert TransferFailedForDeposit();
            }
        } catch {
            revert TransferFailedForDeposit2();
        }

        return true;
    }
}
