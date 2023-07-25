// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/functions/MulWad.sol";

// Halmos is able to handle this one exactly as-is.

// To run:
// - `halmos --function testCheck__MulWadCorrectnessAndEquivalence` (proves correctness of both implementations and equivalence)

contract MulWadTests is Test {
    MulWad c;

    function setUp() public {
        c = new MulWad();
    }

    // Fuzz test to check that both mulWad functions appear to be correct.
    function testCheck__MulWadCorrectnessAndEquivalence(uint128 _x, uint128 _y) public {
        uint x = uint(_x);
        uint y = uint(_y);

        uint solution = x * y / c.WAD();
        uint solmate = c.solmateMulWadDown(x, y);
        uint solady = c.soladyMulWad(x, y);

        assertEq(solution, solmate);
        assertEq(solution, solady);
    }
}
