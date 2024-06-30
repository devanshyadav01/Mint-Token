// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Functionality
// Only contract owner should be able to mint tokens
// Any user can transfer tokens
// Any user can burn tokens

// Author: [Devansh]

contract CustomToken is ERC20, Ownable {

    struct User {
        bool isRegistered;
    }
    // Mapping to store the registration status of each user by their address
    mapping(address => User) public users;

    // Constructor to initialize the token with name "Custom" and symbol "CST"
    // Sets the contract deployer as the initial owner

  

    constructor()
        ERC20("Custom", "CST")
        // Transfer ownership to the deploye
        Ownable(msg.sender)
    {
        transferOwnership(msg.sender);
    }
     // Override the decimals function to set the decimal places to 0
    function decimals() public view virtual override returns (uint8) {
        return 0;
    }
      // Function to register a user
    // Only the contract owner can register users
    function registerUser(address user) public onlyOwner {
        require(!users[user].isRegistered, "User is already registered");
        users[user].isRegistered = true;
    }
     // Function to mint new tokens to a specific address
    // Only the contract owner can mint tokens and the recipient must be registered
    function mintTokens(address to, uint256 amount) public onlyOwner {
        require(users[to].isRegistered, "User is not registered");
        _mint(to, amount);
    }
     // Function to burn tokens from a specific address
    // Any user can burn their own tokens, provided they are registered and have enough balance
    function burnTokens(address from, uint256 amount) public {
        require(users[from].isRegistered, "User is not registered");
        require(amount <= balanceOf(from), "Insufficient balance to burn");

        _burn(from, amount);
    }
     // Function to transfer tokens from one user to another
    // Both sender and receiver must be registered, and sender must have enough balance
    function transferTokens(address from, address to, uint256 amount) public {
        require(users[from].isRegistered, "Sender is not registered");
        require(users[to].isRegistered, "Receiver is not registered");
        require(amount <= balanceOf(from), "Insufficient balance to transfer");

        _transfer(from, to, amount);
    }
    // Function to get the balance of a specific user
    // The user must be registered
    function getUserBalance(address user) public view returns (uint256) {
        require(users[user].isRegistered, "User is not registered");
        return balanceOf(user);
    }
    // Override the transferFrom function to allow token transfers via the allowance mechanism
    // This is part of the standard ERC20 functionality
    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        return super.transferFrom(from, to, amount);
    }
}
