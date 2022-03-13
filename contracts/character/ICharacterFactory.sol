// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.12;

import {IManageable} from "../access/IManageable.sol";
import {ITraitFactory} from "../traits/ITraitFactory.sol";

/// @notice This is a contract that is meant to be access controlled and not callable without permissions.
/// @notice This includes both reading and writing sensative character specific data.
/// @dev Both 'Management' and 'TraitFactory' contracts must be deployed prior to instantiation of this factory.
interface ICharacterFactory is IManageable {

    struct Character {
        bytes32 name;
        bool isActive;
        string description;
    }

    /// @notice Updates the contract used for creating traits. 
    /// @param factory The address of the new factory contract.
    function updateTraitFactory(address factory) external;

    /// @notice Creates a base character.
    /// @dev Creates the base wireframe of a character to add traits too.
    /// @dev Only subscribed administrators to the 'Management' contract can add.
    /// @param name The name of the character for metadata.
    /// @param active If the character is active and able to be used.
    /// @param description The description of the character for metadata.
    function createCharacter(bytes32 name, bool active, string memory description) external;

    /// @notice Creates an initial set of traits to define a character.
    /// @dev Creates a framework and sets sizes of an initial trait and variant set for a character.
    /// @dev Only subscribed administrators to the 'Management' contract can add.
    /// @param characterId The characterId of the trait set to update.
    /// @param attrName The name of the trait for metadata.
    /// @param traitLength The length of the initial trait set.
    /// @param colorVariantLength The length of the initial color variant set for the trait.
    function createCharacterTraitSet(uint8 characterId, bytes32 attrName, uint8 traitLength, uint8 colorVariantLength) external;

    /// @notice Creates a base trait set for a character.
    /// @dev Populates traits and color variants for the initial creation of a character trait set.
    /// @dev Only subscribed administrators to the 'Management' contract can add.
    /// @param characterId The characterId to determine which trait set should be updated.
    /// @param parent The parent or key id of the trait set to be populated.
    /// @param traitIds The id's of the previously created trait set to apply too.
    /// @param _traits The 'TraitDefinition's to be populated.
    /// @param variants The 'ColorVariant's to be populated.
    function populateCharacterTraitSet(uint8 characterId, uint8 parent, uint8[] calldata traitIds, ITraitFactory.TraitDefinition[] calldata _traits, ITraitFactory.ColorVariant[][] calldata variants) external;

    /// @notice Add color variant(s) to a trait.
    /// @dev Adds an array of color variant(s) to an existing trait set.
    /// @dev Only subscribed administrators to the 'Management' contract can add.
    /// @param characterId The characterId to add color variants for.
    /// @param parent The parent trait or key id.
    /// @param traitId The child traitId.
    function addColorVariants(uint8 characterId, uint8 parent, uint8 traitId, ITraitFactory.ColorVariant[] calldata variants) external;

    /// @notice Generates a random character.
    /// @dev Pulls a random trait from each trait set parent and constructs a traitSetHash for later decoding.
    /// @param character The character id to pull the trait set for.
    /// @param seed An additional modifier for randomization, typically the tokenId.
    /// @return traitSetHash A hash constructed of all randomly selected trait component hashes.
    function generateRandomCharacter(uint8 character, uint256 seed) external view returns (uint24 traitSetHash);

    /// @notice Constructs base64 encoded json metadata.
    /// @dev The 'canRead' modifier asserts readable access so sniffers cannot easily steal data.
    /// @param character The character id.
    /// @param name The name of the character.
    /// @param description The description of the character.
    /// @param traitSetHash The hash of the trait set.
    /// @return metadata The base64 encoded json metadata.
    function encodeCharacterMetadata(
        uint8 character,
        string memory name, 
        string memory description,
        uint24 traitSetHash
    ) external view returns (string memory metadata);
}