// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Sqrt.sol";

// All differences between the two implementations exist in the first half of the function,
// so we abstract out the final (identical) piece, to leave just the differences.

// We can then test `solmateSqrt` and `soladySqrt` with a fuzz test to ensure the changes didn't break anything.
// Once this is provide, we can remove the call to the identical internal function,
// leaving `solmateSqrtStripped` and `soladySqrtStripped`, which we can test for equivalence with Halmos.

// To run:
// - `forge test --match test__SqrtCorrectness` (fuzz for correctness of both versions)
// - `halmos --function test__SqrtEquivalence` (symbolic test of equivalence)

contract SqrtTests is Test {
    Sqrt c;

    function setUp() public {
        c = new Sqrt();
    }

    // Fuzz test to check that both complete sqrt functions appear to be correct.
    function test__SqrtCorrectness(uint32 solution, uint32 rand) public {
        vm.assume(solution > 0);

        uint squaredPlus = uint64(solution) * solution + (rand % solution);
        uint solmate = c.solmateSqrt(squaredPlus);
        uint solady = c.soladySqrt(squaredPlus);

        assertEq(solution, solmate);
        assertEq(solution, solady);
    }

    // Symbolic test to confirm that the differences between two functions result in same output.
    function test__SqrtEquivalence(uint x) public {
        uint solmate = c.solmateSqrtStripped(x);
        uint solady = c.soladySqrtStripped(x);
        assertEq(solmate, solady);
    }
}
