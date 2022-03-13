## `Management`





### `onlyAdministrator()`





### `onlyManagement()`






### `initialize(address owner)` (public)





### `addAdministrator(address administrator)` (external)

Grants a user or contract administration.




### `revokeAdministration(address administrator)` (external)

Revokes a user or contracts administrative role.




### `isAdministrator(address addr) → bool` (external)

Checks if an address is an administrator.




### `addManager(address manager)` (external)

Grants a user or contract management.




### `revokeManagement(address manager)` (external)

Revokes a user or contracts management role.




### `isManager(address addr) → bool` (external)

Checks if an address is a manager.




### `addAccessor(address accessor)` (public)

Grants a user or contract administration, typically this is for a contract.




### `revokeAccessor(address accessor)` (public)

Revokes a user or contracts accessor role.




### `upgradeAccessor(address accessor)` (external)

Used for upgrading an accessor when the contract is upgraded or changed.




### `isAccessor(address addr) → bool` (external)

Checks if an address is an accessor.





### `AdministratorAdded(address administrator)`

     Events     ///



### `AdministrationRevoked(address administrator)`





### `ManagerAdded(address manager)`





### `ManagementRevoked(address manager)`





### `AccessorAdded(address accessor)`





### `AccessorRevoked(address accessor)`





### `AccessorUpgraded(address accessor)`







