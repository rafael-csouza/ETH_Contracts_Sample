// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BiletZehNFT is ERC721A, Ownable {
    string public baseURI =
        "ipfs://bafybeieyetlp2c2vubffzjjap7utuz5jwo2k5b5kupvezfchc5tnfg4fh4/";
    string public contractURI = "https://api.npoint.io/6e0cf3dcd6825c140140/";

    bool public MINT_ENABLE = true;
    uint256 public MAX_MINTS = 10;
    uint256 public MAX_SUPPLY = 1000;
    uint256 public MINT_RATE = 0.0001 ether;

    mapping(address => uint256) public walletMints;

    constructor() ERC721A("BiletZehNFT", "BLTZEH") {}

    function MINT(uint256 quantity) external payable {
        require(MINT_ENABLE, "Minting not enable.");
        require(msg.value >= (MINT_RATE * quantity), "Not enough ether sent");
        require(
            quantity + _numberMinted(msg.sender) <= MAX_MINTS,
            "Exceeded the wallet limit."
        );
        require(totalSupply() + quantity <= MAX_SUPPLY, "Tokens sold out.");
        _safeMint(msg.sender, quantity);
    }

    function WITHDRAW() external payable {
        payable(owner()).transfer(address(this).balance);
    }

    function FLIP_MINT_ENABLE() public onlyOwner {
        MINT_ENABLE = !MINT_ENABLE;
    }

    function SET_MINT_RATE(uint256 _MINT_RATE) public onlyOwner {
        MINT_RATE = _MINT_RATE;
    }

    function SET_BASE_URI(string memory baseURI_) public onlyOwner {
        baseURI = baseURI_;
    }

    function SET_CONTRACT_URI(string memory contractURI_) public onlyOwner {
        contractURI = contractURI_;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }
}
