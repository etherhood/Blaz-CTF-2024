// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import {SymTest} from "halmos-cheatcodes/SymTest.sol";

import "src/Challenge.sol";


contract BigenTest is SymTest, Test {

    Challenge challenge;

    address PLAYER = makeAddr("0x99DE1B4826E4F5f8E7C02118e817125b99072640");

    function setUp() public {
        challenge = new Challenge();
    }

    function test_exploit() public {


        // Your test code here
    }
}
