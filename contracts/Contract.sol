// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

contract Example is EIP712 {
    struct Mail {
        Person from;
        Person to;
        string contents;
    }

    struct Person {
        string name;
        address wallet;
    }

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
    bytes32 private constant MAIL_TYPEHASH =
        keccak256("Mail(Person from,Person to,string contents)");

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

    function hashMail(Mail memory mail) private pure returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    MAIL_TYPEHASH,
                    hashPerson(mail.from),
                    hashPerson(mail.to),
                    keccak256(bytes(mail.contents))
                )
            );
    }

    function hashPerson(Person memory person) private pure returns (bytes32) {
        return keccak256(abi.encode(person.name, person.wallet));
    }

    function verifySignature(
        Person memory from,
        Person memory to,
        string memory contents,
        bytes memory signature
    ) public view returns (bool) {
        Mail memory mail = Mail(from, to, contents);
        bytes32 mailHash = hashMail(mail);
        bytes32 structHash = keccak256(
            abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, mailHash)
        );
        address recoveredSigner = ECDSA.recover(structHash, signature);
        return recoveredSigner == from.wallet;
    }
}

// ["Aditya", "0x2D4742c77824E4faFbee5720AB4Aa34bf3602da8"]
// ["Thakkar","0x0fF73A331A49Da82e2517Cb7Cd1f38283ad75251"]
// xzcczx0x718dae20e0e5379ae5d5a445d2095e76ca39345554743c83fe0887209d9b6db561ea22a2f555e28df687b42a2647a700a7c7486587662901570a3f9cf0c258f01b
