// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./JamToken.sol";
import "./StellartToken.sol";

// Owner: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
// user: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2

contract TokenFarm {

    // Initial declarations
    string public name = "Stellart Token Farm";
    address public owner;
    JamToken public jamToken;
    StellartToken public stellartToken;

    // Data structures
    address [] public stakers;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    // Constructor
    constructor(StellartToken _stellartToken, JamToken _jamToken) {
        stellartToken = _stellartToken;
        jamToken = _jamToken;
        owner = msg.sender;
    }

    // Token staking
    function stakeTokens(uint _amount) public {
        // An amount greater than 0 is required
        require(_amount > 0, "Amount can't be less than 0");
        // Transfer JAM tokens to the main SC
        jamToken.transferFrom(msg.sender, address(this), _amount);
        // Update the staking balance
        stakingBalance[msg.sender] += _amount;
        // Save the staker
        if (!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }
        // Update the staking state
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    // Quit token staking
    function unstakeTokens() public {
        // Staking balance from a user
        uint balance = stakingBalance[msg.sender];
        // An amount greater than 0 is required
        require(balance > 0, "Staking balance is 0");
        // Transfer tokens to the user
        jamToken.transfer(msg.sender, balance);
        // Reset the staking balance of the user
        stakingBalance[msg.sender] = 0;
        // Update the staking state
        isStaking[msg.sender] = false;
    }

    // Token issuance (rewards)
    function issueTokens() public {
        // Only executable by owner
        require(msg.sender == owner, "You are not the owner");
        // Issue tokens to all the stakers
        for (uint i = 0; i < stakers.length; i++) {
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient];
            if (balance > 0) {
                stellartToken.transfer(recipient, balance);
            }
        }
    }
}