# Using Halmos to Verify Solady vs Solmate

Halmos is particularly good at quickly proving equivalence between functions. Let's use it to verify Solady vs Solmate.

### Sqrt

All differences between the two implementations exist in the first half of the function, so we abstract out the second (identical) half, to leave just the differences.

`test__SqrtCorrectness` uses complete functions to test correctness using fuzz test.

`test__SqrtEquivalence` uses the "stripped" version of the functions, with the identical part removed, to test equivalence.

To run:
- `forge test --match test__SqrtCorrectness`
- `halmos --function test__SqrtEquivalence`
