// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IndependenceLock
 * @dev A self-custodial vault for storing ETH with timelock protection
 * @notice Users can deposit ETH, only owner can withdraw after timelock
 */
contract IndependenceLock {
    
    // State variables
    address public immutable owner;           // Contract owner (deployer)
    uint256 public immutable lockTime;       // Timestamp when withdrawal becomes allowed
    uint256 public constant LOCK_DURATION = 7 days; // 1 week timelock
    
    // Events for transparency
    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed owner, uint256 amount);
    
    /**
     * @dev Sets the contract deployer as owner and calculates lock time
     */
    constructor() {
        owner = msg.sender;
        lockTime = block.timestamp + LOCK_DURATION;
    }
    
    /**
     * @dev Allows anyone to deposit ETH into the vault
     */
    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        emit Deposit(msg.sender, msg.value);
    }
    
    /**
     * @dev Allows owner to withdraw all ETH after timelock expires
     */
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(block.timestamp >= lockTime, "Timelock not expired yet");
        require(address(this).balance > 0, "No funds to withdraw");
        
        uint256 amount = address(this).balance;
        emit Withdrawal(owner, amount);
        
        (bool success, ) = owner.call{value: amount}("");
        require(success, "Transfer failed");
    }
    
    /**
     * @dev Returns the current balance of the vault
     */
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    /**
     * @dev Returns time remaining until withdrawal is allowed
     */
    function getTimeRemaining() external view returns (uint256) {
        if (block.timestamp >= lockTime) {
            return 0;
        }
        return lockTime - block.timestamp;
    }
}
