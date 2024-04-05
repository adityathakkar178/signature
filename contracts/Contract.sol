// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

contract Example is EIP712 {
    uint256 public storedData;

    constructor() EIP712("Example", "1") {}

    function set(uint256 x) public {
        storedData = x;
    }

    function get() public view returns (uint256) {
        return storedData;
    }

    function verifySignature(
        address signer,
        uint256 value,
        bytes memory signature
    ) public view returns (bool) {
        bytes32 structHash = keccak256(abi.encode(
            keccak256("Verify(address signer,uint256 value)"),
            signer,
            value
        ));
        bytes32 messageHash = _hashTypedDataV4(structHash);
        address recoveredSigner = ECDSA.recover(messageHash, signature);
        return recoveredSigner == signer;
    }
}
