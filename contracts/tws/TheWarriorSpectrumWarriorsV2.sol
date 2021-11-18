// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// Polygon Mainnet
// LINK Token	    0xb0897686c545045aFc77CF20eC7A532E3120E0F1
// VRF Coordinator	0x3d2341ADb2D31f1c5530cDC622016af293177AE0
// Key Hash	        0xf86195cf7690c55907b2b611ebb7343a6f649bff128701cc542f0569e2c549da
// Fee              0.0001 LINK
contract TheWarriorSpectrumWarriorsV2 is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;

    struct Warrior {
        string playerProfile;
        string character;
        uint8 level;
        uint8 rollNumber;
        uint8 wins;
        uint8 losses;
        uint8 expPoints;
    }

    Warrior[] public warriors;

    // mapping(bytes32 => string) requestToPlayerName;
    // mapping(bytes32 => address) activePlayerRollDice;
    // mapping(bytes32 => uint256) requestToTokenId;

    mapping(uint256 => string) private _tokenURIs;

    string private _baseURIextended;
    Counters.Counter private _tokenIdCounter;

    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant PRICE_PER_TOKEN = 0.001 ether;

    constructor() ERC721("TheWarriorSpectrumWarriors", "TWS") {}

    function mint(address _to, string memory metadataURI) public onlyOwner {
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        _mint(_to, tokenId);
        _setTokenURI(tokenId, metadataURI);
    }

    function setBaseURI(string memory baseURI_) external onlyOwner() {
        _baseURIextended = baseURI_;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal
    override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

}
