// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.12;

import {ManageableUpgradeable} from "../access/ManageableUpgradeable.sol";
import {IManagement} from "../access/IManagement.sol";
import {ICharacterFactory} from "./ICharacterFactory.sol";
import {ITraitFactory} from "../traits/ITraitFactory.sol";
import {Base64} from "../utils/compression/Base64.sol";

import "hardhat/console.sol";

/// @title A factory for creating and defining characters.
/// @author tempest-sol <email:tempest@stableinternetmoney.com>
/// @notice This is a contract that is meant to be access controlled and not callable without permissions.
/// @notice This includes both reading and writing sensative character specific data.
/// @dev Both 'Management' and 'TraitFactory' contracts must be deployed prior to instantiation of this factory.
contract CharacterFactory is ICharacterFactory, ManageableUpgradeable {
    using Base64 for bytes;

      ///////////////////////
     ///     Storage     ///
    ///////////////////////
    ITraitFactory public traitFactory;

    /// @dev Holds reference to character ids (max of 255) to their definition.
    mapping(uint8 => Character) internal characters;

    /// @dev Character Ids for mapping key constraints.
    uint8[] internal characterIds;

      ///////////////////////
     ///      Events     ///
    ///////////////////////
    event TraitFactoryUpdated(address oldFactory, address newFactory);
    event CharacterCreated(uint8 indexed characterId);
    event CharacterTraitSetCreated(uint8 indexed characterId, string attrName, uint8 traitLength, uint8 colorVariantLength);

    function initialize(address owner, address _management, address factory) public initializer {
        __Manageable_init(owner, _management);
        traitFactory = ITraitFactory(factory);
    }

    /// @inheritdoc ICharacterFactory
    function updateTraitFactory(address factory) external override onlyOwner {
        address old = address(traitFactory);
        traitFactory = ITraitFactory(factory);
        emit TraitFactoryUpdated(old, factory);
    }

    /// @inheritdoc ICharacterFactory
    function createCharacter(
        bytes32 name, 
        bool active, 
        string memory description
    ) external override onlyAdministrator canCreateCharacter {
        uint8 characterId = uint8(characterIds.length);
        characters[characterId] = Character(name, active, description);
        emit CharacterCreated(characterId);
    }

    /// @inheritdoc ICharacterFactory
    function createCharacterTraitSet(
        uint8 characterId, 
        bytes32 attrName, 
        uint8 traitLength, 
        uint8 colorVariantLength
    ) external override onlyAdministrator {
        require(traitLength <= type(uint8).max, "exceeds_maximum_traits");
        require(colorVariantLength <= type(uint8).max, "exceeds_maximum_variants");
        require(attrName.length > 0, "attribute_name_cannot_be_zero");
        require(characterIds.length >= characterId, "character_does_not_exist");

        traitFactory.createTraitSet(characterId, attrName, traitLength, colorVariantLength);
        emit CharacterTraitSetCreated(characterId, string(abi.encodePacked(attrName)), traitLength, colorVariantLength);
    }

    /// @inheritdoc ICharacterFactory
    function populateCharacterTraitSet(
        uint8 characterId, 
        uint8 parent, 
        uint8[] calldata traitIds, 
        ITraitFactory.TraitDefinition[] calldata _traits, 
        ITraitFactory.ColorVariant[][] calldata variants
    ) external override onlyAdministrator {
        require(traitIds.length == _traits.length, "invalid_trait_length");
        traitFactory.populateTraitSet(characterId, parent, traitIds, _traits, variants);
    }
    
    /// @inheritdoc ICharacterFactory
    function addColorVariants(
        uint8 characterId, 
        uint8 parent, 
        uint8 traitId, 
        ITraitFactory.ColorVariant[] calldata variants
    ) external onlyAdministrator {
        traitFactory.addColorVariants(characterId, parent, traitId, variants);
    }

    /// @inheritdoc ICharacterFactory
    function generateRandomCharacter(
        uint8 character, 
        uint256 seed
    ) external override canRead view returns (uint24 traitSetHash) {
        traitSetHash = traitFactory.generateRandomTraitSetHash(character, seed);
    }

    /// @inheritdoc ICharacterFactory
    function encodeCharacterMetadata(
        uint8 character,
        string memory name, 
        string memory description,
        uint24 traitSetHash
    ) external override canRead view returns (string memory metadata) {
        metadata = string(abi.encodePacked(
            '{"name": "', name, '",',
            '"image": "', traitFactory.encodeBase64Image(character, traitSetHash), '",',
            '"description": "', description, '",',
            '"attributes": [', traitFactory.encodeTraitSetAttributesJson(character, traitSetHash)));
        //todo: add new attributes here..
        metadata = string(abi.encodePacked(metadata, ']', "}"));
        metadata = string(abi.encodePacked("data:application/json;base64,", bytes(metadata).base64())); 
    }

    /// @notice Checks if the character length limit has been reached. (Maximum of 255).
    modifier canCreateCharacter() {
        require(characterIds.length + 1 <= type(uint8).max, "max_characters_created");
        _;
    }
}