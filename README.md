# Avalanche Noir Kit Foundry

![Banner](images/banner.png)

A professional starter kit for building privacy-preserving decentralized applications (dApps) on **Avalanche** using **Noir** zero-knowledge circuits. 

This kit provides a complete workflow: writing ZK circuits in Noir, generating proofs with TypeScript, and verifying them on-chain using Solidity smart contracts found on Avalanche.

## ⚡ Features

- **Noir Circuits**: Pre-configured circuits for arithmetic operations and cryptographic hashing.
- **Avalanche C-Chain Support**: tailored for deployment on Avalanche's EVM-compatible chain.
- **Foundry Integration**: Professional smart contract development, testing, and deployment environment.
- **TypeScript Scripts**: Automated proof generation and witness calculation.
- **Honk Verifier**: Uses the latest UltraHonk proving system for efficient proofs.

## 🛠 Prerequisites

Ensure you have the following tools installed:

- **[Noir](https://noir-lang.org/docs/getting_started/installation/)**: The ZK circuit language (`nargo`).
- **[Barretenberg](https://barretenberg.aztec.network/docs/getting_started/)**: The proving backend (`bb`).
- **[Foundry](https://book.getfoundry.sh/getting-started/installation)**: Ethereum development framework (`forge`, `cast`, `anvil`).
- **[Node.js](https://nodejs.org/)** & **[Bun](https://bun.sh/)** (or npm/yarn): For running JavaScript/TypeScript scripts.

## 📂 Project Structure

```bash
avalanche-noir-kit-foundry/
├── circuits/           # Noir ZK circuits
│   ├── multiplier2/    # Simple multiplication circuit
│   └── password/       # Private password hashing circuit
├── src/                # Solidity smart contracts
│   ├── verifiers/      # Auto-generated Noir verifiers
│   ├── Multiplier2.sol # Application contract for Multiplier2
│   └── Password.sol    # Application contract for Password
├── script/             # Foundry deployment scripts
├── js-scripts/         # TypeScript scripts for proof generation
├── test/               # Solidity tests
└── foundry.toml        # Foundry configuration
```

## 🧩 Circuits Overview

### 1. Multiplier2
A fundamental circuit that proves knowledge of two factors that multiply to a specific public number.
- **Private Inputs**: `a`, `b`
- **Public Output**: `c = a * b`
- **Use Case**: Proving computation correctness without revealing inputs.

### 2. Password
A privacy-focused circuit that proves a user knows the pre-image (password) of a specific hash without revealing the password itself.
- **Private Input**: `password`
- **Public Input**: `expected_hash`
- **Logic**: `assert(Poseidon2::hash(password) == expected_hash)`
- **Use Case**: Private login, gated access, or commit-reveal schemes.

## 🚀 Getting Started

### 1. Installation

Clone the repository and install dependencies:

```bash
git clone https://github.com/DavidZapataOh/avalanche-noir-kit-foundry.git
cd avalanche-noir-kit-foundry
forge install
bun install # or npm install
```

### 2. Compile Circuits

Navigate to a circuit directory and compile using Nargo:

```bash
cd circuits/multiplier2
nargo check
nargo compile
```

### 3. Generate Verifier Contract

Generate the Solidity verifier contract from your circuit:

First, write the verification key:
```bash
bb write_vk -b ./target/multiplier2.json -o ./target/vk
```

Then, generate the Solidity verifier:
```bash
bb write_solidity_verifier -k ./target/vk -o ../../src/verifiers/Multiplier2Verifier.sol
```

### 4. Deploy to Avalanche

We use Foundry scripts for deployment. You'll need an RPC URL (e.g., Avalanche Fuji) and a Private Key.

**Setup Environment:**
Ensure your `foundry.toml` has the optimizer enabled to fit the verifier within the contract size limit:
```toml
optimizer = true
optimizer_runs = 200
```

**Deploy Command:**

```bash
forge script script/Multiplier2.s.sol:Multiplier2Script \
  --rpc-url https://api.avax-test.network/ext/bc/C/rpc \
  --broadcast \
  --private-key <YOUR_PRIVATE_KEY>
```

### 5. Generate Proofs (Client-Side)

We use TypeScript scripts to generate proofs off-chain.

**Using Bun (Recommended):**
Bun handles TypeScript natively, so you can run the script directly:
```bash
bun run js-scripts/generateProofMultiplier2.ts <input_a> <input_b>
```
Example:
```bash
bun run js-scripts/generateProofMultiplier2.ts 3 4
```

**Using Node:**
If you prefer Node.js, you can use `tsx` to run the TypeScript file:
```bash
npx tsx js-scripts/generateProofMultiplier2.ts 3 4
```
This will create a `proof` file that can be sent to the smart contract.

## 🧪 Testing

Run functionality tests for the smart contracts:

```bash
forge test
```

## 📜 License

This project is licensed under the **MIT License**.
