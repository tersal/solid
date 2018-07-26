pragma solidity ^0.4.24;

contract D {
	uint x;
	
	constructor(uint a) public payable {
		x = a;
	}
	
}

contract C {
	D d = new D(4); // Will be executed as part of C's constructor
	
	function createD(uint arg) public {
		D newD = new D(arg);
	}
	
	function createAndEndowD(uint arg, uint amount) public payable {
		// Send ether along with the creation
		D newD = (new D).value(amount)(arg);
	}
}