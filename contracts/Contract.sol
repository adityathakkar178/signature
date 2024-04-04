// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract Example {
    uint256 public storedData;

    function set(uint256 x) public {
        storedData = x;
    }

    function get() public view returns (uint256) {
        return storedData;
    }
}