// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../src/TokenBankV2.sol";
import "../src/SimpleToken.sol";

contract DepositToTokenBankScript is Script {
    function setUp() public { }

    function run() public {
        uint256 userPrivateKey = vm.envUint("RECIPIENT_PRIVATE_KEY");
        address userAddress = vm.addr(userPrivateKey);
        address tokenAddress = vm.envAddress("TOKEN_CONTRACT_ADDRESS");
        address bankAddress = vm.envAddress("BANK_CONTRACT_ADDRESS");

        vm.startBroadcast(userPrivateKey);

        SimpleToken token = SimpleToken(tokenAddress);
        TokenBankV2 bank = TokenBankV2(bankAddress);

        uint256 amountToDeposit = 10 * 10 ** 18; // deposit 10 tokens

        // Use transferWithCallback to deposit tokens directly to TokenBankV2
        bool success = token.transferWithCallback(bankAddress, amountToDeposit);
        console2.log("Deposit with transferWithCallback success:", success);

        // check balance after deposit
        uint256 balance = bank.getDepositAmount(userAddress);
        console2.log("User balance in TokenBankV2:", balance);

        // check bank balance
        uint256 bankBalance = bank.getBalance();
        console2.log("Bank balance:", bankBalance);

        vm.stopBroadcast();
    }
}
