# Tony Lend Challenge Solution

This document explains the solution to the Tony Lend challenge presented in the `Challenge.sol` and `TonyLend.sol` contracts.

## Challenge Overview

The Tony Lend challenge involves exploiting vulnerabilities in a lending protocol. The goal is to drain the challenge contract of its USDe tokens.

## The Vulnerabilities

There are two main vulnerabilities in this challenge:

1. **Incorrect Health Factor Calculation**: In the `withdraw` function, the health factor is calculated before updating the user's deposited balance. This allows users to withdraw more than they should be able to.

2. **Insufficient Health Factor Threshold**: The protocol considers a health factor of 1 (PRECISION) as healthy, which is too low and allows for full utilization of deposits as collateral.

## The Exploit

The solution exploits these vulnerabilities in the following steps:

1. Claim the initial "dust" tokens provided by the challenge.
2. Deposit USDC into the lending protocol to use as collateral.
3. Borrow the maximum amount of USDe against this collateral.
4. Deposit the borrowed USDe back into the protocol.
5. Withdraw the initially deposited USDe, which is possible due to the incorrect health factor calculation.
6. Repeat steps 3-5 to amplify the borrowed amount.
7. Transfer the acquired USDe to the specified address to solve the challenge.

## Implementation Details

The key steps in the `Solution.s.sol` script are:

1. Claim initial tokens:
   ```solidity
   challenge.claimDust();
   ```

2. Deposit USDC as collateral:
   ```solidity
   tonyLend.deposit(1, usdc.balanceOf(vm.addr(privateKey)));
   ```

3. Borrow, deposit, and withdraw USDe in a loop:
   ```solidity
   tonyLend.borrow(0, 10_000e18);
   tonyLend.deposit(0, 10_000e18);
   tonyLend.withdraw(0, 10_000e18);
   ```

4. Transfer USDe to solve the challenge:
   ```solidity
   usde.transfer(address(0xc0ffee), 21927 ether);
   ```