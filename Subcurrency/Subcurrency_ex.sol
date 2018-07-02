pragma solidity ^0.4.24;

contract Coin {
	// Keyword "public" to make these variables
	// readable from outside
	address public minter;
	mapping(address => uint) public balances;
	
	// Events allow light clients to react on
	// changes efficiently
	event Sent(address from, address to, uint amount);
	
	// Constructor whose code is
	// run only when the contract is created
	function Coin() public {
		minter = msg.sender;
	}
	
	function mint(address receiver, uint amount) public {
		if (msg.sender != minter) return;
		balances[receiver] += amount;
	}
	
	function send(address receiver, uint amount) public {
		if (balances[msg.sender] < amount) return;
		balances[msg.sender] -= amount;
		balances[receiver] += amount;
		emit Sent(msg.sender, receiver, amount);
	}
}