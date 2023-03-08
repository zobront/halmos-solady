# Using Halmos to Verify Solady vs Solmate

Halmos is particularly good at quickly proving equivalence between functions. Let's use it to verify Solady vs Solmate.

## FixedPointMathLib Functions

- [x] mulWad
- [x] mulWadUp
- [ ] divWad
- [ ] divWadUp
- [ ] mulDivDown
- [ ] mulDivUp
- [ ] rpow
- [x] sqrt
- [ ] unsafeMod
- [ ] unsafeDiv
- [ ] unsafeDivUp

## Detailed Breakdown
### ✅ sqrt()

To run:
- `forge test --match test__SqrtCorrectness` (fuzz for correctness of both versions)
- `halmos --function test__SqrtEquivalence` (symbolic test of equivalence)

Explanation: All differences between the two implementations exist in the first half of the function, so we abstract out the final (identical) piece, to leave just the differences. We can then test `solmateSqrt` and `soladySqrt` with a fuzz test to ensure the changes didn't break anything. Once this is provide, we can remove the call to the identical internal function, leaving `solmateSqrtStripped` and `soladySqrtStripped`, which we can test for equivalence with Halmos.

### ✅ mulWad()

To run:
- `halmos --function test__MulWadCorrectnessAndEquivalence` (proves correctness of both implementations and equivalence)

Explanation: This one is relatively simple with minimal division, so Halmos can handle the functions as-is. We simply compare them both to a non-assembly non-optimized version, and prove equivalence.

### ✅ mulWadUp()

To run:
- `forge test --match test__MulWadUpCorrectness` (fuzz for correctness of both versions)
- `halmos --function test__MulWadUpEquivalence` (proves equivalence of two implementations)

Explanation: Halmos isn't able to prove the correctness, because the math to get the correct value in pure Solidity is too complex. So we prove the correctness with a fuzz test and then prove the equivalence of the two full functions with Halmos.
