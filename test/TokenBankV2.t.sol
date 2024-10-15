// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/TokenBankV2.sol";
import "../src/SimpleToken.sol";

contract TokenBankV2Test is Test {
    TokenBankV2 public bank;
    SimpleToken public token;
    address public user1;
    address public user2;

    uint256 constant INITIAL_SUPPLY = 1_000_000 * 10 ** 18;
    uint256 constant DEPOSIT_AMOUNT = 1000 * 10 ** 18;

    function setUp() public {
        token = new SimpleToken(INITIAL_SUPPLY);
        bank = new TokenBankV2(address(token));
        user1 = address(0x1);
        user2 = address(0x2);

        // Transfer some tokens to users
        token.transfer(user1, 10_000 * 10 ** 18);
        token.transfer(user2, 10_000 * 10 ** 18);
    }

    function testTransferWithCallback() public {
        vm.startPrank(user1);

        // Approve bank to spend tokens (this is not necessary for transferWithCallback, but kept for consistency)
        token.approve(address(bank), DEPOSIT_AMOUNT);

        // Use transferWithCallback to deposit tokens
        bool success = token.transferWithCallback(address(bank), DEPOSIT_AMOUNT, "");

        vm.stopPrank();

        assertTrue(success, "Transfer with callback failed");
        assertEq(bank.balances(user1), DEPOSIT_AMOUNT, "Deposit amount incorrect");
        assertEq(token.balanceOf(address(bank)), DEPOSIT_AMOUNT, "Bank balance incorrect");
    }

    function testDirectDeposit() public {
        vm.startPrank(user1);

        // Approve bank to spend tokens
        token.approve(address(bank), DEPOSIT_AMOUNT);

        // Deposit tokens using the original deposit function
        bank.deposit(DEPOSIT_AMOUNT);

        vm.stopPrank();

        assertEq(bank.balances(user1), DEPOSIT_AMOUNT, "Deposit amount incorrect");
        assertEq(token.balanceOf(address(bank)), DEPOSIT_AMOUNT, "Bank balance incorrect");
    }

    function testWithdraw() public {
        // First, deposit some tokens
        vm.startPrank(user1);
        token.approve(address(bank), DEPOSIT_AMOUNT);
        token.transferWithCallback(address(bank), DEPOSIT_AMOUNT, "");

        // Now withdraw half of the deposited amount
        uint256 withdrawAmount = DEPOSIT_AMOUNT / 2;
        bank.withdraw(withdrawAmount);

        vm.stopPrank();

        assertEq(bank.balances(user1), DEPOSIT_AMOUNT - withdrawAmount, "Remaining balance incorrect");
        assertEq(
            token.balanceOf(user1),
            10_000 * 10 ** 18 - DEPOSIT_AMOUNT + withdrawAmount,
            "User balance incorrect after withdrawal"
        );
    }

    function testFailTransferWithCallbackFromNonToken() public {
        // Try to call tokensReceived directly, which should fail
        vm.prank(user1);
        bank.tokensReceived(user1, DEPOSIT_AMOUNT, "");
    }

    function testFailWithdrawTooMuch() public {
        vm.startPrank(user1);
        token.approve(address(bank), DEPOSIT_AMOUNT);
        token.transferWithCallback(address(bank), DEPOSIT_AMOUNT, "");

        // Try to withdraw more than deposited
        bank.withdraw(DEPOSIT_AMOUNT + 1);

        vm.stopPrank();
    }
}
