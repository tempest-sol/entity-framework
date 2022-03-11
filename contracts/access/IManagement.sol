// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.12;

/// @title Management contract to allow a contract to inherit rights management.
/// @author tempest-sol
interface IManagement {
    function addAdministrator(address administrator) external;
    function revokeAdministration(address administrator) external;
    function isAdministrator(address addr) external view returns (bool);
    function addManager(address manager) external;
    function revokeManagement(address manager) external;
    function isManager(address addr) external view returns (bool);
}