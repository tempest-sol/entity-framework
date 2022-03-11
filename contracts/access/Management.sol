// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.12;

import {IManagement} from "./IManagement.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title Management contract to allow a contract to inherit rights management.
/// @author tempest-sol
abstract contract Management is IManagement, Ownable {

    mapping(address => bool) public administrators;

    mapping(address => bool) public managers;

    event AdministratorAdded(address administrator);

    event AdministrationRevoked(address administrator);

    event ManagerAdded(address manager);

    event ManagementRevoked(address manager);

    function addAdministrator(address administrator) external override onlyOwner {
        require(!administrators[administrator], "administrator_already_added");
        administrators[administrator] = true;
        emit AdministratorAdded(administrator);
    }

    function revokeAdministration(address administrator) external override onlyOwner {
        require(administrators[administrator], "address_not_administrator");
        administrators[administrator] = false;
        emit AdministrationRevoked(administrator);
    }

    function isAdministrator(address addr) external override view returns (bool) {
        return administrators[addr];
    }

    function addManager(address manager) external override onlyAdministrator {
        require(!managers[manager], "manager_already_added");
        managers[manager] = true;
        emit ManagerAdded(manager);
    }

    function revokeManagement(address manager) external override onlyAdministrator {
        require(managers[manager], "address_not_management");
        managers[manager] = false;
        emit ManagementRevoked(manager);
    }

    function isManager(address addr) external override view returns (bool) {
        return managers[addr];
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