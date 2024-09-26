# Doju Challenge

### Overview

This project contains a smart contract challenge named `Doju` and a corresponding test script. The challenge involves interacting with a bonding curve token and steal half of its supply

## Solution Description

Solution lies in `sellTokens` function, where `Doju` contract calls `to` with calldata which is `abi.encodePacked(minOut,to,amount,...)`, Now, this can be manipulated by using `to` as doju address, salt mining to generate an address with last 4 bytes as same as first 4 bytes of `doju` address and then using choosing minOut such that, first 4 bytes are `transfer` function selector, and last 16 bytes as first 16 bytes of address generated. Although I was not able to generate such an address but it was easy to test it in foundry.

### Solution Script

- **test_doju()**: The main function that executes the solution. It performs the following steps:
  1. Initializes the `Challenge` contract and retrieves the `Doju` token instance.
  2. Claims the tokens from the `Challenge` contract.
  3. Constructs a special address (`CLAIMER_ADDRESS`) based on the `Doju` token address.
  4. Deploys a `Taker` contract to the `CLAIMER_ADDRESS`.
  5. Sells tokens to the `Doju` contract with a manipulated `minOut` value to exploit it.
  6. Withdraws the tokens to the address `0xc0ffee`.
  7. Asserts that the challenge is solved by checking the balance of the address `0xc0ffee`.


