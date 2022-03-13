## `ITraitFactory`

This is a contract that is meant to be access controlled and not callable without permissions.
This includes both reading and writing sensative trait specific data.


The 'Management' contract must be deployed prior to instantiation of this factory.


### `createTraitSet(uint8 key, bytes32 attrName, uint8 traitLength, uint8 colorVariantLength)` (external)

Creates an initial set of traits.


Creates a framework and sets sizes of an initial trait and variant set for a character.
Only subscribed administrators to the 'Management' contract can add.


### `populateTraitSet(uint8 key, uint8 parent, uint8[] traitIds, struct ITraitFactory.TraitDefinition[] _traits, struct ITraitFactory.ColorVariant[][] variants)` (external)

Creates a base trait set.


Populates traits and color variants for the initial creation of a character trait set.
Only subscribed administrators to the 'Management' contract can add.


### `addColorVariants(uint8 key, uint8 parent, uint8 traitId, struct ITraitFactory.ColorVariant[] variants)` (external)

Add color variant(s) to a trait.


Adds an array of color variant(s) to an existing trait set.
Only subscribed administrators to the 'Management' contract can add.


### `generateRandomTraitSetHash(uint8 key, uint256 seed) → uint24 traitSetHash` (external)

Generates a random trait set hash.


Pulls a random trait from each trait set parent and constructs a traitSetHash for later decoding.


### `decodeTraitComponentHash(uint16 componentHash) → uint8 parent, uint8 child` (external)

Decodes an individual trait definition data.


Decodes a trait definition 'componentHash' as the 'parent and child' combination for optimized storage.


### `encodeBase64Image(uint8 key, uint24 traitSetHash) → string img` (external)

Creates a web encoded base64 algorithmic image.


This is used in the metadata response for creating an on-chain created svg.


### `encodeTraitSetAttributesJson(uint8 key, uint24 traitSetHash) → string metadata` (external)

Creates the attributes for a trait set.
This is typically what you check on 'OpenSea' for details.


Decodes the trait set from the traitSetHash and creates the attribute data for insertion to the metadata JSON.




### `TraitDefinition`


uint16 componentHash


string name


bool isEmpty


string base64


### `ColorVariant`


string name


string base64



