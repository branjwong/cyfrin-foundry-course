// SPDX-License-Identifier: MIT
// FILEPATH: /workspaces/cyfrin-foundry-course/foundry-fund-me-f23/test/FundMeTest.t.sol

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
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

    function test_minimum_dollar_is_five() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function test_owner_is_message_sender() public {
        // Incorrect: msg.sender is the sender of the transaction, `forge test`, not the contract
        // assertEq(address(fundMe.i_owner()), address(msg.sender));

        console.log("owner", address(fundMe.getOwner()));
        console.log("this", address(this));
        console.log("msg.sender", address(msg.sender));
        console.log("deployFundMe", address(deployFundMe));
        console.log("fundMe", address(fundMe));
        assertEq(address(fundMe.getOwner()), address(msg.sender));
    }

    function test_price_feed_version_is_accurate() public {
        assertEq(fundMe.getVersion(), 4);
    }

    modifier funded() {
        vm.prank(USER); // Next TX sent by USER
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function test_fund_updates_addressToAmountFunded() public funded {
        assertEq(fundMe.getAddressToAmountFunded(USER), SEND_VALUE);
    }

    function test_fund_adds_funder_to_array_of_funders() public funded {
        assertEq(fundMe.getFunder(0), USER);
    }

    function test_non_owners_cannot_withdraw() public funded {
        vm.prank(USER); // Next TX sent by USER
        vm.expectRevert();
        fundMe.withdraw();
    }

    function test_owners_can_withdraw_from_single_funder() public funded {
        // Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.prank(fundMe.getOwner()); // Next TX sent by OWNER
        fundMe.withdraw();

        // Assert
        assertEq(
            fundMe.getOwner().balance,
            startingOwnerBalance + startingFundMeBalance
        );
        assertEq(address(fundMe).balance, 0);
    }

    function test_owners_can_withdraw_from_multiple_funders() public {
        // Arrange
        for (uint160 i = 1; i <= 5; i++) {
            hoax(address(i), SEND_VALUE); // sets up a prank with some ether
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        assertEq(startingFundMeBalance, SEND_VALUE * 5);

        // Act
        vm.startPrank(fundMe.getOwner()); // multi-line pranking
        fundMe.withdraw();
        vm.stopPrank();

        // Assert
        assertEq(
            fundMe.getOwner().balance,
            startingOwnerBalance + startingFundMeBalance
        );
        assertEq(address(fundMe).balance, 0);
    }
}
