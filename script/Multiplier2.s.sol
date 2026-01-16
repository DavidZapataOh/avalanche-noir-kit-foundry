// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Script, console} from "forge-std/Script.sol";
import {Multiplier2} from "../src/Multiplier2.sol";
import {HonkVerifier} from "../src/verifiers/Multiplier2Verifier.sol";

contract Multiplier2Script is Script {
    HonkVerifier public verifier;
    Multiplier2 public multiplier2;

    function setUp() public {}

    function run() public {
        console.log("--- Deployment started ---");
        vm.startBroadcast();

        console.log("Deploying Verifier...");
        verifier = new HonkVerifier();
        address verifierAddress = address(verifier);
        console.log("Verifier deployed to:", verifierAddress);

        console.log("Deploying Multiplier2...");
        multiplier2 = new Multiplier2(verifierAddress);
        address multiplier2Address = address(multiplier2);
        console.log("Multiplier2 deployed to:", multiplier2Address);

        vm.stopBroadcast();

        console.log("--- Deployment completed ---");
    }
}
