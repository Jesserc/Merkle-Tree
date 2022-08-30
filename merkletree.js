const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");

const whiteListAddresses = [
  "0x571B102323C3b8B8Afb30619Ac1d36d85359fb84",
  "0x6F67207Ca079A26Fdfe3b0B8bD71814D75Ac048D",
  "0xFE907E1609ac1530b8520298eDa12E61e9d71fb7",
  "0x4924Fb92285Cb10BC440E6fb4A53c2B94f2930c5",
];

const leafNodes = whiteListAddresses.map((address) => keccak256(address));
const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true });

//get root hash of merkle tree
const rootHash = merkleTree.getRoot();
//helper function to convert buffer to hex
const buff2Hex = (x) => "0x" + x.toString("hex");
//log merkle tree object
console.log("Whitelisted addresses Merkle Tree:\n", merkleTree.toString("hex"));
//log root hash in hex format
console.log("Root hash:\n", buff2Hex(rootHash));
console.log("==============================================");
console.log("==============================================");
console.log("==============================================");
const claimingAddress = leafNodes[3];
const hexProof = merkleTree.getHexProof(claimingAddress);
console.log("Hex proof of address:\n", hexProof);

// verify that claiming address is in the merkle tree or not.
console.log(merkleTree.verify(hexProof, claimingAddress, rootHash));
