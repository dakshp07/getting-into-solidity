// covers all basic concept of solidity
pragma solidity >=0.8.4;

contract MultiSig{
    event Deposit(address indexed sender, uint amt);
    event Submit(uint indexed txId);
    event Approve(address indexed owner, uint indexed txId);
    event Revoke(address indexed owner, uint indexed txId);
    event Execute(uint indexed txId);

    struct Transaction{
        address to;
        uint amt;
        bytes data;
        bool executed;
    }
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public required; // no of sig required for wallet

    Transaction[] public transactions;
    mapping(uint => mapping(address=>bool)) public approved; // who have approved which transaction

    constructor(address[] memory _owners, uint _required){
        require(_owners.length>0, "owners required");
        require(_required>0 && _required<=_owners.length, "invalid required no of owners");
        for(uint i; i<owners.length; i++)
        {
            address owner=owners[i];
            require(owner!=address(0), "invalid owner");
            require(!isOwner[owner], "owner is not unique");
            isOwner[owner]=true;
            owners.push(owner);
        }
        required=_required;
    }
    receive() external payable{
        emit Deposit(msg.sender, msg.value);
    }
    modifier onlyOwner(){
        require(isOwner[msg.sender], "not owner");
        _;
    }
    function submit(address _to, uint _amt, bytes calldata _data) external onlyOwner{
        transactions.push(Transaction({
            to: _to,
            amt: _amt,
            data: _data,
            executed: false
        }));
        emit Submit(transactions.length-1);
    }
    modifier txExist(uint _txId){
        require(_txId<transactions.length, "tx not exist");
        _;
    }
    modifier notApproved(uint _txId){
        require(!approved[_txId][msg.sender], "tx already approved");
        _;
    }
    modifier notExecuted(uint _txId){
        require(!transactions[_txId].executed, "tx already executed");
        _;
    }
    function approve(uint _txId) external onlyOwner txExist(_txId) notApproved(_txId) notExecuted(_txId){
        approved[_txId][msg.sender]=true;
        emit Approve(msg.sender, _txId);
    }
    function _getApprovalCount(uint _txId) private view returns (uint cnt){
        for(uint i; i<owners.length; i++)
        {
            if(approved[_txId][owners[i]])
            {
                cnt+=1;
            }
        }
    }
    function execute(uint _txId) external txExist(_txId) notExecuted(_txId){
        require(_getApprovalCount(_txId)>=required, "approvals<required");
        Transaction storage _transaction=transactions[_txId];
        _transaction.executed=true;
        (bool success, ) = _transaction.to.call{value: _transaction.amt}(
            _transaction.data
        );
        require(success, "transaction failed");
        emit Execute(_txId);
    }
    function revoke(uint _txId) external onlyOwner txExist(_txId) notExecuted(_txId){
        require(approved[_txId][msg.sender], "tx not approved");
        approved[_txId][msg.sender]=false;
        emit Revoke(msg.sender, _txId);
    }
}