// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Sqrt.sol";

contract SqrtTests is Test {
    Sqrt s;

    function setUp() public {
        s = new Sqrt();
    }

    // Fuzz test to check that both complete sqrt functions appear to be correct.
    function test__SqrtCorrectness(uint32 solution, uint32 rand) public {
        vm.assume(solution > 0);

        uint squaredPlus = uint64(solution) * solution + (rand % solution);
        uint solmate = s.solmateSqrt(squaredPlus);
        uint solady = s.soladySqrt(squaredPlus);

        assertEq(solution, solmate);
        assertEq(solution, solady);
    }

    // Symbolic test to confirm that the differences between two functions result in same output.
    function test__SqrtEquivalence(uint x) public {
        uint solmate = s.solmateSqrtStripped(x);
        uint solady = s.soladySqrtStripped(x);
        assertEq(solmate, solady);
    }
}
