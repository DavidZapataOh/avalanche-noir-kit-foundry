fn main(a: Field, b: Field) -> pub Field {
    let c = a * b;
    c
}

#[test]
fn test_main() {
    assert(main(2, 2) == 4);
}
