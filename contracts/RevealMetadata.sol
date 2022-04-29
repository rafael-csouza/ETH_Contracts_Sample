// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract RevealMetadata is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    string public baseURI =
        "ipfs://QmaJcJo9e5LKYmZvLvhSSDmLcVMQG1ZMHkpUiMexv1jqxB/";
    bool public revealed = false;

    constructor() ERC721("RevealMetadata", "RevealMD") {}

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function changeBaseURI(string memory baseURI_) public onlyOwner {
        baseURI = baseURI_;
    }

    function changeRevealed(bool _revealed) public onlyOwner {
        revealed = _revealed;
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId + 1);
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
            return string(abi.encodePacked(baseURI_, "hidden.json"));
        }
    }
}
