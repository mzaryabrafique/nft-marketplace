// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../client/node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../client/node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract NFTCollection is ERC721, ERC721Enumerable {
    string[] public tokenURIs;
    mapping(string => bool) _tokenURIExists;
    mapping(uint256 => string) _tokenIdToTokenURI;
    mapping(uint256 => address[]) _itemTrack;

    constructor() ERC721("COMSATS Colllection", "CUI") {}

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
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
        return _tokenIdToTokenURI[tokenId];
    }

    function safeMint(string memory _tokenURI) public {
        require(!_tokenURIExists[_tokenURI], "The token URI should be unique");
        tokenURIs.push(_tokenURI);
        uint256 _id = tokenURIs.length;
        _tokenIdToTokenURI[_id] = _tokenURI;
        setTrack(msg.sender, _id);
        _safeMint(msg.sender, _id);
        _tokenURIExists[_tokenURI] = true;
    }

    function setTrack(address _address, uint256 _id) public returns (bool) {
        _itemTrack[_id].push(_address);
        return true;
    }

    function getTrack(uint256 _id) public view returns (address[] memory) {
        address[] memory users;
        users = _itemTrack[_id];
        return users;
    }
}
