// SPDX-License-Identifier: GPL-3.0 
pragma solidity ^0.6.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

// Polygon Mainnet  
// LINK Token	    0xb0897686c545045aFc77CF20eC7A532E3120E0F1
// VRF Coordinator	0x3d2341ADb2D31f1c5530cDC622016af293177AE0
// Key Hash	        0xf86195cf7690c55907b2b611ebb7343a6f649bff128701cc542f0569e2c549da
// Fee              0.0001 LINK
contract TheWarriorSpectrumWarriors is ERC721, VRFConsumerBase {
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;
    address public VRFCoordinator;
    address public LinkToken;

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

   constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyhash)
        public
        VRFConsumerBase(_VRFCoordinator, _LinkToken)
        ERC721("TheWarriorSpectrumWarriors", "TWS")
        {
            VRFCoordinator  = _VRFCoordinator;
            LinkToken       = _LinkToken;
            keyHash         = _keyhash;
            fee             = 0.1 * 10**18; // 0.1 LINK
        }

    /**
    * This VRF functionality should be in its own separate file. 
    *
    *
     */
    function requestNewLevel0Warrior (string memory playerName) 
        public 
        returns 
        (bytes32) 
    {
        require(LINK.balanceOf(address(this)) >= fee,
                "Not enough LINK - fill contract with faucet"
        );
        bytes32 requestId = requestRandomness(keyHash, fee);
        // requestToPlayerName[requestId] = playerName;
        // activePlayerRollDice[requestId] = msg.sender;
        return requestId;
    }

    /**
    *   This VRF functionality should be in its own separate file. 
    *   
    *   Idea: make a single multiple request 
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomNumber)
        internal
        override
    {
        uint8 experience = 0;
    }

    /**
    * Renders the NFT on OpenSea
    * 
    *
     */
    function setTokenURI(uint8 tokenId, string memory _tokenURI) public {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        _setTokenURI(tokenId, _tokenURI);
    }

    /**
    * Battle pairings or matching of players are done by VRF 
    *
    *
     */
    function matchPlayer() public returns(bool) {
    }

}
