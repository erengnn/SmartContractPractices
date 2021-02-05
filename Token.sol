//*** Exercice 6 ***//
contract Token {
    mapping(address => uint) public balances;

    /// @dev Buy token at the price of 1ETH/token.
    function buyToken() public payable {
        balances[msg.sender]+=msg.value/ 1 ether;
    }

    /** @dev Send token.
     *  @param _recipient The recipient.
     *  @param _amount The amount to send.
     */
    function sendToken(address _recipient, uint _amount) {
        require(balances[msg.sender]>=_amount); // You must have some tokens.

        balances[msg.sender]-=_amount;
        balances[_recipient]+=_amount;
    }

    /** @dev Send all tokens.
     *  @param _recipient The recipient.
     */
    function sendAllTokens(address _recipient) {
        balances[_recipient]=+balances[msg.sender];
        balances[msg.sender]=0;
    }

     function getBalance() public view returns(uint){
        return balances[msg.sender];
    }

}

contract Attack {
    Token public token;
    function Attack (address _address) {
    token = Token(_address);
    }

    function getBalanceContract() public view returns(uint){
        return address(token).balance;
    }
    function selfdes()public payable{
        selfdestruct(address(token));
    }
}
