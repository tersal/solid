pragma solidity ^0.4.24;

contract C {
	
	uint[] x; // The data location of `x` is storage
	
	// The data location of memoryArray is memory
	function f(uint[] memoryArray) public {
		x = memoryArray; // works, copies the whole array to storage
		var y = x;       // works, assigns a pointer, data location of y is storage.
		y[7];            // fine, returns the 8th element
		y.length = 2;    // fine, modifies x through y
		delete x;        // fine, clears the array, also modifies y
		// The following does not work; it would need to create a new temporary /
		// unnamed array in storage, but storage is "statically" allocated:
		// y = memoryArray;
		// This does not work either, since it would "reset" the pointer, but there
		// is no sensible location it could point to.
		// delete y;
		g(x); // calls g, handling over a referenve to x
		h(x); // calls h and creates and independent, temporary copy in memory
	}
	
	function g(uint[] storage storageArray) internal {}
	function h(uint[] memoryArray) public {}
}