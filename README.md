# Independence Lock - Self-Custodial Vault

A beginner-friendly Solidity smart contract for storing ETH securely with full control and timelock protection.

## 🎯 Project Overview

- Deposit ETH securely
- Only the contract owner can withdraw
- Built-in 7-day timelock for security
- Full self-custody with no third-party risks

## Independence Lock

A self-custodial Ethereum vault with timelock protection. Store ETH securely and only withdraw after a 7-day waiting period.

## Features

- Connect MetaMask wallet securely
- Deposit ETH into smart contract vault
- View contract balance in real-time
- Withdraw ETH (only contract owner, after 7-day timelock)
- Check remaining timelock countdown
- Full self-custody - no third-party risks
- Real-time transaction status feedback
- Improved UX with contextual error handling
- Smart UI behavior based on contract state (timelock-aware UI)

## Tech Stack

- **Smart Contract**: Solidity
- **Frontend**: HTML, CSS, JavaScript
- **Blockchain**: Ethereum Sepolia Testnet
- **Wallet**: MetaMask
- **Web3 Library**: ethers.js

## How to Run Locally

1. Clone or download the project
2. Navigate to the `frontend/` folder
3. Open `index.html` in your browser
   - Double-click the file
   - OR run `python -m http.server 8000` and visit `http://localhost:8000`
4. Make sure MetaMask is installed and unlocked

## How to Use

### 1. Connect Wallet
- Click "Connect MetaMask"
- Approve connection in MetaMask popup
- Ensure you're on Sepolia Testnet

### 2. Deposit ETH
- Enter amount (e.g., 0.01) in the deposit field
- Click "Deposit ETH"
- Confirm transaction in MetaMask
- Wait for confirmation

### 3. Check Balance
- Click "Get Contract Balance"
- View current ETH stored in contract

### 4. Withdraw ETH (Owner Only)
- Click "Withdraw All ETH"
- Only works if you're contract owner
- Only works after 7-day timelock expires
- Confirm transaction in MetaMask
- UI shows "Funds are locked due to timelock" if not expired

### 5. Check Timelock
- Click "Check Time Remaining"
- See days/hours/minutes until withdrawal allowed
- Withdraw button automatically enabled/disabled based on timelock status

## Complete User Flow
Connect wallet → deposit → see transaction status → check balance → attempt withdraw (blocked if locked) → view timelock

## 🛡️ Security Features

### Require Statements
- ✅ Deposit must be > 0 ETH
- ✅ Only owner can withdraw
- ✅ Timelock must be expired
- ✅ Must have funds to withdraw
- ✅ Transfer must succeed

### Best Practices
- **Immutable variables** for owner and lock time
- **Events** for transparency
- **Reentrancy protection** via checks-effects-interactions pattern
- **No external dependencies** - pure Solidity

## 📚 Learning Concepts

This contract teaches beginners about:
- **State Variables**: Storing data on blockchain
- **Modifiers & Access Control**: Owner-only functions
- **Time-based Logic**: Using `block.timestamp`
- **Events**: Logging important actions
- **Error Handling**: `require` statements
- **ETH Transfer**: `.call()` method
- **Immutability**: `immutable` keyword

## 🧪 Testing Scenarios

### ✅ Should Work
- Anyone deposits ETH ✅
- Owner withdraws after 7 days ✅
- Check balance anytime ✅
- Check time remaining ✅

### ❌ Should Fail
- Non-owner tries to withdraw ❌
- Owner withdraws before 7 days ❌
- Deposit 0 ETH ❌
- Withdraw with no balance ❌

## 📝 Contract Code

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract IndependenceLock {
    address public immutable owner;
    uint256 public immutable lockTime;
    uint256 public constant LOCK_DURATION = 7 days;
    
    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed owner, uint256 amount);
    
    constructor() {
        owner = msg.sender;
        lockTime = block.timestamp + LOCK_DURATION;
    }
    
    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        emit Deposit(msg.sender, msg.value);
    }
    
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(block.timestamp >= lockTime, "Timelock not expired yet");
        require(address(this).balance > 0, "No funds to withdraw");
        
        uint256 amount = address(this).balance;
        emit Withdrawal(owner, amount);
        
        (bool success, ) = owner.call{value: amount}("");
        require(success, "Transfer failed");
    }
    
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    function getTimeRemaining() external view returns (uint256) {
        if (block.timestamp >= lockTime) {
            return 0;
        }
        return lockTime - block.timestamp;
    }
}
```

## 🎓 Educational Value

Perfect for college projects because it demonstrates:
- **Smart Contract Basics**: State, functions, events
- **Security Principles**: Access control, validation
- **Real-world Use Case**: Digital vault application
- **Gas Optimization**: Efficient code structure
- **Best Practices**: Clean, commented code

## Recent Improvements (Day 5)

### Enhanced Transaction Feedback
- **Step-by-step status**: Pending → Confirming → Confirmed
- **Visual indicators**: Clear emoji-based status messages (⏳→⛓→✅)
- **Persistent messaging**: Extended display time for better readability

### Improved Error Handling
- **User-friendly messages**: Replaced raw errors with understandable text
- **Contextual errors**: "Funds are locked due to timelock" instead of CALL_EXCEPTION
- **Smart error mapping**: Network, insufficient funds, user cancellation handling

### Smart UI Behavior
- **Timelock-aware interface**: Withdraw button auto-disabled when locked
- **Section-specific messaging**: Clear status under withdraw section
- **Automatic state updates**: UI responds to contract state changes

### Complete User Flow
Connect wallet → deposit → see transaction status → check balance → attempt withdraw (blocked if locked) → view timelock

## Live Demo
**Live Demo**: https://drishtichaudhary.github.io/Independence-Lock/

---

**Project Duration**: 1 week college project  
**Difficulty Level**: Beginner  
**Learning Focus**: Solidity fundamentals & security patterns
