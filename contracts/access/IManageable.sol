// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.12;

/// @title An interface that makes a contract implement updating management logic.
/// @author tempest-sol <email:tempest@stableinternetmoney.com>
interface IManageable {
    
    /// @notice Updates the management contract used for access control.
    /// @notice Only modifiable by the contract owner.
    /// @param _management The address of the new management contract.
    function updateManagement(address _management) external;
}