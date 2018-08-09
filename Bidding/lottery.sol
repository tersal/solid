pragma solidity ^0.4.24;

contract TestLotto {
	
	uint public endOfRound; // Indicate when the round will finish
	address public organizer; // Organizer of the lottery
	bool public lottoEnded;
	
	uint256 public totalAmount; // Total amount combined for the round
	mapping(address => uint) players; // Current list of registered players
	
	event Received(address indexed _from, int _value); //Event to alert the user about the new deposit
	event Winner(address indexed _winner, int _totalPrize) //Event to alert about the winner of this round
	
	/// Creates a new lottery round with the expected `_lottoEnd` duration
	/// in seconds and the `_organizer` who will take care of the lottery.
	constructor (uint _lottoEnd, address _organizer) {
		endOfRound = now + _lottoEnd;
		organizer = _organizer;
		totalAmount = 0;
	}
	
	/// Add a participation on the lottery with the value sent,
	/// the player will be allowed to retrieve its money before
	/// the lottery starts
	function lottoBid public payable {
		// The lotto should be still available in
		// order to receive founds
		require(now >= endOfRound);
		
		// Save the current player data
		players[msg.sender] += msg.value;
		totalAmount += msg.value;
	}
	
	/// This function allows the player to withdraw their
	/// participation from the contract, it can only
	/// be used as long as the lottery is still not initialized.
	function withdraw() public {
		// we don't refund the ether if the lottery has
		// already ended.
		require(!lottoEnded);
		
		uint amount = players[msg.sender];
		
		if (amount > 0) {
			// We reset the owed amount to 0
			players[msg.sender] = 0;
			msg.sender.transfer(amount);
		}
	}
	
	/// End the lottery and transfer the prize to the
	/// winner.
	function lotteryEnd() public {
		// Verify that the lottery time ended
		require(now > endOfRound);
		require(!lottoEnded);
		
		
	}
}