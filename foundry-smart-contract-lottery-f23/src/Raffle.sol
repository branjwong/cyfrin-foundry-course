// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

/**
 * @title A sample Raffle Contract
 * @author Brandon Wong
 * @notice This contract is for creating a sample raffle
 * @dev Implements Chainlink VRFv2
 */
contract Raffle {
    error Raffle__NotEnoughEthToEnterRaffle();

    uint256 private immutable i_entranceFee;
    address payable[] private s_players;

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() external payable {
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthToEnterRaffle();
        }

        s_players.push(payable(msg.sender));
    }

    function pickWinner() public {}

    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }
}
