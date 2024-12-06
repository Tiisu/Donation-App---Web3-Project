// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;
contract Donation {
    address public owner;

    mapping(address => uint256) public donations;
    address[] public funders;

    // Events for tracking donations and withdrawals
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
        require(msg.value > 0, "Donation must be greater than 0");
        donations[msg.sender] += msg.value;
        funders.push(msg.sender);
        emit DonationReceived(msg.sender, msg.value); // Emit donation event
    }

    function withdraw() public onlyOwner {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No funds to withdraw");

        (bool success, ) = owner.call{value: contractBalance}("");
        require(success, "Withdrawal failed");

        emit FundsWithdrawn(owner, contractBalance); // Emit withdrawal event
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}