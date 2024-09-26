# Tutori4l Challenge Solution

This document explains the solution to the Tutori4l challenge presented in the `Challenge.sol` contract.

## Challenge Overview

The Tutori4l challenge involves interacting with a complex smart contract system that includes a PoolManager, a custom Hook, and the main Challenge contract. The goal is to drain the challenge contract of its ETH balance.

## Key Requirements

1. Interact with the PoolManager contract to manipulate liquidity.
2. Exploit the `arbitrary` function in the Challenge contract.
3. Fetch non-public immutable addresses from the challenge contract.

## The Solution

The solution involves several key steps:

1. Fetching non-public immutable addresses:
   - Retrieve the bytecode of the challenge contract.
   - Analyze the bytecode using tools like evm.codes to find the addresses being used.

2. Exploiting the `arbitrary` function:
   - Use the `arbitrary` function to call the PoolManager's `unlock` function.
   - Within the unlock callback, perform the following actions:
     a. Mint `1 ether` curreny 0 to the exploit contract.
     b. Use the `arbitrary` function again to call `settleFor` on the PoolManager which passes 1 ether to PoolManager
     c. Take the minted liquidity and burn it.

3. Withdrawing the drained ETH to the player's address.

## Implementation Details

The key steps in the `Solution.s.sol` script are:

1. Create an `Exploit` contract that handles the complex interactions.
2. In the `unlockCallback` function of the `Exploit` contract:
   - Mint liquidity
   - Call `arbitrary` on the challenge to execute `settleFor`, which passed `1 ether` to poolManager
   - Take and burn the minted liquidity

3. Use the `runIt` function to initiate the exploit:
   ```solidity
   exploit.runIt(challenge, manager);
   ```

4. Withdraw the drained ETH:
   ```solidity
   exploit.withdraw(playerAddress);
   ```

## Fetching Non-Public Addresses

A crucial part of this challenge was retrieving non-public immutable addresses from the challenge contract. This was accomplished by:

1. Fetching the bytecode of the challenge contract:
   ```solidity
   bytes memory contractCode = getContractCode(challengeAddress);
   ```

2. Analyzing the bytecode using tools like evm.codes to identify the addresses being used in the contract.

This step was essential for interacting correctly with the challenge contract and its associated components.