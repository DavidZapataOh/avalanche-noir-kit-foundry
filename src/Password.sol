// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IVerifier} from "./verifiers/IVerifier.sol";

contract Password {
    IVerifier public verifier;
    bytes32 public immutable expectedHash;

    error InvalidProof();

    event Verified(address indexed user, bytes32 expectedHash);

    constructor(address _verifier, bytes32 _expectedHash) {
        verifier = IVerifier(_verifier);
        expectedHash = _expectedHash;
    }

    function verifyPassword(bytes calldata proof) public returns (bool) {
        bytes32[] memory publicInputs = new bytes32[](1);
        publicInputs[0] = expectedHash;
        bool result = verifier.verify(proof, publicInputs);
        if (!result) {
            revert InvalidProof();
        }

        emit Verified(msg.sender, expectedHash);
        return true;
    }
}
