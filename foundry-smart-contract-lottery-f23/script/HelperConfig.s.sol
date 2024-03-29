// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinator;
        bytes32 gasLane;
        uint64 subscriptionId;
        uint32 callbackGasLimit;
    }

    uint256 public constant ENTRANCE_FEE = 0.01 ether;
    uint256 public constant INTERVAL = 30 seconds;
    bytes32 public constant GAS_LANE =
        0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c;
    uint64 public constant SUBSCRIPTION_ID = 0;
    uint32 public constant CALLBACK_GAS_LIMIT = 500000;

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                entranceFee: ENTRANCE_FEE,
                interval: INTERVAL,
                vrfCoordinator: 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625,
                gasLane: GAS_LANE,
                subscriptionId: SUBSCRIPTION_ID,
                callbackGasLimit: CALLBACK_GAS_LIMIT
            });
    }

    function getOrCreateAnvilConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.vrfCoordinator != address(0)) {
            return activeNetworkConfig;
        }

        uint96 baseFee = 0.25 ether; // 0.25 LINK
        uint96 gasPriceLink = 1e9; // 1 gwei LINK

        vm.startBroadcast();
        VRFCoordinatorV2Mock vrfCoordinator = new VRFCoordinatorV2Mock(
            baseFee,
            gasPriceLink
        );
        vm.stopBroadcast();

        return
            NetworkConfig({
                entranceFee: ENTRANCE_FEE,
                interval: INTERVAL,
                vrfCoordinator: address(vrfCoordinator),
                gasLane: GAS_LANE,
                subscriptionId: SUBSCRIPTION_ID,
                callbackGasLimit: CALLBACK_GAS_LIMIT
            });
    }
}
