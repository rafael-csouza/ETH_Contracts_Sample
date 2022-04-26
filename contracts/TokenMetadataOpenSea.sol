// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract NFTtutorial is ERC721, Ownable {
    uint256 public mintPrice;
    uint256 public totalSupply;
    uint256 public maxSupply;
    uint256 public maxPerWallet;
    bool public isPublicMintEnable;
    string internal baseTokenUri;
    bytes32 public whitelistMerkleRoot;
    mapping(address => uint256) public walletMints;

    constructor() payable ERC721("Oww Nooo", "ON") {
        mintPrice = 0.001 ether;
        totalSupply = 0;
        maxSupply = 1000;
        maxPerWallet = 10;
        isPublicMintEnable = true;
        baseTokenUri = "http://origin-metaverse.servegame.com/api/opensea_meta/";
    }

    function flipMintState() public onlyOwner {
        isPublicMintEnable = !isPublicMintEnable;
    }

    function setBaseTokenUri(string calldata baseTokenUri_) external onlyOwner {
        baseTokenUri = baseTokenUri_;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(currentBaseURI, Strings.toString(tokenId))
                )
                : "";
    }

    function setWhitelistMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
        whitelistMerkleRoot = _merkleRoot;
    }

    function withdraw(address receiver) public onlyOwner {
        uint256 balance = address(this).balance;
        payable(receiver).transfer(balance);
    }

    function mint(uint256 quantity_) public payable {
        require(isPublicMintEnable, "minting not enable");
        require(msg.value >= quantity_ * mintPrice, "wrong mint value");
        require(totalSupply + quantity_ <= maxSupply, "sold out");
        require(
            walletMints[msg.sender] + quantity_ <= maxPerWallet,
            "exceed max per wallet"
        );

        for (uint256 i = 0; i < quantity_; i++) {
            uint256 newTokenId = totalSupply + 1;
            totalSupply++;
            _safeMint(msg.sender, newTokenId);
        }
    }
}
