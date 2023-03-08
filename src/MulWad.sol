// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Minimal division, so Halmos is able to handle this one as-is.
// so we abstract out the final (identical) piece, to leave just the differences.

// To run:
// - `halmos --function test__MulWadCorrectnessAndEquivalence` (proves correctness of both implementations and equivalence)

contract MulWad {
    uint256 public constant WAD = 1e18; // The scalar of ETH and most ERC20s.
    uint256 public constant MAX_UINT256 = 2**256 - 1;

    function solmateMulWadDown(uint256 x, uint256 y) public pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // Equivalent to require(denominator != 0 && (y == 0 || x <= type(uint256).max / y))
            if iszero(mul(WAD, iszero(mul(y, gt(x, div(MAX_UINT256, y)))))) {
                revert(0, 0)
            }

            // Divide x * y by the denominator.
            z := div(mul(x, y), WAD)
        }
    }

    function soladyMulWad(uint256 x, uint256 y) public pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // Equivalent to `require(y == 0 || x <= type(uint256).max / y)`.
            if mul(y, gt(x, div(not(0), y))) {
                // Store the function selector of `MulWadFailed()`.
                mstore(0x00, 0xbac65e5b)
                // Revert with (offset, size).
                revert(0x1c, 0x04)
            }
            z := div(mul(x, y), WAD)
        }
    }
}
