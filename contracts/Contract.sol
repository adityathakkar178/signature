// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

contract Example is EIP712 {
    struct EIP712Domain {
        string name;
        string version;
        uint256 chainId;
        address verifyingContract;
    }

    bytes32 private constant EIP712_DOMAIN_TYPEHASH =
        keccak256(
            "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
        );
    bytes32 private constant MESSAGE_TYPEHASH =
        keccak256("Message(string message)");

    bytes32 private DOMAIN_SEPARATOR;

    constructor() EIP712("Ether Mail", "1") {
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                EIP712_DOMAIN_TYPEHASH,
                keccak256("Ether Mail"),
                keccak256("1"),
                11155111,
                address(this)
            )
        );
    }

    function verifySignature(
        string memory message,
        bytes memory signature,
        address signerAddress
    ) public view returns (bool) {
        bytes32 messageHash = keccak256(
            abi.encode(MESSAGE_TYPEHASH, keccak256(bytes(message)))
        );
        bytes32 structHash = keccak256(
            abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, messageHash)
        );
        address recoveredSigner = ECDSA.recover(structHash, signature);
        return recoveredSigner == signerAddress;
    }
}
