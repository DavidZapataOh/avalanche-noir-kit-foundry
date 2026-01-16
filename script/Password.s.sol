// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Script, console} from "forge-std/Script.sol";
import {Password} from "../src/Password.sol";
import {HonkVerifier} from "../src/verifiers/PasswordVerifier.sol";

contract PasswordScript is Script {
    HonkVerifier public verifier;
    Password public password;

    function setUp() public {}

    function run() public {
        console.log("--- Deployment started ---");
        vm.startBroadcast();

        console.log("Deploying Verifier...");
        verifier = new HonkVerifier();
        address verifierAddress = address(verifier);
        console.log("Verifier deployed to:", verifierAddress);

        console.log("Deploying Password...");
        password = new Password(
            verifierAddress,
            0x2bb710f7345ffdd537637805c5b9c4a45cd03da36a3bbf44dd7b61281add22aa
        );
        address passwordAddress = address(password);
        console.log("Password deployed to:", passwordAddress);

        vm.stopBroadcast();

        console.log("--- Deployment completed ---");
    }
}
