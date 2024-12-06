// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./PriceConverter.sol"; // Import the price converter library

contract Donation {
    using PriceConverter for uint256;

    address public owner;
    uint256 public constant MINIMUM_USD = 50 * 1e18; // $50 in USD

    mapping(address => uint256) public donations;
    address[] public funders;

    event DonationReceived(address indexed donor, uint256 amount);
    event FundsWithdrawn(address indexed owner, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can withdraw funds");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate() >= MINIMUM_USD, 
            "Minimum donation is $50"
        );
        donations[msg.sender] += msg.value;
        funders.push(msg.sender);
        emit DonationReceived(msg.sender, msg.value);
    }

    function withdraw() public onlyOwner {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No funds to withdraw");

        (bool success, ) = owner.call{value: contractBalance}("");
        require(success, "Withdrawal failed");

        emit FundsWithdrawn(owner, contractBalance);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}