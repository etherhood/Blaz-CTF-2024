# BigenLayer Challenge Solution

This document explains the solution to the BigenLayer challenge presented in the `Challenge.sol` contract.

## The Vulnerability

The vulnerability in this challenge lies in owner's address, which is derived from 1337 as private key.

## The Solution

The solution involves the following steps:

1. Discover that the owner's address is derived from the number 1337.
2. Call the `adminRequestWithdrawal` function as the owner to withdraw Tim Cook's staked tokens.
3. Wait for the required 12 seconds.
4. Finalize the withdrawal to transfer the tokens to the player's address.

## Implementation Details

1. The owner's address is generated using:
   ```solidity
   address owner = vm.addr(uint256(1337));
   ```

2. Use this private key to sign transactions as the owner.

3. Call `adminRequestWithdrawal` to request a withdrawal of Tim Cook's staked tokens:
   ```solidity
   bigen.adminRequestWithdrawal(TIM_COOK, 16 * 10**18, PLAYER);
   ```

4. Wait for 12 seconds (as required by the contract).

5. Call `finalizeWithdrawal` to complete the transfer:
   ```solidity
   bigen.finalizeWithdrawal(TIM_COOK);
   ```

By following these steps, the player can obtain the required tokens and solve the challenge.
