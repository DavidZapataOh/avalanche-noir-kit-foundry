use poseidon::poseidon2::Poseidon2;

fn main(
    // Private input (only the prover knows this)
    password: Field,
    // Public input (everyone can see this)
    expected_hash: pub Field,
) {
    let password_hash = Poseidon2::hash([password], 1);
    assert(expected_hash == password_hash);
}

#[test]
fn test_main() {
    main(5, Poseidon2::hash([5], 1));

    // Uncomment to make test fail
    // main(1, Poseidon2::hash([2], 1));
}
