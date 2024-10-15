# TokenBank-Callback


## Deploy
```
forge script script/Deploy.s.sol:DeployTokenBankAndTokenScript --rpc-url arbitrum_sepolia --broadcast --verify -vvvv
```
## Deploy result
```
SimpleToken deployed to: 0x95291a3819E690ddF39dFa805D5b3850237B9304
https://sepolia.arbiscan.io/address/0x95291a3819e690ddf39dfa805d5b3850237b9304

TokenBankV2 deployed to: 0x8402b4A3C2e14cAd26436ff9C9432b528244a9C6
https://sepolia.arbiscan.io/address/0x95291a3819e690ddf39dfa805d5b3850237b9304
```

## Distribute 1000 tokens to recipient address
```
forge script script/DistributeSimpleToken.s.sol:DistributeSimpleTokenScript --rpc-url arbitrum_sepolia --broadcast -vvvv
```
txhash: https://sepolia.arbiscan.io/tx/0xa19f50452a0e8fcf1cdce318ec79996ff5ba4fda73fa8893862dbe9780754712


## Deposit 1 token to Tokenbank
```
forge script script/DepositToTokenBank.s.sol:DepositToTokenBankScript --rpc-url arbitrum_sepolia --broadcast -vvvv
```
