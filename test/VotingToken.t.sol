// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {VotingToken} from "../src/VotingToken.sol";

contract VotingTokenTest is Test {
    VotingToken public vt;

    function setUp() public {
        vt = new VotingToken("VotingToken", "VT");
    }

    function test_Name() public {
        assertEq(vt.name(), "VotingToken");
    }


}
