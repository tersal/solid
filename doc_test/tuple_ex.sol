pragma solidity >0.4.23 <0.5.0

contract C {
	uint[] data;
	
	function f() public pure returns (uint, bool, uint) {
		return (7, true, 2);
	}
	
	function g() public {
		// Variables declared with type and assigned from the returned tuple.
		(uint x, bool b, uint y) = f();
		// Common trick to swap values -- does not work for non value storage types.
		(x, y) = (y, x);
		// Components can be left out (also for variable declarations).
		(data.length,,) = f();
		// Components can only be left out at the left-hand-side of  assignments, with
		// one exception:
		(x,) = (1,);
		// (1,) is the only way to specify a 1-component typle, because (1) is
		// equivalente to 1.
	}
}

