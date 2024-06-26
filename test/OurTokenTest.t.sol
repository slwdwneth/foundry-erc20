// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "lib/forge-std/src/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");
    address carol = makeAddr("carol");

    uint256 public constant INITIAL_SUPPLY = 1000 ether;
    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }
    // function testAllowences() public {
    //     //transferFrom
    //     uint256 initialAllowance = 1000;
    //     //bob approves alice to spend tokens

    //     vm.prank(bob);
    //     ourToken.approve(alice, initialAllowance);

    //     uint256 transferAmount = 500;

    //     vm.prank(alice);
    //     ourToken.transferFrom(bob, alice, transferAmount);

    //     assertEq(ourToken.balanceOf(alice), transferAmount);
    //     assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    //
    function testAllowance() public {
        vm.prank(bob);
        ourToken.approve(alice, 50 ether);

        assertEq(50 ether, ourToken.allowance(bob, alice));
    }

    function testTransfer() public {
        vm.prank(bob);
        ourToken.transfer(alice, 20 ether);

        assertEq(20 ether, ourToken.balanceOf(alice));
        assertEq(80 ether, ourToken.balanceOf(bob));
    }

    function testTransferFrom() public {
        vm.prank(bob);
        ourToken.approve(alice, 50 ether);

        vm.prank(alice);
        ourToken.transferFrom(bob, carol, 30 ether);

        assertEq(30 ether, ourToken.balanceOf(carol));
        assertEq(70 ether, ourToken.balanceOf(bob));
        assertEq(20 ether, ourToken.allowance(bob, alice));
    }
    function testInitialSupply() public {
        // Check total supply is as expected
        assertEq(INITIAL_SUPPLY, ourToken.totalSupply());

        // Check deployer's balance is the initial supply minus the transferred amount
        assertEq(
            INITIAL_SUPPLY - STARTING_BALANCE,
            ourToken.balanceOf(msg.sender)
        );
    }
}
