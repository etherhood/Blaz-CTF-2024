# 8inch Challenge Solution

This document explains the solution to the 8inch challenge presented in the `8Inch.sol` contract.

## The Vulnerability

The main vulnerability in this challenge lies in the `SafeUint112.sol` contract, specifically in the `safeCast` and `safeMul` functions. These functions are intended to prevent overflows when working with uint112, but they have a critical flaw.

## The Issue

1. In `safeCast`, the check `value <= (1 << 112)` is incorrect. It should be `value < (1 << 112)` because `(1 << 112)` is actually 2^112, which is the first value that doesn't fit in a uint112.

2. In `safeMul`, the same issue exists with the check `uint256(a) * b <= (1 << 112)`.

These flaws allow for potential overflows when casting or multiplying, which can be exploited.

## The Exploit

The solution exploits this vulnerability in the following ways:

1. It first settles the initial trade multiple times, taking advantage of the rounding errors to drain more tokens than intended.

2. It then creates a new trade with a very large scale factor.

3. The `scaleTrade` function is called with this large scale factor, causing an overflow in the `safeMul` function.

4. This overflow results in a trade with an extremely favorable rate for the attacker.

5. The attacker then settles this trade, acquiring a large number of WOJAK tokens.

## Implementation Details

The key steps in the `Solution.s.sol` script are:

1. Settle the initial trade multiple times to drain extra tokens.
2. Create a new dummy token with a large supply.
3. Create a new trade with a small amount of WOJAK for the dummy token.
4. Scale this trade with an extremely large factor: `2596148429267413814265248164610033`.
5. Settle the scaled trade, acquiring all the WOJAK tokens in the contract.
6. Transfer the required amount of WOJAK tokens to the specified address to solve the challenge.
