pragma solidity >=0.8.4;

contract Bank{
    struct accounts{
        uint amt;
        address owner;
        uint256 creationTime;
    }
    mapping(uint=>accounts) public bank_lockers;
    event dep(uint amt);
    event accCreate(address indexed who, uint amt, uint when);
    event wit(uint accNo, uint amt);
    uint counter=1;
    modifier minimum(){
        require(msg.value>=1 ether, "doesnt follows minimum amt to form account");
        _;
    }
    modifier onlyOwner(uint _accNo){
        require(msg.sender==bank_lockers[_accNo].owner, "not the owner of this account");
        _;
    }
    function accCreation() public payable minimum{
        bank_lockers[counter].amt=msg.value;
        bank_lockers[counter].owner=msg.sender;
        bank_lockers[counter].creationTime=block.timestamp;
        emit accCreate(msg.sender, msg.value, block.timestamp);
    }
    function deposit(uint _accNo) public payable minimum onlyOwner(_accNo){
        bank_lockers[_accNo].amt+=msg.value;
        emit dep(msg.value);
    }
    function withdraw(uint _accNo) public onlyOwner(_accNo){
        payable(msg.sender).transfer(bank_lockers[_accNo].amt);
        emit wit(_accNo, bank_lockers[_accNo].amt);
    }
}