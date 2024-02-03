// SPDX-License-Identifier: MIT

// 1. Deploy mocks when on local anvil chain
// 2. Keep track of contract address across different chains
// Sepolia ETH/USD
// Mainnet ETH/USD

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address priceFeed; // ETH/USD price feed
    }

    constructor() {
        if (block.chainid == 31337) {
            // If on local anvil chain, deploy mocks
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        } else if (block.chainid == 11155111) {
            // Otherwise, grab existing address from live network
            activeNetworkConfig = getSepoliaEthUsd();
        } else {
            revert("Chain ID not supported");
        }
    }

    function getSepoliaEthUsd() public pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
            });
    }

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 23132 * 10e6;

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        return NetworkConfig({priceFeed: address(mockV3Aggregator)});
    }
}
