## `TraitFactory`

This is a contract that is meant to be access controlled and not callable without permissions.
This includes both reading and writing sensative trait specific data.


The 'Management' contract must be deployed prior to instantiation of this factory.


### `initialize(address owner, address _management)` (public)





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


### `decodeTraitComponentHash(uint16 componentHash) → uint8 parent, uint8 child` (external)

Decodes an individual trait definition data.


Decodes a trait definition 'componentHash' as the 'parent and child' combination for optimized storage.


### `generateRandomTraitSetHash(uint8 character, uint256 seed) → uint24 traitSetHash` (external)

Generates a random trait set hash.


Pulls a random trait from each trait set parent and constructs a traitSetHash for later decoding.


### `generateRandomTraitSet(uint8 key, uint256 seed) → uint16[] componentHashes` (internal)

Generates a random set of traits.




### `getTraitIds(uint8 key, uint8 parent) → uint8[] ids` (internal)

Gathers the trait ids of a specified key.




### `getTraitDefinition(uint8 key, uint8 parent, uint8 trait) → struct ITraitFactory.TraitDefinition definition` (internal)

Gets the trait definition for a specified key and trait.




### `getTraitComponentHash(uint8 key, uint8 parent, uint8 trait) → uint16 componentHash` (internal)

Gets the hash of a traits parent and child combination.




### `randomTrait(uint8 key, uint256 seed, uint8 parent) → uint16 componentHash` (internal)

Gets a random trait with a specified key and trait set.




### `hashTraitSet(uint16[] componentHashes) → uint24 traitSetHash` (internal)

Takes a trait set and hashes it into one value for less storage consumption.


Utility function to hash multiple componentHashes into a single storage slot.


### `unhashTraitSet(uint256 traitSetHash) → uint8[] parents, uint8[] children` (internal)

Takes an integer representation of the trait set and turns it into a map of parents and children.


Utility function to store data in 1 storage slot, the parent and child component hashes of a trait set.


### `encodeTraitSVG(struct ITraitFactory.TraitDefinition definition) → string img` (internal)

Encodes a trait into an SVG image for web display.




### `encodeTraitSetSVG(uint8 key, uint24 traitSetHash) → string svg` (internal)

Encodes a set of traits into a SVG image for web display.




### `encodeBase64Image(uint8 key, uint24 traitSetHash) → string img` (external)

Encodes an image into base64 format.




### `encodeTraitSetAttributesJson(uint8 key, uint24 traitSetHash) → string metadata` (external)

Encodes an entire trait set into metadata for frontend display usage.




### `random(uint256 seed) → uint256` (internal)






### `TraitSetCreated(uint8 key, string name, uint8 length, uint8 colorVariants)`

     Events     ///





