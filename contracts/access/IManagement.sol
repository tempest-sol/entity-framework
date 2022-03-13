// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.12;

/// @title Management contract to allow a contract to inherit rights management.
/// @author tempest-sol <email:tempest@stableinternetmoney.com>
interface IManagement {

    /// @notice Grants a user or contract administration.
    /// @param addr The address to apply the role too.
    function addAdministrator(address addr) external;

    /// @notice Revokes a user or contracts administrative role.
    /// @param addr The address to revoke the role from.
    function revokeAdministration(address addr) external;

    /// @notice Checks if an address is an administrator.
    /// @param addr The address to check the role for.
    function isAdministrator(address addr) external view returns (bool);

    /// @notice Grants a user or contract management.
    /// @param addr The address to apply the role too.
    function addManager(address addr) external;

    /// @notice Revokes a user or contracts management role.
    /// @param addr The address to revoke the role from.
    function revokeManagement(address addr) external;

    /// @notice Checks if an address is a manager.
    /// @param addr The address to check the role for.
    function isManager(address addr) external view returns (bool);

    /// @notice Grants a user or contract administration, typically this is for a contract.
    /// @param addr The address to apply the role too.
    function addAccessor(address addr) external;

    /// @notice Revokes a user or contracts accessor role.
    /// @param addr The address to revoke the role from.
    function revokeAccessor(address addr) external;

    /// @notice Used for upgrading an accessor when the contract is upgraded or changed.
    /// @param addr The address to upgrade.
    function upgradeAccessor(address addr) external;

    /// @notice Checks if an address is an accessor.
    /// @param addr The address to check the role for.
    function isAccessor(address addr) external view returns (bool);
}