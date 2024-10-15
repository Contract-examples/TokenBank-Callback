// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC1363.sol";
import "@openzeppelin/contracts/interfaces/IERC1363Receiver.sol";

contract SimpleToken is ERC20, IERC1363 {
    // error
    error TransferFailedForDeposit();
    error ERC1363InvalidReceiver(address receiver);

    constructor(uint256 initialSupply) ERC20("SimpleToken2", "STK2") {
        _mint(msg.sender, initialSupply);
    }

    function transferAndCall(address recipient, uint256 amount) public virtual override returns (bool) {
        return transferAndCall(recipient, amount, "");
    }

    function transferAndCall(
        address recipient,
        uint256 amount,
        bytes memory data
    )
        public
        virtual
        override
        returns (bool)
    {
        transfer(recipient, amount);
        _checkAndCallTransfer(_msgSender(), recipient, amount, data);
        return true;
    }

    function transferFromAndCall(
        address sender,
        address recipient,
        uint256 amount
    )
        public
        virtual
        override
        returns (bool)
    {
        return transferFromAndCall(sender, recipient, amount, "");
    }

    function transferFromAndCall(
        address sender,
        address recipient,
        uint256 amount,
        bytes memory data
    )
        public
        virtual
        override
        returns (bool)
    {
        transferFrom(sender, recipient, amount);
        _checkAndCallTransfer(sender, recipient, amount, data);
        return true;
    }

    function approveAndCall(address spender, uint256 amount) public virtual override returns (bool) {
        return approveAndCall(spender, amount, "");
    }

    function approveAndCall(
        address spender,
        uint256 amount,
        bytes memory data
    )
        public
        virtual
        override
        returns (bool)
    {
        approve(spender, amount);
        _checkAndCallApprove(spender, amount, data);
        return true;
    }

    function _checkAndCallTransfer(address sender, address recipient, uint256 amount, bytes memory data) internal {
        if (!recipient.isContract()) {
            revert ERC1363InvalidReceiver(recipient);
        }
        bytes4 retval = IERC1363Receiver(recipient).onTransferReceived(_msgSender(), sender, amount, data);
        if (retval != IERC1363Receiver.onTransferReceived.selector) {
            revert TransferFailedForDeposit();
        }
    }

    // function _checkAndCallApprove(address spender, uint256 amount, bytes memory data) internal {
    //     if (!spender.isContract()) {
    //         revert ERC1363InvalidReceiver(spender);
    //     }
    //     bytes4 retval = IERC1363Spender(spender).onApprovalReceived(_msgSender(), amount, data);
    //     if (retval != IERC1363Spender.onApprovalReceived.selector) {
    //         revert TransferFailedForDeposit();
    //     }
    // }
}
