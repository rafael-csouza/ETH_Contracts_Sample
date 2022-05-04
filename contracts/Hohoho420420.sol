/*
KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
KKKKKKKKKKKKKK'''''''''''''''''''''''''''''''''''''''''KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'........................................KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'........................................KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'............|||||FIRE|||||..............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'..............|||FIRE|||................KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'................|FIRE|..................KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'................|FIRE|..................KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'............KKKKKKKKKKKKKKK.............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'............KKKKKKKKKKKKKKK.............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'............KKKKKKKKKKKKKKK.............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'............KKKKKKKKKKKKKKK.............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'............KKKKKKKKKKKKKKK.............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'............KKKKKKKKKKKKKKK.............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'............KKKKKKKKKKKKKKK.............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'............KKKKKKKKKKKKKKK.............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'............KKKKKKKKKKKKKKK.............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'............KKKKKKKKKKKKKKK.............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'............KKKKKKKKKKKKKKK.............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'''''''''''''''''''''''''''''''''''''''''KKKKKKKKKKKKKK
KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Hohoho420420 Contract
 * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
 */

contract Hohoho420420 is ERC721A, Ownable {
    uint256 MAX_MINTS = 50;
    uint256 MAX_SUPPLY = 100;
    uint256 public mintRate = 0.0001 ether;
    bool public openMint = true;
    bool public revealed = true;

    string public contractURI =
        "https://api-next-js-hazel.vercel.app/api/contractURI";
    string public baseURI = "https://api-next-js-hazel.vercel.app/metadata/";

    constructor() ERC721A("Hohoho420420", "MBLT") {}

    function mint(uint256 quantity) external payable {
        require(openMint, "Minting not enable.");
        require(
            quantity + _numberMinted(msg.sender) <= MAX_MINTS,
            "Exceeded the limit."
        );
        require(
            totalSupply() + quantity <= MAX_SUPPLY,
            "Not enough tokens left."
        );
        require(msg.value >= (mintRate * quantity), "Not enough ether.");
        _safeMint(msg.sender, quantity);
    }

    function withdraw() external payable onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function flipMintState() public onlyOwner {
        openMint = !openMint;
    }

    function flipRevealed() public onlyOwner {
        revealed = !revealed;
    }

    function setMintRate(uint256 _mintRate) public onlyOwner {
        mintRate = _mintRate;
    }

    function setContracURI(string memory _newContractURI) public onlyOwner {
        contractURI = _newContractURI;
    }

    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        baseURI = _newBaseURI;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory baseURI_ = _baseURI();

        if (revealed) {
            return
                bytes(baseURI_).length > 0
                    ? string(
                        abi.encodePacked(baseURI_, Strings.toString(tokenId))
                    )
                    : "";
        } else {
            return string(abi.encodePacked(baseURI_, "hidden"));
        }
    }
}
