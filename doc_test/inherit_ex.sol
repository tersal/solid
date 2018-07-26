pragma solidity ^0.4.24;

contract owned {
	constructor() public { owner = msg.sender; }
	address owner;
}

// Use`is` to derive from another contract. Derived
// contracts can access all non-private members including
// internal function and state variables. These cannot be
// accessed externally via `this`, though.
contract mortal is owned {
	function kill() public {
		if (msg.sender == owner) selfdestruct(owner);
	}
}

// These abstract contracts are only provided to make the
// interfae known to the compiler. Note the function
// without body. If a contract does not implement all
// function it can only be used as an interface.
contract Config {
	function lookup(uint _id) public returns (address adr);
}

contract NameReg {
	function register(bytes32 name) public;
	function unregister() public;
}

// Multiple inheritance is possible. Note that `owned` is
// also a base class of `mortal`, yet there is only a single
// instance of `owned` (as for virtual inheritance in C++).
contract named is owned, mortal {
	constructor(bytes32 name) public {
		Config config = Config(0xD5f9D8D94886E70b06E474c3fB14Fd43E2f23970);
		NameReg(config.lookup(1)).register(name);
	}
	
	// Functions can be overridden by another function with the same name and
	// the sma number/types of inputs. If the overriding functions has different
	// types of output parameters, that causes an error.
	// Both local and message-based functions calls take these overrides
	// into account.
	function kill() public {
		if (msg.sender == owner) {
			Config config = Config(0xD5f9D8D94886E70b06E474c3fB14Fd43E2f23970);
			NameReg(config.lookup(1)).unregister();
			// It is still possible to call a specific
			// overridden function.
			mortal.kill();
		}
	}
}

// If a constructor takes an argument, it needs to be
// provided in the header (or modifier-invocation-style at
// the construct of the derived contract (see below))).
contract PriceFeed is owned, mortal, named("GoldFeed") {
	function updateInfo(uint _newInfo) public {
		if (msg.sender == owner) info = _newInfo;
	}
	
	function get() public view returns(uint r) { return info; }
	
	uint info;
}