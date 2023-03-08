// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Sqrt.sol";

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
