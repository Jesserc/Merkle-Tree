// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.5.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.5.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.5.0/utils/cryptography/MerkleProof.sol";

contract MerkleToken is ERC721, Ownable {
  using Counters for Counters.Counter;
  bytes32 public root;

  Counters.Counter private _tokenIdCounter;

  constructor(bytes32 _root) ERC721("MerkleToken", "MERKLE") {
    root = _root;
  }

  function safeMint(address to, bytes32[] memory proof) public {
    require(
      isWhitelisted(proof, keccak256(abi.encodePacked(to))),
      "Error: address not whitelisted"
    );
    uint256 tokenId = _tokenIdCounter.current();
    _tokenIdCounter.increment();
    _safeMint(to, tokenId);
  }

  function isWhitelisted(bytes32[] memory proof, bytes32 leaf)
    public
    view
    returns (bool)
  {
    return MerkleProof.verify(proof, root, leaf);
  }
}

//root = 0x1ff77183e788ec49a77372b8a9b25d257f122d4b9a272d30059db58e0dbbae49
//proof = ["0x1730e4892e0e4c31edf7250c627163f2b55569e6ffad26072b0006b05a959acd","0x9f1cd4464fee066c7b3ae6c21e5571f729f483dd195be66ca8d701d20fee018a"]
//leaf = keccak256(abi.encode(0x4924Fb92285Cb10BC440E6fb4A53c2B94f2930c5)) = 0x81e30fc5f6ceefc4db867a07d8ef67a5f7ddcd62807ef3f43c03a91f21650308
