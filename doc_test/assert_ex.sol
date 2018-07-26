pragma solidity ^0.4.24;

contract Sharer {
	function sendHalf(address addr) public payable returns (uint balance) {
		require(msg.value % 2 == 0, "Even value required.");
		uint balanceBeforeTransfer = this.balance;
		addr.transfer(msg.value / 2);
		// Since transfer throws an exception on failure and
		// cannot call back here, there should be no way for us to
		// still have half of the money.
		assert(this.balance == balanceBeforeTransfer - (msg.value / 2));
		return this.balance;
	}
}