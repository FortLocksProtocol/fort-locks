// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import {Script} from "forge-std/Script.sol";
import {FortLocks} from "../src/FortLocks.sol";

contract DeployFortLocks is Script {
    address internal constant FORT_FEE_RECIPIENT = 0x7ca966E0722921216c46b024bd13C1F647f338bc;

    function run() external returns (FortLocks fortLocks) {
        vm.startBroadcast();

        fortLocks = new FortLocks(FORT_FEE_RECIPIENT);

        vm.stopBroadcast();
    }
}
