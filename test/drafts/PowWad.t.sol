// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/PowWad.sol";

// This one doesn't work for Halmos because it requires SIGNEXTEND op code, which isn't implemented yet.

// To run:
// -`forge test --match test__PowWadCorrectness` (fuzz test for correctness of Solady implementation)

contract PowWadTests is Test {
    PowWad c;
    int constant DENOMINATOR = 10_000;

    function setUp() public {
        c = new PowWad();
    }

    // Fuzz test to check that PowWad drifts by max 0.01% from correct solution.
    function test__PowWadCorrectness(uint8 _x, int8 _y) public {
        vm.assume(_x > 0);
        int x = int(uint(_x));
        int y = int(bound(_y, -10, 10));

        (int solution, int solady, uint driftPercentage) = powWadCalculations(x, y);
        assert(driftPercentage < 1);
    }

    function powWadCalculations(int x, int y) public returns (int solution, int solady, uint driftPercentage) {
        if (y == 0) {
            solution = 1;
        } else if (y > 0) {
            solution = int(uint(x) ** uint(y));
        } else if (y < 0) {
            solution = int(1 / (uint(x) ** uint(-y)));
        }
        solution = solution * int(c.WAD());
        solady = c.powWad(x * int(c.WAD()), y * int(c.WAD()));

        if (solution != 0) {
            driftPercentage = uint((solution - solady) * DENOMINATOR / solution);
        }
    }
}
