pragma solidity ^0.4.24;

contract Test {
	// This function is called for all messages sent to
	// this contract (there is no other function).
	// Sending Ether to this contract will cause an exception,
	// because the fallback function does not have the `payable`
	// modifier.
	function() public { x = 1; }
	uint x;
}

// This contract keeps all Ether sent to it with no way
// to get it back
contract Sink {
	function() public payable { }
}

contract Caller {
	function callTest(Test test) public {
		address(test).call(0xabcdef01); // hash doe snot exist
		// results in test.x becoming == 1.
		
		// The following will not compile, but even
		// if someone sends ether to that contract,
		// the transaction will fail and reject the
		// Ether.
		// test.send(2 ether);
	}
}