// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.7/VRFConsumerBase.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// Polygon (Matic) Mumbai Testnet
// LINK Token	    0x326C977E6efc84E512bB9C30f76E30c160eD06FB
// VRF Coordinator	0x8C7382F9D8f56b33781fE506E897a4F1e2d17255
// Key Hash	0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4
// Fee	            0.0001 LINK

// Binance Smart Chain Testnet
// LINK	            0x84b9B910527Ad5C03A9Ca831909E21e236EA7b06
// VRF Coordinator	0xa555fC018435bef5A13C6c6870a9d4C11DEC329C
// Key Hash	0xcaf3c3727e033261d383b315559476f48034c13b18f8cafed4d871abe5049186
// Fee	            0.1 LINK

contract TheWarriorSpectrumWarriors is ERC721, VRFConsumerBase, Ownable {
    using SafeMath for uint256;
    using Strings for string;

    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;
    address public VRFCoordinator;
    address public LinkToken;

    struct Player {
        string playerProfile;
        uint8 rollNumber;
        uint8 wins;
        uint8 losses;
    }

    // Having multiple VRF requests in flight - one for each player on their turn 
    mapping(bytes32 => address) public requestIdToAddress;

    constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyhash)
        public
        VRFConsumerBase(_VRFCoordinator, _LinkToken)
        ERC721("TheWarriorSpectrum", "TWS")
        {
            VRFCoordinator  = _VRFCoordinator;
            LinkToken       = _LinkToken;
            keyHash         = _keyhash;
            fee             = 0.1 * 10**18; // 0.1 LINK
        }

    /**
    * When the user clicks on roll dice, it uses Chainlink VRF to get * a random number 
    * 
    * @return returns random number between 1-x, where x is the size of the player's dice
    *
    * */
    function requestRandomNumber() 
        public 
        returns (bytes32) {
        require(
            LINK.balanceOf(address(this)) >= fee,
            "Not enough LINK - fill contract with faucet"
        );
        bytes32 requestId = requestRandomness(keyHash, fee);
        requestIdToAddress[requestId] = msg.sender;
        return requestId;
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomNumber) 
        internal 
        override 
    {
        // player level 0 <> 10-sided dice % 10
        uint256 diceRoll1 = (randomNumber % 10) + 1;
        uint256 diceRoll2 = (randomNumber % 10) + 2; 
        uint256 diceRoll3 = (randomNumber % 10) + 3;  
    
        address requestAddress = requestIdToAddress[requestId];
    }
}


