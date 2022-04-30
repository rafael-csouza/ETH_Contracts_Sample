// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MiaLet420 is ERC721A, Ownable {
    uint256 MAX_MINTS = 50;
    uint256 MAX_SUPPLY = 100;
    uint256 public mintRate = 0.0001 ether;
    bool public openMint = true;

    string public contractURI = "https://apinpoint.io/6e0cf3dcd6825c140140/";
    string public baseURI =
        "ipfs://bafybeieyetlp2c2vubffzjjap7utuz5jwo2k5b5kupvezfchc5tnfg4fh4/";

    constructor() ERC721A("MiaLet420", "MBLT") {}

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

    function setMintRate(uint256 _mintRate) public onlyOwner {
        mintRate = _mintRate;
    }

    function setContracURI(string memory _newContractURI) public onlyOwner {
        contractURI = _newContractURI;
    }

    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        baseURI = _newBaseURI;
    }
}
