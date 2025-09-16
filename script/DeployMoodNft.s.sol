//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "lib/forge-std/src/Script.sol";
import {MoodNft} from "src/MoodNft.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
    function run() external returns (MoodNft) {
        string memory sadSvg = vm.readFile("Img/sad.svg");
        string memory SmileSvg = vm.readFile("Img/smile.svg");
       vm.startBroadcast();
     MoodNft moodNft = new MoodNft(
        svgToImageURI(sadSvg),
        svgToImageURI(SmileSvg)
    );
     vm.stopBroadcast();
     return moodNft;
    }

    function svgToImageURI(string memory svg) public pure returns (string memory) {
        // Prefix for data URI scheme for SVG images
        string memory baseURL = "data:image/svg+xml;base64,";
        // Encode the SVG string to Base64
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg))))
        ;
        // Concatenate the base URL with the Base64-encoded SVG
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }
}
