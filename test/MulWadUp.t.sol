// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/functions/MulWadUp.sol";

// Halmos isn't able to prove the correctness, because the math to get the correct value in pure Solidity is too complex.
// So we prove the correctness with a fuzz test and then prove the equivalence of the two full functions with Halmos.

// To run:
// - `forge test --match test__MulWadUpCorrectness` (fuzz for correctness of both versions)
// - `halmos --function testCheck__MulWadUpEquivalence` (proves equivalence of two implementations)

contract MulWadUpTests is Test {
    MulWadUp c;

    function setUp() public {
        c = new MulWadUp();
    }

    // Fuzz test to check that both mulWadUp functions appear to be correct.
    function test__MulWadUpCorrectness(uint128 _x, uint128 _y) public {
        uint x = uint(_x);
        uint y = uint(_y);

        uint solution = x * y / c.WAD();
        if (solution * c.WAD() < x * y) {
            solution += 1;
        }

        uint solmate = c.solmateMulWadUp(x, y);
        uint solady = c.soladyMulWadUp(x, y);

        assertEq(solution, solmate);
        assertEq(solution, solady);
    }

    // Symbolic test to confirm that the two functions result in same output.
    function testCheck__MulWadUpEquivalence(uint128 _x, uint128 _y) public {
        uint x = uint(_x);
        uint y = uint(_y);

        uint solmate = c.solmateMulWadUp(x, y);
        uint solady = c.soladyMulWadUp(x, y);

        assertEq(solmate, solady);
    }
}
