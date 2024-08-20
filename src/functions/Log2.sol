// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Log2 {

    // Code that is correct -- log2 is the most significant 1 bit 
    // Note: log2(0) returns 0 instead of reverting
    function correctLog2(uint256 x) public pure returns (uint256 r) {
        for(r = 255; r >= 0; r--) {
            if (x >> r & uint256(1) == 1) {
                break;
            }
        }
    }

    function soladyLog2(uint256 x) public pure returns (uint256 r) {
        /// @solidity memory-safe-assembly
        assembly {
            r := shl(7, lt(0xffffffffffffffffffffffffffffffff, x))
            r := or(r, shl(6, lt(0xffffffffffffffff, shr(r, x))))
            r := or(r, shl(5, lt(0xffffffff, shr(r, x))))
            r := or(r, shl(4, lt(0xffff, shr(r, x))))
            r := or(r, shl(3, lt(0xff, shr(r, x))))
            // forgefmt: disable-next-item
            r := or(r, byte(and(0x1f, shr(shr(r, x), 0x8421084210842108cc6318c6db6d54be)),
                0x0706060506020504060203020504030106050205030304010505030400000000))
        }
    }
}
