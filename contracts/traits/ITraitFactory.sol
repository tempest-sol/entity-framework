// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.12;

/// @title A factory for creating and defining character traits.
/// @author tempest-sol <email:tempest@stableinternetmoney.com>
/// @notice This is a contract that is meant to be access controlled and not callable without permissions.
/// @notice This includes both reading and writing sensative trait specific data.
/// @dev The 'Management' contract must be deployed prior to instantiation of this factory.
interface ITraitFactory {

    /// @notice Defines a definition of a trait.
    /// @param componentHash The hash of the parent and child.
    /// @param name The name of the trait for metadata.
    /// @param isEmpty If the trait base64 should be ignored when generating the svg.
    /// @param base64 The base64 encoded image.
    struct TraitDefinition {
        uint16 componentHash;
        string name;
        bool isEmpty;
        string base64;
    }

    /// @notice Defines a color variant of a trait.
    /// @param name The name of the trait for metadata.
    /// @param base64 The base64 encoded image.
    struct ColorVariant {
        string name;
        string base64;
    }

    /// @notice Creates an initial set of traits.
    /// @dev Creates a framework and sets sizes of an initial trait and variant set for a character.
    /// @dev Only subscribed administrators to the 'Management' contract can add.
    /// @param key The key of the trait set to update.
    /// @custom:example characterId in the CharacterFactory delegate.
    /// @param attrName The name of the trait for metadata.
    /// @param traitLength The length of the initial trait set.
    /// @param colorVariantLength The length of the initial color variant set for the trait.
    function createTraitSet(uint8 key, bytes32 attrName, uint8 traitLength, uint8 colorVariantLength) external;

    /// @notice Creates a base trait set.
    /// @dev Populates traits and color variants for the initial creation of a character trait set.
    /// @dev Only subscribed administrators to the 'Management' contract can add.
    /// @param key The key to determine which trait set should be updated.
    /// @custom:example characterId in the CharacterFactory delegate.
    /// @param parent The parent or key id of the trait set to be populated.
    /// @param traitIds The id's of the previously created trait set to apply too.
    /// @param _traits The 'TraitDefinition's to be populated.
    /// @param variants The 'ColorVariant's to be populated.    
    function populateTraitSet(uint8 key, uint8 parent, uint8[] calldata traitIds, TraitDefinition[] calldata _traits, ColorVariant[][] calldata variants) external;

    /// @notice Add color variant(s) to a trait.
    /// @dev Adds an array of color variant(s) to an existing trait set.
    /// @dev Only subscribed administrators to the 'Management' contract can add.
    /// @param key The key to add color variants for.
    /// @custom:example characterId in the CharacterFactory delegate.
    /// @param parent The parent trait or key id.
    /// @param traitId The child traitId.
    function addColorVariants(uint8 key, uint8 parent, uint8 traitId, ColorVariant[] calldata variants) external;

    /// @notice Generates a random trait set hash.
    /// @dev Pulls a random trait from each trait set parent and constructs a traitSetHash for later decoding.
    /// @param key The key id to pull the trait set for.
    /// @custom:example characterId in the CharacterFactory delegate.
    /// @param seed An additional modifier for randomization, typically the tokenId.
    /// @return traitSetHash A hash constructed of all randomly selected trait component hashes.
    function generateRandomTraitSetHash(uint8 key, uint256 seed) external view returns (uint24 traitSetHash);

    /// @notice Decodes an individual trait definition data.
    /// @dev Decodes a trait definition 'componentHash' as the 'parent and child' combination for optimized storage.
    /// @param componentHash The parent and child hash. parent | child << 8.
    /// @return parent The decoded parent.
    /// @return child The decoded child.
    function decodeTraitComponentHash(uint16 componentHash) external view returns (uint8 parent, uint8 child);

    /// @notice Creates a web encoded base64 algorithmic image.
    /// @dev This is used in the metadata response for creating an on-chain created svg.
    /// @param key The key of the trait set.
    /// @custom:example characterId in the CharacterFactory delegate.
    /// @param traitSetHash The trait set hash.
    /// @return img The base64 encoded image string.
    function encodeBase64Image(uint8 key, uint24 traitSetHash) external view returns (string memory img);

    /// @notice Creates the attributes for a trait set.
    /// @notice This is typically what you check on 'OpenSea' for details.
    /// @dev Decodes the trait set from the traitSetHash and creates the attribute data for insertion to the metadata JSON.
    /// @param key The key of the trait set.
    /// @custom:example characterId in the CharacterFactory delegate.
    /// @param traitSetHash The hash of the trait set.
    /// @return metadata The attribute metadata in JSON format.
    function encodeTraitSetAttributesJson(uint8 key, uint24 traitSetHash) external view returns (string memory metadata);
}