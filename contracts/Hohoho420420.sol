/*
KKKKKKKKKKKKKKKKKKKKKK--Otherside-2D-Characters--KKKKKKKKKKKKKKKKKKKK
KKKKKKKKKKKKKKKKKKKKKK--Otherside-2D-Characters--KKKKKKKKKKKKKKKKKKKK
KKKKKKKKKKKKKK'''''''''''''''''''''''''''''''''''''''''KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'........................................KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'............KKKKKKKKKKKKKKK.............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'............KK....KKK....KK.............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'............KK....KKK....KK.............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'............KKKKKKKKKKKKKKK.............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'...............KKKKKKKKK................KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'.............KKKKKKKKKKKKK..............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'.............KKKKKKKKKKKKK..............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'......KKKKKKKKKKKKKKKKKKKKKKKKKKK.......KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'......KKKKKKKKKKKKKKKKKKKKKKKKKKK.......KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'.............KKKKKKKKKKKKK..............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'.............KKKKKKKKKKKKK..............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'.............KKKKKKKKKKKKK..............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'.............KKKK.....KKKK..............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'.............KKKK.....KKKK..............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'.............KKKK.....KKKK..............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'.............KKKK.....KKKK..............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'.............KKKK.....KKKK..............KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'........................................KKKKKKKKKKKKKK
KKKKKKKKKKKKKK'''''''''''''''''''''''''''''''''''''''''KKKKKKKKKKKKKK
KKKKKKKKKKKKKKKKKKKKKK--Otherside-2D-Characters--KKKKKKKKKKKKKKKKKKKK
KKKKKKKKKKKKKKKKKKKKKK--Otherside-2D-Characters--KKKKKKKKKKKKKKKKKKKK
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
    uint256 public constant MAX_MINTS = 10;
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant MAX_MINTS_FREE = 3;
    uint256 public constant FREE_MAX_SUPPLY = 1000;
    uint256 public mintRate = 0.002 ether;
    bool public openMint = true;
    bool public revealed = false;
    string public contractURI = "https://tibiaverse.com/api/opensea_meta/";
    string public baseURI = "https://tibiaverse.com/api/opensea_meta/";

    constructor() ERC721A("Hohoho420420", "MBLT") {}

    /******************** PUBLIC ********************/
    function mint(uint256 quantity) external payable {
        require(msg.sender == tx.origin, "Not allowed.");
        require(openMint, "Minting not enable.");
        require(
            quantity + _numberMinted(msg.sender) <= MAX_MINTS,
            "Excess max mint."
        );
        require(
            totalSupply() + quantity <= MAX_SUPPLY,
            "Not enough tokens left."
        );
        if (FREE_MAX_SUPPLY >= totalSupply()) {
            require(MAX_MINTS_FREE >= quantity, "Excess max free mint.");
        } else {
            require(msg.value >= (mintRate * quantity), "Not enough ether.");
        }
        _safeMint(msg.sender, quantity);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
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
            return string(abi.encodePacked(baseURI_, "TokenUri"));
        }
    }

    /******************** OWNER ********************/
    function mint500ForTeam() external onlyOwner {
        require(totalSupply() + 500 <= MAX_SUPPLY, "Not enough tokens left.");
        _safeMint(_msgSender(), 500);
    }

    function withdraw() external payable onlyOwner {
        payable(owner()).transfer(address(this).balance);
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

    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        baseURI = _newBaseURI;
    }

    function setContractURI(string memory _newContractURI) public onlyOwner {
        contractURI = _newContractURI;
    }
}
