// SPDX-License-Identifier: MIT
// FILEPATH: /workspaces/cyfrin-foundry-course/foundry-fund-me-f23/script/DeployFundMe.s.sol

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() public returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();

        vm.startBroadcast();
        FundMe fundMe = new FundMe(helperConfig.activeNetworkConfig());
        vm.stopBroadcast();

        return fundMe;
    }
}
