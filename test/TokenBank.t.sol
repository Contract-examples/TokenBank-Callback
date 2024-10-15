// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "../src/TokenBank.sol";
import "../src/SimpleToken.sol";

contract TokenBankTest is Test {
    SimpleToken public token;
    TokenBank public bank;
    address public user1;
    address public user2;

    function setUp() public {
        token = new SimpleToken(1_000_000 * 10 ** 18); // 1,000,000 tokens
        bank = new TokenBank(address(token));
        user1 = address(0x1);
        user2 = address(0x2);

        // Transfer some tokens to user1 and user2
        token.transfer(user1, 10_000 * 10 ** 18);
        token.transfer(user2, 10_000 * 10 ** 18);
    }

    function testTransferWithCallback() public {
        uint256 depositAmount = 1000 * 10 ** 18;

        vm.startPrank(user1);

        // Check initial balances
        assertEq(token.balanceOf(user1), 10_000 * 10 ** 18);
        assertEq(bank.getDepositAmount(user1), 0);

        // Perform transferWithCallback
        token.transferWithCallback(address(bank), depositAmount);

        // Check final balances
        assertEq(token.balanceOf(user1), 9000 * 10 ** 18);
        assertEq(bank.getDepositAmount(user1), depositAmount);
        assertEq(token.balanceOf(address(bank)), depositAmount);

        vm.stopPrank();
    }

    function testFailTransferWithCallbackInsufficientBalance() public {
        uint256 depositAmount = 20_000 * 10 ** 18; // More than user1's balance

        vm.startPrank(user1);

        // This should fail due to insufficient balance
        token.transferWithCallback(address(bank), depositAmount);

        vm.stopPrank();
    }

    function testTransferWithCallbackAndWithdraw() public {
        uint256 depositAmount = 1000 * 10 ** 18;
        uint256 withdrawAmount = 500 * 10 ** 18;

        vm.startPrank(user1);

        // Perform transferWithCallback
        token.transferWithCallback(address(bank), depositAmount);

        // Withdraw half of the deposited amount
        bank.withdraw(withdrawAmount);

        // Check final balances
        assertEq(token.balanceOf(user1), 9500 * 10 ** 18);
        assertEq(bank.getDepositAmount(user1), 500 * 10 ** 18);
        assertEq(token.balanceOf(address(bank)), 500 * 10 ** 18);

        vm.stopPrank();
    }
}
