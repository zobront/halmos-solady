// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MulWadUp {
    uint256 public constant WAD = 1e18; // The scalar of ETH and most ERC20s.
    uint256 public constant MAX_UINT256 = 2**256 - 1;

    function solmateMulWadUp(uint256 x, uint256 y) public pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // Equivalent to require(denominator != 0 && (y == 0 || x <= type(uint256).max / y))
            if iszero(mul(WAD, iszero(mul(y, gt(x, div(MAX_UINT256, y)))))) {
                revert(0, 0)
            }

            // If x * y modulo the denominator is strictly greater than 0,
            // 1 is added to round up the division of x * y by the denominator.
            z := add(gt(mod(mul(x, y), WAD), 0), div(mul(x, y), WAD))
        }
    }

    function soladyMulWadUp(uint256 x, uint256 y) public pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // Equivalent to `require(y == 0 || x <= type(uint256).max / y)`.
            if mul(y, gt(x, div(not(0), y))) {
                // Store the function selector of `MulWadFailed()`.
                mstore(0x00, 0xbac65e5b)
                // Revert with (offset, size).
                revert(0x1c, 0x04)
            }
            z := add(iszero(iszero(mod(mul(x, y), WAD))), div(mul(x, y), WAD))
        }
    }
}
