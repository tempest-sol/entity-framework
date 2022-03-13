## `IManagement`






### `addAdministrator(address addr)` (external)

Grants a user or contract administration.




### `revokeAdministration(address addr)` (external)

Revokes a user or contracts administrative role.




### `isAdministrator(address addr) → bool` (external)

Checks if an address is an administrator.




### `addManager(address addr)` (external)

Grants a user or contract management.




### `revokeManagement(address addr)` (external)

Revokes a user or contracts management role.




### `isManager(address addr) → bool` (external)

Checks if an address is a manager.




### `addAccessor(address addr)` (external)

Grants a user or contract administration, typically this is for a contract.




### `revokeAccessor(address addr)` (external)

Revokes a user or contracts accessor role.




### `upgradeAccessor(address addr)` (external)

Used for upgrading an accessor when the contract is upgraded or changed.




### `isAccessor(address addr) → bool` (external)

Checks if an address is an accessor.







