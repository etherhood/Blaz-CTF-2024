# Pendle Intern Challenge

## Overview

The `Challenge` contract is designed to test the player's ability to interact with the `PendleIntern` token and `PendleRouter` contract. The challenge is considered solved if the player's address holds at least 337 ether of the `PendleIntern` token.

## Solution Description

The solution script `Solution.s.sol` aims to solve the challenge by interacting with the `Challenge` contract and performing token swaps. However, the solution has some critical flaws:

1. **SY Token Address Validation**: The solution does not validate the address of the SY token, which could lead to potential security risks.
2. **Swap Balance Delta Check**: During the swap operation, the solution does not check the balance delta of the token out before and after the swap. Instead, it directly uses the balance, which can be exploited to withdraw funds from the router.

### Solution Script

- **run()**: The main function that executes the solution. It performs the following steps:
  1. Initializes the `Challenge` contract.
  2. Creates a new `SYToken` instance.
  3. Calls the `redeemSyToToken` function on the `IPendle` interface to perform the token swap.


