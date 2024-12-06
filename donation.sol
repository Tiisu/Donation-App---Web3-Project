// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract Donation {
    address public owner;  // Store the owner of the contract

    constructor() {
        owner = msg.sender;  // Set the deployer as the owner
    }
}