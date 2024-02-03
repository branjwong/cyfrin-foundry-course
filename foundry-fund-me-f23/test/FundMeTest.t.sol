// SPDX-License-Identifier: MIT
// FILEPATH: /workspaces/cyfrin-foundry-course/foundry-fund-me-f23/test/FundMeTest.t.sol

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    DeployFundMe deployFundMe;

    function setUp() external {
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function test_minimum_dollar_is_five() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function test_owner_is_message_sender() public {
        // Incorrect: msg.sender is the sender of the transaction, `forge test`, not the contract
        // assertEq(address(fundMe.i_owner()), address(msg.sender));

        console.log("owner", address(fundMe.i_owner()));
        console.log("this", address(this));
        console.log("msg.sender", address(msg.sender));
        console.log("deployFundMe", address(deployFundMe));
        console.log("fundMe", address(fundMe));
        assertEq(address(fundMe.i_owner()), address(msg.sender));
    }

    function test_price_feed_version_is_accurate() public {
        assertEq(fundMe.getVersion(), 4);
    }
}
