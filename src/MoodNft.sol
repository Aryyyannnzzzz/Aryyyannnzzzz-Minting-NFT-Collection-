// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    error MoodNFT__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_smileSvgImageUri; // Corrected variable name
    string private s_sadSvgImageUri; // Corrected variable name

    enum Mood { // Enum name casing corrected to 'Mood'
        Smile,
        sad // Ensure this matches your usage case

    }

    mapping(uint256 => Mood) private s_tokenIdToMood; // Should match the enum name

    constructor(
        string memory smileSvgImageUri,
        string memory sadSvgImageUri
        )
         ERC721("MoodNft", "MN") {
        s_tokenCounter = 0;
        s_sadSvgImageUri = sadSvgImageUri; // Fixed variable name
        s_smileSvgImageUri = smileSvgImageUri; // Fixed variable name
    }

    function mintNft() external {
        _safeMint(msg.sender, s_tokenCounter);
        // To mint a Sad mood or Smile mood, it might be better to have a parameter
        s_tokenIdToMood[s_tokenCounter] = Mood.Smile; // Matches enum name
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public view {
    if(getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender){
        revert MoodNFT__CantFlipMoodIfNotOwner();
    }

    if(s_tokenIdToMood[tokenId] == Mood.Smile){
        s_tokenIdToMood[tokenId] == Mood.sad;
    } else{
        s_tokenIdToMood[tokenId] == Mood.Smile;
    }
}

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI; // Declare imageURI

        if (s_tokenIdToMood[tokenId] == Mood.Smile) {
            imageURI = s_smileSvgImageUri; // Fixed variable name
        } else {
            imageURI = s_sadSvgImageUri; // Fixed variable name
        }

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "', // Fixed JSON key format
                            name(),
                            '", "description": "An NFT that reflects your mood!", "attributes": [{"trait_type": "Mood", "value": ',
                            uint256(s_tokenIdToMood[tokenId]) == 0 ? '"Smile"' : '"Sad"', // Example value, determine how you want to represent mood
                            '}], "image": "',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }
}
