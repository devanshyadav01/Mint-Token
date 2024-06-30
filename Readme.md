# GameToken Smart Contract

## Simple Overview
This project implements a custom ERC20 token called `GameToken` using the OpenZeppelin library. The smart contract includes functionalities to register players, mint new tokens for registered players, burn tokens from registered players, and transfer tokens between registered players, all while enforcing ownership rules.

## Description
GameToken is an ERC20-compliant smart contract developed in Solidity. It leverages OpenZeppelin's robust libraries to ensure security and reliability. The contract features public functions for registering players, minting tokens, burning tokens, transferring tokens, and querying player token balances, with specific permissions enforced by the `onlyOwner` modifier.

### Key Features
- **ERC20 Compliance**: Inherits standard ERC20 functionality from OpenZeppelin.
- **Ownership Management**: Utilizes OpenZeppelin's `Ownable` contract to manage contract ownership.
- **Player Registration**: Allows the contract owner to register players.
- **Decimal Customization**: Overrides the `decimals` function to set the token decimals to zero.
- **Minting and Burning**: Allows the owner to mint tokens for registered players and any registered player to burn their tokens.
- **Transfer Function**: Allows registered players to transfer tokens to other registered players.

### Key Functions and Statements
- **`require`**: Ensures conditions are met before executing certain functions, reverting the transaction if conditions are not met.
- **`onlyOwner`**: A modifier that restricts certain functions to be called only by the contract owner.

## Getting Started

### Installing
1. **Download the Project**
   - Clone the repository from GitHub:
     
   - Navigate to the project directory:
     ```sh
     cd ETH_AVAX_INTER_MOD_3
     ```

2. **Open Remix IDE**
   - Go to [Remix IDE](https://remix.ethereum.org/).
   - In the file explorer, create a new file named `GameToken.sol`.

3. **Copy and Paste the Smart Contract Code**
   - Copy the following code and paste it into `GameToken.sol`:
     ```solidity
    // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// This contract creates a custom ERC20 token called CustomToken with symbol CST.
// - Only the contract owner can mint new tokens.
// - Any user can transfer tokens.
// - Any user can burn tokens.

// Author: [Devansh]

contract CustomToken is ERC20, Ownable {
    
    // Structure to store user registration status
    struct User {
        bool isRegistered;
    }

    // Mapping to store the registration status of each user by their address
    mapping(address => User) public users;

    // Constructor to initialize the token with name "Custom" and symbol "CST"
    // Sets the contract deployer as the initial owner
    constructor() ERC20("Custom", "CST") {
        // Transfer ownership to the deployer
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

     ```

### Executing Program

#### How to Run the Program in Remix
1. **Compile the Smart Contract**
   - Select the `Solidity Compiler` tab.
   - Ensure the compiler version is set to `0.8.20`.
   - Click `Compile GameToken.sol`.

2. **Deploy the Contract**
   - Go to the `Deploy & Run Transactions` tab.
   - Select the appropriate environment (e.g., JavaScript VM).
   - Click `Deploy`.

3. **Interact with the Contract**
   - After deploying, the contract will appear under `Deployed Contracts`.
   - To register a player:
     - Input the player's address.
     - Click the `registerPlayer` button.
   - To mint tokens:
     - Input the player's address and the amount of tokens to mint.
     - Click the `mint` button.
   - To burn tokens:
     - Input the player's address and the amount of tokens to burn.
     - Click the `burn` button.
   - To transfer tokens:
     - Input the sender's address, receiver's address, and the amount of tokens to transfer.
     - Click the `transferPoints` button.
   - To get player points:
     - Input the player's address.
     - Click the `getPlayerPoints` button.

## Help

### Common Issues
- **Compilation Errors**: Ensure the Solidity version specified matches the version set in the Remix compiler.
- **Deployment Errors**: Make sure the selected environment is correct and the contract is compiled without errors.
- **Interaction Errors**: Ensure the address and value inputs are valid, that players are registered, and that sufficient balance exists for burning or transferring tokens.

For detailed debugging and assistance, refer to the Remix documentation or community forums.

## Authors
- **Devansh Satsangi**
 
## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
