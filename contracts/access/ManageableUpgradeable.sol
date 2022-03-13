// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.12;

import {Initializable, OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import {IManageable} from "../access/IManageable.sol";
import {IManagement} from "../access/IManagement.sol";

/// @title Upgradeable Manageable contract that inherits ownable upgrading pattern as well as modifiers.
/// @author tempest-sol <email:tempest@stableinternetmoney.com>
abstract contract ManageableUpgradeable is IManageable, Initializable, OwnableUpgradeable {

      ///////////////////////
     ///     Storage     ///
    ///////////////////////
    IManagement public management;

    function __Manageable_init(address owner, address _management) internal onlyInitializing {
        __Manageable_init_unchained(owner, _management);
    }

    function __Manageable_init_unchained(address owner, address _management) internal onlyInitializing {
        _transferOwnership(owner);
        management = IManagement(_management);
    }

    /// @notice Updates the management contract used for access control.
    /// @notice Only modifiable by the contract owner.
    /// @param _management The address of the new management contract.
    function updateManagement(address _management) external override onlyOwner {
        require(address(management) != _management, "management_already_set");
        management = IManagement(_management);
    }

    /// @notice Checks if the caller has administrative access or greater.
    modifier onlyAdministrator() {
        require(management.isAdministrator(msg.sender), "invalid_access_rights");
        _;
    }

    /// @notice Checks if the caller has administrative access or greater.
    modifier hasAccess() {
        require(management.isAdministrator(msg.sender), "invalid_access_rights");
        _;
    }

    /// @notice Checks if the caller can read the data requested. (Access control).
    /// @dev This is primarily used for sensative data like trait or metadata lookup.
    modifier canRead() {
        require(management.isAdministrator(msg.sender) || management.isAccessor(msg.sender), "invalid_access_rights");
        _;
    }
}