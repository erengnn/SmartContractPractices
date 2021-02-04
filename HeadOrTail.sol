//*** Exercice 8 ***//

//*** Solution ***//
/****************************************
*web3.eth.getStorageAt(contract_address,0)
*All variables in this contract are kept in slot 0.
*We need to know lastChoiceHead value is equal to true or false. This value is kept in the last four numbers of slot 0.
*if we use this Javascript code after the choose function execute web3.eth.getStorageAt(contract address,0) we get return value like this =0x00000000000000000000c4015158ff08024cc71cd020f42c40751b9836b80001
*if we look at the last four digits of this return value = 0x00000000000000000000c4015158ff08024cc71cd020f42c40751b9836b80001
*if the last four number is equal 0001 this is mean lastChoiceHead = false
*if the last four number is equal 0101 this is mean lastChoiceHead = true
*now we know that the value is true or false, the rest is just entering the required value in the guess function.
*****************************************/

pragma solidity ^0.4.10;
contract HeadOrTail {
    bool public chosen; // True if head/tail has been chosen.
    bool lastChoiceHead; // True if the choice is head.
    address public lastParty; // The last party who chose.

    /** @dev Must be sent 1 ETH.
     *  Choose head or tail to be guessed by the other player.
     *  @param _chooseHead True if head was chosen, false if tail was chosen.
     */
    function choose(bool _chooseHead) payable {
        require(!chosen);
        require(msg.value == 1 ether);

        chosen=true;
        lastChoiceHead=_chooseHead;
        lastParty=msg.sender;
    }

    function guess(bool _guessHead) payable {
        require(chosen);
        require(msg.value == 1 ether);

        if (_guessHead == lastChoiceHead)
            msg.sender.transfer(2 ether);
        else
            lastParty.transfer(2 ether);

        chosen=false;
    }
  }
