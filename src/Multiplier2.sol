// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IVerifier} from "./verifiers/IVerifier.sol";

contract Multiplier2 {
    IVerifier public verifier;

    error InvalidProof();

    event Verified(address indexed user, bytes32 c);

    constructor(address _verifier) {
        verifier = IVerifier(_verifier);
    }

    function verifyMul(bytes calldata proof, bytes32 c) public returns (bool) {
        bytes32[] memory publicInputs = new bytes32[](1);
        publicInputs[0] = c; // c = a * b (a and b are private inputs)
        bool result = verifier.verify(proof, publicInputs);
        if (!result) {
            revert InvalidProof();
        }

        emit Verified(msg.sender, c);
        return true;
    }
}
