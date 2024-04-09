// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

import "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

contract Example is EIP712 {
    struct EIP712Domain {
        string name;
        string version;
        uint256 chainId;
        address verifyingContract;
    }

    bytes32 private constant MESSAGE_TYPEHASH =
        keccak256("Message(string message, uint256 value, address sender)");

    constructor() EIP712("Ether Mail", "1") {}

    function verifySignature(
        string memory message,
        uint256 value,
        address senderAddress,
        bytes memory signature,
        address signerAddress
    ) public view returns (bool) {
        bytes32 messageHash = keccak256(
            abi.encode(
                MESSAGE_TYPEHASH,
                keccak256(bytes(message)),
                value,
                senderAddress
            )
        );
        bytes32 structHash = _hashTypedDataV4(messageHash);
        return
            SignatureChecker.isValidSignatureNow(
                signerAddress,
                structHash,
                signature
            );
    }
}
