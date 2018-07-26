pragma solidity ^0.4.24;

contract DeleteExample {
	uint data;
	uint[] dataArray;
	
	function f() public {
		uint x = data;
		delete x; // Sets x to 0, does not affect `data`
		delete data; // Sets `data` to 0, does not affect `x` which still holds a copy
		uint[] storage y = dataArray;
		delete dataArray; // This sets dataArray.length to zero, but as uint[] is a complex object, also
		// y is affected which is an alias to the storage object.
		// On the other hand: "delete y" is not valid, as assignments to local variables
		// referencing storage objects can only be made from existing storage objects.
	}
}