pragma solidity ^0.4.24;

// An example that uses external function types.
contract Oracle {
	
	struct Request {
		bytes data;
		function(bytes memory) external callback;
	}
	
	Request[] requests;
	
	event NewRequest(uint);
	
	function query(bytes data, function(bytes memory) external callback) public {
		requests.push(Request(data, callback));
		emit NewRequest(requests.length - 1);
	}
	
	function reply(uint requestID, bytes response) public {
		// Here goes the check that the reply comes from a trusted source
		requests[requestID].callback(response);
	}
}

contract OracleUser {
	
	Oracle constant oracle = Oracle(0x1234567);  // known contract
	
	function buySomething() public {
		oracle.query("USD", this.oracleResponse);
	}
	
	function oracleResponse(bytes response) public {
		require(msg.sender == address(oracle), "Only oracle can call this.");
		// Use the data.
	}
}
