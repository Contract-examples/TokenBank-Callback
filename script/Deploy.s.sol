// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../src/TokenBankV2.sol";
import "../src/SimpleToken.sol";

contract DeployTokenBankAndTokenScript is Script {
    function setUp() public { }

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("SEPOLIA_WALLET_PRIVATE_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        // deploy SimpleToken
        SimpleToken token = new SimpleToken(1_000_000 * 10 ** 18); // 1,000,000 tokens
        console2.log("SimpleToken deployed to:", address(token));

        // deploy TokenBankV2
        TokenBankV2 bank = new TokenBankV2(address(token));
        console2.log("TokenBankV2 deployed to:", address(bank));

        console2.log("Deployed by:", deployerAddress);

        vm.stopBroadcast();
    }
}
