// SPDX-License-Identifier: MIT
// FILEPATH: /workspaces/cyfrin-foundry-course/foundry-fund-me-f23/test/FundMeTest.t.sol

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract FundMeTestIntegration is Test {
    FundMe fundMe;
    DeployFundMe deployFundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether; /// 100000000000000000
    uint256 constant STARTING_BALANCE = 1000 ether;

    function setUp() external {
        vm.deal(USER, STARTING_BALANCE);

        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function test_user_can_fund_interactions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}
