/**
 * This is just a blueprint for a warrior. we don't use chainlink vrf * to mint new warriors for players. warriors when they are first 
 * minted are all the same with exception to the art work. where 
 * chainlink vrf comes in is during the battles, that is in 
 * randomising the dice rolls.
 */

// SPDX-License-Identifier: GPL-3.0 
pragma solidity ^0.6.6;

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

    // since players already exist and own warriors already 
    // how do we need populate all this metadata? 
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
    
    // to know which random number that was requested is for which warrior
    // Keep track of what each player rolled in the battle
    mapping(bytes32 => string) requestToPlayerName;
    // For us to know who is the active player > change the battle screen ie. move their card to the front of the screen
    mapping(bytes32 => address) activePlayerRollDice;
    mapping(bytes32 => uint256) requestToTokenId;

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

    function requestNewLevel0Warrior (string memory playerName) 
        public 
        returns 
        (bytes32) 
    {
        require(LINK.balanceOf(address(this)) >= fee,
                "Not enough LINK - fill contract with faucet"
        );
        bytes32 requestId = requestRandomness(keyHash, fee);
        requestToPlayerName[requestId] = playerName;
        activePlayerRollDice[requestId] = msg.sender;
        return requestId;
    }
    /**
    * @dev which character is this random number associated with
    *
    *
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomNumber)
        internal
        override
    {
        // uint256 newId = characters.length;
        uint8 experience = 0;
        // check warrior level of player
        // randomResult = (randomness % 10) + 1;       // level0
        // randomResult = (randomness % 11) + 1        // level1
        // randomResult = (randomness % 20) + 1        // level4
    }

}
