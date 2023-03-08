// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/MulWad.sol";

contract MulWadTests is Test {
    MulWad c;

    function setUp() public {
        c = new MulWad();
    }

    // Fuzz test to check that both mulWad functions appear to be correct.
    function test__MulWadCorrectnessAndEquivalence(uint128 _x, uint128 _y) public {
        uint x = uint(_x);
        uint y = uint(_y);

        uint solution = x * y / c.WAD();
        uint solmate = c.solmateMulWadDown(x, y);
        uint solady = c.soladyMulWad(x, y);

        assertEq(solution, solmate);
        assertEq(solution, solady);
    }
}
