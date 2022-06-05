// Get funds from users 
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 50 * 1e18; 

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded; 

    address public immutable owner;

    constructor() {
        // Owner is whoever deployed the contract
        owner = msg.sender;
    }

    function fund() public payable {
        // Want to be able to set a minimum funding amount in USD
        // 1. How do we send ETH to this contract? 

        require (msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough");
        // msg.value has 18 decimal places
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value; 
    }

    function withdraw() public {
        for (uint256 i = 0; i < funders.length; i++) {
            address funder = funders[i];
            addressToAmountFunded[funder] = 0; 
        }

        // reset the array
        funders = new address[](0); 

        // withdraw the funds
        // 3 different ways to send ETH

        // // transfer
        // payable(msg.sender).transfer(address(this).balance); 

        // // send 
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        // call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require (callSuccess, "Call failed");
    }

    modifier onlyOwner {
        if (msg.sender != owner) { revert NotOwner(); } 
        _;
    }

    // What happens if somoene sends this contract ETH without calling the fund function
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    // Two Options:
    // Receive
    // Fallback
}