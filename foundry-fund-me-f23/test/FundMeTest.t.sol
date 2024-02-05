// SPDX-License-Identifier: MIT
// FILEPATH: /workspaces/cyfrin-foundry-course/foundry-fund-me-f23/test/FundMeTest.t.sol

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    DeployFundMe deployFundMe;

    address USER = makeAddr("user");
    uint256 SEND_VALUE = 0.1 ether; /// 100000000000000000
    uint256 STARTING_BALANCE = 1000 ether;

    function setUp() external {
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
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

    function test_fund_updates_funded_data_structure() public {
        vm.prank(USER); // Next TX sent by USER
        fundMe.fund{value: SEND_VALUE}();

        assertEq(fundMe.s_addressToAmountFunded(USER), SEND_VALUE);
        assertEq(fundMe.s_funders(0), USER);
    }
}
