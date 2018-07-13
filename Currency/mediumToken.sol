pragma solidity ^0.4.24;

interface tokenRecipient { function receiveApproval(address _from, uint256 _value, bytes _extraData) external; }

contract TokenERC20 {
	// Public variables of the token
	string public name;
	string public symbol;
	uint8 public decimals = 18;
	
	// 18 decimals is the strongly suggested default, avoid changin it.
	uint256 public totalSupply;
	
	// This creates an array with all balances
	mapping (address => uint256) public balanceOf;
	mapping (address => mapping (address => uint256)) public allowance;
	
	// This generates a public event on the blockchain that will notify clients
	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	
	// This generates a public event on the blockchain that will notify clients
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
	
	// This notifies clients about the amount burnt
	event Burn(address indexed _from, uint256 _value);
	
	/**
	 * Constructor function
	 *
	 * Initializes contract with initial supply tokens to the creator of the contract.
	 */
	constructor (
		uint256 _initialSupply,
		string _tokenName,
		string _tokenSymbol
	) public {
		totalSupply = _initialSupply * (10 ** uint256(decimals)); // Update total supply with the decimal amount
		balanceOf[msg.sender] = totalSupply;                      // Give the creator all initial tokens
		name = _tokenName;                                        // Set the name for display purposes
		symbol = _tokenSymbol;                                    // Set the symbol for display purposes
	}
	
	/// Internal transfer, only to be called by this contract.
	function _transfer(address _from, address _to, uint _value) internal {
		// Prevent transfer to 0x00. Use burn() instead.
		require(_to != 0x00);
		// Check if the sender has enough.
		require(balanceOf[_from] >= _value, "Not enough resources to send.");
		// Check for overflows.
		require(balanceOf[_to] + _value >= balanceOf[_to], "Possible overflow in the recipient address");
		// Save this for an assertion in the future
		uint previousBalances = balanceOf[_from] + balanceOf[_to];
		// Substract from the sender
		balanceOf[_from] -= _value;
		// Add the same amount to the recipient
		balanceOf[_to] += _value;
		emit Transfer(_from, _to, _value);
		// Asserts are used to use static analysis to find bugs in your code. They should never fail
		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
	}
	
	/**
	 * Transfer tokens
	 *
	 * Send `_value` tokens to `_to` from your account
	 *
	 * @param _to The address of the recipient
	 * @param _value The amount to send
	 */
	function transfer(address _to, uint256 _value) public returns (bool success) {
		_transfer(msg.sender, _to, _value);
		return true;
	}
	
	/**
	 * Transfer tokens from other address
	 *
	 * Send `_value` tokens to `_to` on behalf of `_from`
	 *
	 * @param _from The address of the sender
	 * @param _to The address of the recipient
	 * @param _value The amount to send
	 */
	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
		require(_value <= allowance[_from][msg.sender]);
		allowance[_from][msg.sender] -= _value;
		_transfer(_from, _to, _value);
		return true;
	}
	
	/**
	 * Set allowance for other address
	 *
	 * Allows `_spender` to spend no more than `_value` tokens on your behalf
	 *
	 * @param _spender The address authorized to spend
	 * @param _value The max amount they can spend
	 */
	function approve(address _spender, uint256 _value) public returns (bool success) {
		allowance[msg.sender][_spender] = _value;
		emit Approval(msg.sender, _spender, _value);
		return true;
	}
	
	/**
	 * Set allowance for other address and notify
	 *
	 * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
	 *
	 * @param _spender The address authorized to spend
	 * @param _value The max amount they can spend
	 * @param _extraData Some extra information to send to the approved contract
	 */
	 function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
		 tokenRecipient spender = tokenRecipient(_spender);
		 if(approve(_spender, _value)) {
			 spender.receiveApproval(msg.sender, _value, _extraData);
			 return true;
		 }
		 return false;
	 }
	 
	 /**
	  * Destroy tokens
	  *
	  * Remove `_value` tokens from the system irreversibly
	  *
	  * @param _value The amount of money to burn
	  */
	  function burn(uint256 _value) public returns (bool success) {
		  require(balanceOf[msg.sender] >= _value, "Not enough tokens to burn.");  // Check if the sender has enough
		  balanceOf[msg.sender] -= _value;  // Substract from the sender
		  totalSupply -= _value;  // Updates totalSupply
		  emit Burn(msg.sender, _value);
		  return true;
	  }
	  
	  /**
	   * Destroy tokens from other account
	   *
	   * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
	   *
	   * @param _from The address of the sender
	   * @param _value The amount of money to burn
	   */
	  function burnFrom(address _from, uint256 _value) public returns (bool success) {
		  require(balanceOf[_from] >= _value, "Source account don't have enough tokens");  // Check if the targeted balance is enough
		  require(_value <= allowance[_from][msg.sender], "You are not allowed to burn this");  // Check allowance
		  balanceOf[_from] -= _value;  // Substract from the targeted balance
		  allowance[_from][msg.sender] -= _value;  // Substract from the sender's allowance
		  totalSupply -= _value;
		  emit Burn(_from, _value);
		  return true;
	  }
}