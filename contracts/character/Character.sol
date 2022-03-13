// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.12;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721, ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

import {ITraitFactory} from "../traits/ITraitFactory.sol";
import {ICharacterFactory} from "./ICharacterFactory.sol";

import "hardhat/console.sol";

contract Character is Ownable, ERC721Enumerable {
    using Strings for uint256;

    mapping(uint256 => uint24) public hashes;

    string public description;

    ICharacterFactory public characterFactory;

    constructor(string memory name, string memory _description, address _characterFactory) ERC721(name, "") {
        description = _description;
        characterFactory = ICharacterFactory(_characterFactory);
    }

    function updateCharacterFactory(address _characterFactory) external {        
        //todo: access control
        characterFactory = ICharacterFactory(_characterFactory);
    }

    function mintRandom() external {
        uint256 tokenId = totalSupply();
        //todo: 0 = random character index
        uint24 traitSetHash = characterFactory.generateRandomCharacter(0, tokenId);
        //console.log("TraitSetHash: ", traitSetHash);
        _mint(msg.sender, tokenId);
        hashes[tokenId] = traitSetHash;
    }
    
    function getTraitSetHash(uint256 tokenId) external view returns (uint24 traitSetHash) {
        traitSetHash = hashes[tokenId];
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        //todo: 0 = characterId
        return characterFactory.encodeCharacterMetadata(0, string(abi.encodePacked(name(), "#", tokenId.toString())), description, hashes[tokenId]);
    }
}