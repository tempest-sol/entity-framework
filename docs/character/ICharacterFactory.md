## `ICharacterFactory`

This is a contract that is meant to be access controlled and not callable without permissions.
This includes both reading and writing sensative character specific data.


Both 'Management' and 'TraitFactory' contracts must be deployed prior to instantiation of this factory.


### `updateTraitFactory(address factory)` (external)

Updates the contract used for creating traits. 




### `createCharacter(bytes32 name, bool active, string description)` (external)

Creates a base character.


Creates the base wireframe of a character to add traits too.
Only subscribed administrators to the 'Management' contract can add.


### `createCharacterTraitSet(uint8 characterId, bytes32 attrName, uint8 traitLength, uint8 colorVariantLength)` (external)

Creates an initial set of traits to define a character.


Creates a framework and sets sizes of an initial trait and variant set for a character.
Only subscribed administrators to the 'Management' contract can add.


### `populateCharacterTraitSet(uint8 characterId, uint8 parent, uint8[] traitIds, struct ITraitFactory.TraitDefinition[] _traits, struct ITraitFactory.ColorVariant[][] variants)` (external)

Creates a base trait set for a character.


Populates traits and color variants for the initial creation of a character trait set.
Only subscribed administrators to the 'Management' contract can add.


### `addColorVariants(uint8 characterId, uint8 parent, uint8 traitId, struct ITraitFactory.ColorVariant[] variants)` (external)

Add color variant(s) to a trait.


Adds an array of color variant(s) to an existing trait set.
Only subscribed administrators to the 'Management' contract can add.


### `generateRandomCharacter(uint8 character, uint256 seed) → uint24 traitSetHash` (external)

Generates a random character.


Pulls a random trait from each trait set parent and constructs a traitSetHash for later decoding.


### `encodeCharacterMetadata(uint8 character, string name, string description, uint24 traitSetHash) → string metadata` (external)

Constructs base64 encoded json metadata.


The 'canRead' modifier asserts readable access so sniffers cannot easily steal data.




### `Character`


bytes32 name


bool isActive


string description



