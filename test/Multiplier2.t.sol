// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {Multiplier2} from "../src/Multiplier2.sol";
import {HonkVerifier} from "../src/verifiers/Multiplier2Verifier.sol";

contract Multiplier2Test is Test {
    HonkVerifier public verifier;
    Multiplier2 public multiplier2;
    address user = makeAddr("user");

    function setUp() public {
        verifier = new HonkVerifier();
        address verifierAddress = address(verifier);
        multiplier2 = new Multiplier2(verifierAddress);
    }

    function _getProof(
        uint256 a,
        uint256 b
    ) internal returns (bytes memory _proof, bytes32 c) {
        uint256 NUM_ARGS = 5;
        string[] memory args = new string[](NUM_ARGS);
        args[0] = "npx";
        args[1] = "tsx";
        args[2] = "js-scripts/generateProofMultiplier2.ts";
        args[3] = vm.toString(a);
        args[4] = vm.toString(b);
        bytes memory encodedProof = vm.ffi(args);
        (_proof, c) = abi.decode(encodedProof, (bytes, bytes32));
    }

    function test_VerifyMul() public {
        vm.prank(user);
        (bytes memory proof, bytes32 c) = _getProof(2, 2);
        bool ok = multiplier2.verifyMul(proof, c);
        assertTrue(ok);
    }

    function test_VerifyMul_Fail() public {
        vm.prank(user);
        (bytes memory proof, bytes32 c) = _getProof(2, 2);
        bytes32 wrongC = bytes32(uint256(c) + 1); // here we are providing a wrong public input
        vm.expectRevert();
        multiplier2.verifyMul(proof, wrongC);
    }
}
