// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.12;

import {IManagement} from "./IManagement.sol";
import {Initializable, OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @title Management contract to allow a contract to inherit rights management.
/// @author tempest-sol <email:tempest@stableinternetmoney.com>
contract Management is IManagement, Initializable, OwnableUpgradeable {

      ///////////////////////
     ///     Storage     ///
    ///////////////////////
    mapping(address => bool) internal administrators;
    mapping(address => bool) internal managers;
    mapping(address => bool) internal accessors;

      ///////////////////////
     ///      Events     ///
    ///////////////////////
    event AdministratorAdded(address administrator);
    event AdministrationRevoked(address administrator);
    event ManagerAdded(address manager);
    event ManagementRevoked(address manager);
    event AccessorAdded(address accessor);
    event AccessorRevoked(address accessor);
    event AccessorUpgraded(address accessor);

    function initialize(address owner) public initializer {
        __Ownable_init();
        transferOwnership(owner);
    }

    /// @inheritdoc IManagement
    function addAdministrator(address administrator) external override onlyOwner {
        require(!administrators[administrator], "administrator_already_added");
        administrators[administrator] = true;
        emit AdministratorAdded(administrator);
    }

    /// @inheritdoc IManagement
    function revokeAdministration(address administrator) external override onlyOwner {
        require(administrators[administrator], "address_not_administrator");
        administrators[administrator] = false;
        emit AdministrationRevoked(administrator);
    }

    /// @inheritdoc IManagement
    function isAdministrator(address addr) external override view returns (bool) {
        return owner() == addr || administrators[addr];
    }

    /// @inheritdoc IManagement
    function addManager(address manager) external override onlyAdministrator {
        require(!managers[manager], "manager_already_added");
        managers[manager] = true;
        emit ManagerAdded(manager);
    }

    /// @inheritdoc IManagement
    function revokeManagement(address manager) external override onlyAdministrator {
        require(managers[manager], "address_not_management");
        managers[manager] = false;
        emit ManagementRevoked(manager);
    }

    /// @inheritdoc IManagement
    function isManager(address addr) external override view returns (bool) {
        return owner() == addr || managers[addr];
    }

    /// @inheritdoc IManagement
    function addAccessor(address accessor) public override onlyOwner {
        require(!accessors[accessor], "accessor_already_added");
        accessors[accessor] = true;
        emit AccessorAdded(accessor);
    }

    /// @inheritdoc IManagement
    function revokeAccessor(address accessor) public override onlyOwner {
        require(accessors[accessor], "address_not_accessor");
        accessors[accessor] = false;
        emit AccessorRevoked(accessor);
    }

    /// @inheritdoc IManagement
    function upgradeAccessor(address accessor) external override onlyOwner {
        revokeAccessor(accessor);
        addAccessor(accessor);
        emit AccessorUpgraded(accessor);
    }

    /// @inheritdoc IManagement
    function isAccessor(address addr) external override view returns (bool) {
        return owner() == addr || accessors[addr];
    }

    modifier onlyAdministrator() {
        require(msg.sender == owner() || administrators[msg.sender], "caller_invalid_rights");
        _;
    }

    modifier onlyManagement() {
        require(msg.sender == owner() || administrators[msg.sender] || managers[msg.sender], "caller_invalid_rights");
        _;
    }
}