// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.12;

import {ManageableUpgradeable} from "../access/ManageableUpgradeable.sol";
import {ITraitFactory} from "./ITraitFactory.sol";
import {Base64} from "../utils/compression/Base64.sol";

import "hardhat/console.sol";

/// @title A factory for creating and defining character traits.
/// @author tempest-sol <email:tempest@stableinternetmoney.com>
/// @notice This is a contract that is meant to be access controlled and not callable without permissions.
/// @notice This includes both reading and writing sensative trait specific data.
/// @dev The 'Management' contract must be deployed prior to instantiation of this factory.
contract TraitFactory is ITraitFactory, ManageableUpgradeable {
    using Base64 for bytes;

      ///////////////////////
     ///     Storage     ///
    ///////////////////////
    mapping(uint8 => mapping(uint8 => bytes32)) internal traitAttributNames;
    mapping(uint8 => mapping(uint8 => mapping(uint8 => TraitDefinition))) internal keyTraitSets;
    mapping(uint8 => mapping(uint8 => uint8[])) internal traitKeyParentChildTraitIds;
    mapping(uint8 => mapping(uint8 => mapping(uint8 => mapping(uint8 => ColorVariant)))) internal traitColorVariants;
    mapping(uint8 => mapping(uint8 => mapping(uint8 => uint8[]))) internal traitKeyColorVariantIds;

    uint8[] internal traitKeyIds;
    uint8[] internal traitKeyParentIds; 

      ///////////////////////
     ///      Events     ///
    ///////////////////////
    event TraitSetCreated(uint8 indexed key, string name, uint8 indexed length, uint8 indexed colorVariants);

    function initialize(address owner, address _management) public initializer {
        __Manageable_init(owner, _management);
    }

    /// @inheritdoc ITraitFactory
    function createTraitSet(
        uint8 key, 
        bytes32 attrName, 
        uint8 traitLength, 
        uint8 colorVariantLength
    ) external override hasAccess {
        require(traitLength <= type(uint8).max, "exceeds_maximum_traits");
        require(colorVariantLength <= type(uint8).max, "exceeds_maximum_variants");
        require(attrName.length > 0, "attribute_name_cannot_be_zero");
        //todo: move to modifier
        require(traitKeyIds.length >= key, "key_does_not_exist");

        //todo: check parent id max length
        uint8 parentId = uint8(traitKeyParentIds.length);

        traitAttributNames[key][parentId] = attrName;
    
        for(uint8 i=0;i<traitLength;++i) {
            traitKeyParentChildTraitIds[key][parentId].push(i);
            for(uint8 x=0;x<colorVariantLength;++x) {
                traitKeyColorVariantIds[key][parentId][i].push(x);
            }
        }

        traitKeyParentIds.push(parentId);
        traitKeyIds.push(key);

        emit TraitSetCreated(key, string(abi.encodePacked(attrName)), traitLength, colorVariantLength);
    }

    /// @inheritdoc ITraitFactory
    function populateTraitSet(
        uint8 key, 
        uint8 parent, 
        uint8[] calldata traitIds, 
        TraitDefinition[] calldata _traits, 
        ColorVariant[][] calldata variants
    ) external override hasAccess {
        require(traitIds.length == _traits.length, "invalid_trait_length");
        for (uint i = 0; i < _traits.length; i++) {
            uint8 traitId = traitIds[i];
            require(traitId <= traitKeyParentChildTraitIds[key][parent].length, "trait_id_exceeds_length");
            keyTraitSets[key][parent][traitId] = TraitDefinition(
                uint16(parent) | (uint16(traitId) << 8),
                _traits[i].name,
                _traits[i].isEmpty,
                _traits[i].base64
            );
            if(i >= variants.length) continue;
            for(uint8 x=0;x<variants[i].length;++x) {
                traitColorVariants[key][parent][traitId][x] = ColorVariant(
                    variants[i][x].name,
                    variants[i][x].base64
                );
            }
        }
    }

    /// @inheritdoc ITraitFactory
    function addColorVariants(
        uint8 key, 
        uint8 parent, 
        uint8 traitId, 
        ColorVariant[] calldata variants
    ) external override hasAccess {
        //todo check existing + next
        require(variants.length > 0 && variants.length <= type(uint8).max, "invalid_variant_size");

        uint8 startingIndex = uint8(traitKeyColorVariantIds[key][parent][traitId].length);
        for(uint8 i=0;i<variants.length;++i) {
            traitKeyColorVariantIds[key][parent][traitId].push(startingIndex + i);
            traitColorVariants[key][parent][traitId][startingIndex + i] = ColorVariant(
                variants[i].name,
                variants[i].base64
            );
        }
    }
   
    /// @inheritdoc ITraitFactory
    function decodeTraitComponentHash(
        uint16 componentHash
    ) external override canRead view returns (uint8 parent, uint8 child) {
        parent = uint8(componentHash);
        child = uint8(componentHash >> 8);
    }

    /// @inheritdoc ITraitFactory
    function generateRandomTraitSetHash(
        uint8 character, 
        uint256 seed
    ) external override hasAccess view returns (uint24 traitSetHash) {
        //todo: access control?
        //todo: remove seed from param?
        uint16[] memory componentHashes = generateRandomTraitSet(character, seed);
        console.log("len: ", componentHashes.length);
        traitSetHash = hashTraitSet(componentHashes);
        console.log("hash: ", traitSetHash);
    }

    /// @notice Generates a random set of traits.
    /// @param key The key of the trait set.
    /// @custom:example characterId in the CharacterFactory delegate.
    function generateRandomTraitSet(
        uint8 key, 
        uint256 seed
    ) internal view returns (uint16[] memory componentHashes) {
        //todo: access control?
        uint8 parentCount = uint8(traitKeyParentIds.length);
        componentHashes = new uint16[](parentCount);
        for(uint8 i=0;i<parentCount;++i) {
            componentHashes[i] = randomTrait(key, seed + i, i);
        }
    }

    /// @notice Gathers the trait ids of a specified key.
    /// @param key The key of the trait set.
    /// @custom:example characterId in the CharacterFactory delegate.
    /// @param parent The parent id of the trait set.
    /// @return ids The found trait ids for a trait set.
    function getTraitIds(uint8 key, uint8 parent) internal view returns (uint8[] memory ids) {
        ids = traitKeyParentChildTraitIds[key][parent];
    }

    /// @notice Gets the trait definition for a specified key and trait.
    /// @param key The key of the trait set.
    /// @custom:example characterId in the CharacterFactory delegate.
    /// @param parent The parent identifier of the trait set.
    /// @param trait The trait id to get the definition for.
    /// @return definition The 'TraitDefinition'.
    function getTraitDefinition(
        uint8 key, 
        uint8 parent, 
        uint8 trait
    ) internal view returns (TraitDefinition memory definition) {
        definition = keyTraitSets[key][parent][trait];
    }

    /// @notice Gets the hash of a traits parent and child combination.
    /// @param key The key of the trait set.
    /// @custom:example characterId in the CharacterFactory delegate.
    /// @param parent The parent identifier of the trait set.
    /// @param trait The trait id to get the component hash for.
    /// @return componentHash The hash of the parent and child. parent | child << 8.
    function getTraitComponentHash(uint8 key, uint8 parent, uint8 trait) internal view returns (uint16 componentHash) {
        componentHash = keyTraitSets[key][parent][trait].componentHash;
    }

    /// @notice Gets a random trait with a specified key and trait set.
    /// @param key The key of the trait set.
    /// @custom:example characterId in the CharacterFactory delegate.
    /// @param seed A pseduorandom identifier / key.
    /// @custom:example tokenId for an ERC721/1155.
    /// @return componentHash The hash of the parent and child. parent | child << 8.
    function randomTrait(uint8 key, uint256 seed, uint8 parent) internal view returns (uint16 componentHash) {
        uint8[] memory traitIds = getTraitIds(key, parent);
        if(traitIds.length == 0) return componentHash = getTraitComponentHash(key, parent, traitIds[0]);
        //todo: increase by tokenid + random metric?
        uint8 traitId = uint8(random(seed + key) % traitIds.length);
        componentHash = getTraitComponentHash(key, parent, traitId);
    }

    /// @notice Takes a trait set and hashes it into one value for less storage consumption.
    /// @dev Utility function to hash multiple componentHashes into a single storage slot.
    /// @param componentHashes An array of trait parent and children hashes.
    /// @return traitSetHash The hash of a complete trait set.
    function hashTraitSet(uint16[] memory componentHashes) internal pure returns (uint24 traitSetHash) {
        uint16 length = uint16(componentHashes.length);
        traitSetHash |= uint16(length);
        for(uint256 i=0;i<length;++i) {
            uint24 bitIndex = uint24((i + 1) * 8);
            traitSetHash |= uint24(componentHashes[i]) << bitIndex;
        }
    }

    /// @notice Takes an integer representation of the trait set and turns it into a map of parents and children.
    /// @dev Utility function to store data in 1 storage slot, the parent and child component hashes of a trait set.
    /// @param traitSetHash A hash of all trait set components parents and children component hashes.
    /// @return parents The parent ids of the trait set.
    /// @return children The children ids of the trait set.
    function unhashTraitSet(
        uint256 traitSetHash
    ) internal pure returns (uint8[] memory parents, uint8[] memory children) {
        uint16 length = uint16(traitSetHash);
        parents = new uint8[](length);
        children = new uint8[](length);
        for(uint8 i=0;i<length;++i) {
            uint24 bitIndex = uint24((i + 1) * 8);
            uint16 componentHash = uint16(traitSetHash >> bitIndex);
            uint8 parent = uint8(componentHash);
            uint8 child = uint8(componentHash >> 8); 
            parents[i] = parent;
            children[i] = child;
        }
    }

    /// @notice Encodes a trait into an SVG image for web display.
    /// @param definition The 'TraitDefinition' to encode.
    /// @return img The string representation of the SVG code block for frontend use.
    function encodeTraitSVG(TraitDefinition memory definition) internal pure returns (string memory img) {
        require(bytes(definition.base64).length > 0, "trait_zero_length_img");
        img = string(abi.encodePacked(
            '<image x="32" y="32" width="1024" height="1024" image-rendering="pixelated" preserveAspectRatio="xMidYMid" xlink:href="data:image/png;base64,', 
                definition.base64,
            '"/>'
        ));
    }

    /// @notice Encodes a set of traits into a SVG image for web display.
    /// @param key The key id of the trait set.
    /// @custom:example characterId in the CharacterFactory delegate.
    /// @param traitSetHash The hash of the entire trait set.
    /// @return svg The string representation of the SVG code block for frontend use.
    function encodeTraitSetSVG(uint8 key, uint24 traitSetHash) internal view returns (string memory svg) {
        (uint8[] memory parents, uint8[] memory children) = unhashTraitSet(traitSetHash);
        for(uint8 i=0;i<parents.length;++i) {
            ITraitFactory.TraitDefinition memory definition = keyTraitSets[key][i][children[i]];
            string memory img = bytes(definition.base64).length == 0 ? '' : encodeTraitSVG(definition);
            svg = string(abi.encodePacked(svg, img));
        }
    }

    /// @notice Encodes an image into base64 format.
    /// @param key The key id of the trait set.
    /// @custom:example characterId in the CharacterFactory delegate.
    /// @param traitSetHash The hash of the entire trait set.
    /// @return img The string representation of an entire <svg> tag for frontend use.
    function encodeBase64Image(
        uint8 key, 
        uint24 traitSetHash
    ) external override canRead view returns (string memory img) {
        string memory svg = encodeTraitSetSVG(key, traitSetHash);
        img = bytes(svg).base64();
    }

    /// @notice Encodes an entire trait set into metadata for frontend display usage.
    /// @custom:example 'OpenSea' properties of an NFT.
    /// @param key The key id of the trait set.
    /// @custom:example characterId in the CharacterFactory delegate.
    /// @param traitSetHash The hash of the entire trait set.
    /// @return metadata The JSON format string representation of the trait attributes.
    function encodeTraitSetAttributesJson(
        uint8 key, 
        uint24 traitSetHash
    ) external override canRead view returns (string memory metadata) {
        (uint8[] memory parents, uint8[] memory children) = unhashTraitSet(traitSetHash);
        for(uint8 i=0;i<parents.length;++i) {
            ITraitFactory.TraitDefinition memory definition = keyTraitSets[key][i][children[i]];
            metadata = string(abi.encodePacked(metadata, '{"trait_type":"', traitAttributNames[key][i], '","value":"', definition.name, '"}'));
            if(i != parents.length - 1) {
                metadata = string(abi.encodePacked(metadata, ","));
            }
        }
    }

    function random(uint256 seed) internal view returns (uint256) {
        return uint256(
            keccak256(abi.encodePacked(tx.origin, blockhash(block.number - 1), block.timestamp, seed))
        );
    }
}