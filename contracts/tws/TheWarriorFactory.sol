// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "./TheWarriorSpectrumWarriors.sol";
import "./TheWarriorSpectrumElemental.sol";
import "./Interfaces/IFactoryERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// Polygon Mainnet
// LINK Token	    0xb0897686c545045aFc77CF20eC7A532E3120E0F1
// VRF Coordinator	0x3d2341ADb2D31f1c5530cDC622016af293177AE0
// Key Hash	        0xf86195cf7690c55907b2b611ebb7343a6f649bff128701cc542f0569e2c549da
// Fee              0.0001 LINK
contract TheWarriorFactory is FactoryERC721, Ownable {
    using Counters for Counters.Counter;

    //Ideally those would be proxies
    TheWarriorSpectrumWarriors warriorContract;
    TheWarriorSpectrumElemental elementalContract;

    mapping(uint256 => string) metadata;
    mapping(uint256 => string) metadataElemental;

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    event WarriorBorn(
        uint256 indexed option,
        address indexed to,
        uint256 date
    );

    uint256 NUM_OPTIONS = 8;
    uint256 NINJA_OPTION = 0;
    uint256 SPARTAN_OPTION = 1;
    uint256 GLADIATOR_OPTION = 2;
    uint256 CELTIC_OPTION = 3;
    uint256 TEMPLAR_OPTION = 4;
    uint256 IMMORTAL_OPTION = 5;
    uint256 ASSASSIN_OPTION = 6;
    uint256 MUAYTHAI_OPTION = 7;

    //elementals
    uint256 E_EARHT_OPTION = 0;
    uint256 E_WIND_OPTION = 1;
    uint256 E_FIRE_OPTION = 2;
    uint256 E_WATER_OPTION = 3;

    string public baseURI = "https://ipfs.io/ipfs/";

    constructor() {
        metadata[NINJA_OPTION] = 'QmWuQ2c88SMzaTrYxSZXwYgQ4w8MWVwr1pAba7kUaHHMFz';
        metadata[SPARTAN_OPTION] = 'QmWUF76u726kkx3EehYS3HYfouhTLSbzu4MFBPHNjadi18';
        metadata[GLADIATOR_OPTION] = 'QmY2H7LYrQ6kmWRtQFYLMrAXToj1e1XU5wMSdNi3c6sb1z';
        metadata[CELTIC_OPTION] = 'QmQeeh6uep7qwQM8ajjaCMnuuwH8mESTcQBpXzeovDvSDA';
        metadata[TEMPLAR_OPTION] = 'QmZpqw24PKGPxQrPcamFmvr776tjUdh2K4NSb4T3baJQg9';
        metadata[IMMORTAL_OPTION] = 'QmQtyoq7RGzbTgqV79k64rjNCMj8owR7MVygKkYDTMAUiT';
        metadata[ASSASSIN_OPTION] = 'Qma8TXkT2f3xrCNuAU3URfSLT8dVjjM7QL5PnB31LKh4uy';
        metadata[MUAYTHAI_OPTION] = 'QmVFbaap3zyD8N3hd5VreH32vDJqmKhGc5Ycwu4n6ED5HE';

        metadataElemental[E_EARTH_OPTION] = 'QmbvwfWAnRDRz16YLQeP6NhyytEbaL2S7KfGpgcGmm7tEd';
        metadataElemental[E_WIND_OPTION] = 'QmQ4RkAXwTk9xDZvdsWKjnsfAeLKKgjy6X7nh8uFQXhyea';
        metadataElemental[E_FIRE_OPTION] = 'QmRd4rx2qCGfGViQ1QEn6irTnafuPkZqimNsEQTPaRMZXW';
        metadataElemental[E_WATER_OPTION] = 'QmbjyVyg18YPGNzYCHMquePESEJUBHqqNqkJqRxcCTAWH2';
    }

    function setupContracts(address _warriorContract, address _elementalContract) public  {
        warriorContract = TheWarriorSpectrumWarriors(_warriorContract);
        elementalContract = TheWarriorSpectrumElemental(_elementalContract);
    }

    function name() override external pure returns (string memory) {
        return "The Warrior Factory";
    }

    function symbol() override external pure returns (string memory) {
        return "WFAC";
    }

    function supportsFactoryInterface() override public pure returns (bool) {
        return true;
    }

    function numOptions() override public view returns (uint256) {
        return NUM_OPTIONS;
    }

    function mint(uint256 _optionId, address _to) override public {
        bytes memory currentMetadata = bytes(metadata[_optionId]);
        require(currentMetadata.length > 0, "Warrior_Factory::Type not found.");
        warriorContract.mint(_to, metadata[_optionId]);
    }

    //maybe we could mint the elemetals from here idk if that's the best tho onlyMinter
    /*
    function mintElemental(uint256 _optionId, address _to) override onlyOwner {

    }*/

    function canMint(uint256 _optionId) override public view returns (bool) {
        return true;
    }

    function tokenURI(uint256 _optionId) override external view returns (string memory) {
        return string(abi.encodePacked(baseURI, metadata[_optionId]));
    }

    function setBaseURI(string memory uri) public onlyOwner {
        baseURI = uri;
    }

    function addMetadata(uint256 _optionId, string memory _cid) public onlyOwner {
        bytes memory currentMetadata = bytes(metadata[_optionId]);
        require(currentMetadata.length == 0, "Warrior_Factory::Metadata already set.");
        metadata[_optionId] = _cid;
    }

    function setMetadata(uint256 _optionId, string memory _cid) public onlyOwner {
        bytes memory currentMetadata = bytes(metadata[_optionId]);
        require(currentMetadata.length > 0, "Warrior_Factory::Type not found.");
        metadata[_optionId] = _cid;
    }
}
