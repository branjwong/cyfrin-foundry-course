// SPDX-License-Identifier: MIT

// 1. Deploy mocks when on local anvil chain
// 2. Keep track of contract address across different chains
// Sepolia ETH/USD
// Mainnet ETH/USD

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

contract HelperConfig {
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address priceFeed; // ETH/USD price feed
    }

    constructor() {
        if (block.chainid == 31337) {
            // If on local anvil chain, deploy mocks
            activeNetworkConfig = getAnvilEthConfig();
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

    function getAnvilEthConfig() public pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
            });
    }
}
