## `ManageableUpgradeable`





### `onlyAdministrator()`

Checks if the caller has administrative access or greater.



### `hasAccess()`

Checks if the caller has administrative access or greater.



### `canRead()`

Checks if the caller can read the data requested. (Access control).


This is primarily used for sensative data like trait or metadata lookup.


### `__Manageable_init(address owner, address _management)` (internal)





### `__Manageable_init_unchained(address owner, address _management)` (internal)





### `updateManagement(address _management)` (external)

Updates the management contract used for access control.
Only modifiable by the contract owner.







