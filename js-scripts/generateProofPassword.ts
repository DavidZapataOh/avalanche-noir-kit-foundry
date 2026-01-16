import { Noir } from "@noir-lang/noir_js";
import { UltraHonkBackend, Barretenberg, Fr } from "@aztec/bb.js";
import { ethers } from "ethers";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const circuitPath = path.resolve(__dirname, "../circuits/password/target/password.json");
const circuit = JSON.parse(fs.readFileSync(circuitPath, "utf-8"));

const FIELD_MODULUS =
  21888242871839275222246405745257275088548364400416034343698204186575808495617n;

function toBytes32Hex(x: bigint): string {
  let hex = x.toString(16);
  if (hex.length > 64) hex = hex.slice(hex.length - 64);
  return "0x" + hex.padStart(64, "0");
}

async function generateProof() {
  const [passwordStr] = process.argv.slice(2);

  const bb = await Barretenberg.new();
  const password = Fr.fromString(passwordStr);

  const expectedHashFr = await bb.poseidon2Hash([password]);

  const inputs = {
    password: password.toString(),
    expected_hash: expectedHashFr.toString(),
  };

  const noir = new Noir(circuit);
  const honk = new UltraHonkBackend(circuit.bytecode, { threads: 1 });

  const { witness } = await noir.execute(inputs);

  const originalLog = console.log;
  console.log = () => {};
  const { proof } = await honk.generateProof(witness, { keccak: true });
  console.log = originalLog;

  const expectedHashBig = BigInt(expectedHashFr.toString());
  const expectedHashBytes32 = toBytes32Hex(expectedHashBig);

  const encoded = ethers.AbiCoder.defaultAbiCoder().encode(
    ["bytes", "bytes32"],
    [proof, expectedHashFr.toBuffer()]
  );

  return encoded;
}

(async () => {
  try {
    const encoded = await generateProof();
    process.stdout.write(encoded);
    process.exit(0);
  } catch (err) {
    console.error(err);
    process.exit(1);
  }
})();
