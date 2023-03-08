# Using Halmos to Verify Solady vs Solmate

Halmos is particularly good at quickly proving equivalence between functions. Let's use it to verify Solady vs Solmate.

### ✅ sqrt()

To run:
- `forge test --match test__SqrtCorrectness` (fuzz for correctness of both versions)
- `halmos --function test__SqrtEquivalence` (symbolic test of equivalence)

Explanation: All differences between the two implementations exist in the first half of the function, so we abstract out the final (identical) piece, to leave just the differences. We can then test `solmateSqrt` and `soladySqrt` to ensure the changes didn't break anything. Then we can remove the call to the identical internal function. This leaves us with `solmateSqrtStripped` and `soladySqrtStripped`, which we can test for equivalence.

### To Do

- [ ] mulWadDown
- [ ] mulWadUp
- [ ] divWadDown
- [ ] divWadUp
- [ ] mulDivDown
- [ ] mulDivUp
- [ ] rpow
- [ ] unsafeMod
- [ ] unsafeDiv
- [ ] unsafeDivUp
