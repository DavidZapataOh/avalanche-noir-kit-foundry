// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {Password} from "../src/Password.sol";
import {HonkVerifier} from "../src/verifiers/PasswordVerifier.sol";

contract PasswordTest is Test {
    HonkVerifier public verifier;
    Password public password;
    address user = makeAddr("user");
    uint256 constant CORRECT_PASSWORD = 43113;
    bytes32 public expectedHash;

    function setUp() public {
        verifier = new HonkVerifier();
        address verifierAddress = address(verifier);
        (, expectedHash) = _getProof(CORRECT_PASSWORD);
        password = new Password(verifierAddress, expectedHash);
    }

    function _getProof(
        uint256 password
    ) internal returns (bytes memory _proof, bytes32 expected_hash) {
        uint256 NUM_ARGS = 4;
        string[] memory args = new string[](NUM_ARGS);
        args[0] = "npx";
        args[1] = "tsx";
        args[2] = "js-scripts/generateProofPassword.ts";
        args[3] = vm.toString(bytes32(password));
        bytes memory encodedProof = vm.ffi(args);
        (_proof, expected_hash) = abi.decode(encodedProof, (bytes, bytes32));
    }

    function test_VerifyPassword() public {
        vm.prank(user);
        (bytes memory proof, ) = _getProof(43113);
        bool ok = password.verifyPassword(proof);
        assertTrue(ok);
    }

    function test_VerifyPassword_Fail() public {
        vm.prank(user);
        (bytes memory proof, ) = _getProof(43114);
        vm.expectRevert();
        password.verifyPassword(proof);
    }
}
