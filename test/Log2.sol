// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/functions/Log2.sol";

// Halmos is able to handle this one exactly as-is.

// To run:
// - `halmos --match-test Log2 --loop 256 --function test` (proves that Solady log 2 matches the definition)

contract Log2Tests is Test {
    Log2 c;

    function setUp() public {
        c = new Log2();
    }

    // Check that Solady Log2 matches the definition solution 
    function testCheck__Log2Equivalence(uint256 x) public {

        uint correct = c.correctLog2(x);
        uint solady = c.soladyLog2(x);

        assertEq(correct, solady);
    }
}
