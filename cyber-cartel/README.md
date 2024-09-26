# Cyber Cartel Challenge Solution

This document explains the solution to the Cyber Cartel challenge presented in the `Challenge.sol` and `CyberCartel.sol` contracts.

## The Vulnerability

The main vulnerability in this challenge lies in the `BodyGuard` contract's signature validation process. Specifically:

1. The `validateSignatures` function doesn't properly enforce that signatures come from different guardians.
2. They validate 2 signatures if `msg.sender` is one of authorised signer, but they don't check if the signatures are signed by other signers and not `msg.sender`.
3. While while validating signatures, yul is used to get `v`,`r` and `s` values, but it doesn't check signature length to check that there is no extra data appended to them, thereby making them pass same signature as valid multiple times

## The Exploit

The solution exploits these vulnerabilities in the following ways:

1. It uses a single private key to generate two different valid signatures for the same message.
2. It manipulates the signatures to pass the sorting check by appending different values to the end of each signature.

## Implementation Details

The key steps in the `Solution.s.sol` script are:

1. Create a proposal to dismiss the bodyguard (`gistCartelDismiss` function).
2. Sign the proposal hash with a single private key.
3. Create two signature objects from this single signature, appending different values to make them sort differently.
4. Call the `propose` function with these manipulated signatures.
5. After dismissing the bodyguard, call the `doom` function to drain the treasury.

Key code snippet:

```solidity
bytes32 digest = keccak256(
    abi.encodePacked(proposal.expiredAt, proposal.gas, proposal.data, proposal.nonce, address(treasury), hex"80840397b652018080")
);

(uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, digest);
bytes[] memory signatures = new bytes[](2);

signatures[1] = abi.encodePacked(r, s, v, uint256(1));
signatures[0] = abi.encodePacked(r, s, v, uint256(2));

bodyguard.propose(proposal, signatures);
```
