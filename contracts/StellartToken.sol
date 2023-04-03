// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract StellartToken {

    // Declarations
    string public name = "Stellart Token";
    string public symbol = "STE";
    uint256 public totalSupply = 1000000000000000000000000; // 1 million tokens
    uint8 public decimals = 18;

    // Event for token transfer from a user
    event Transfer (
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    // Event for the approval from an operator
    event Approval (
        address indexed _owner,
        address indexed _spender,
        uint256 value
    );

    // Data structures
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    // Constructor
    constructor(){
        balanceOf[msg.sender] = totalSupply;
    }

    // Token transfer from a user
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // Approval of an amount to be spent by an operator
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // Token transfer specifying the transmitter
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

}