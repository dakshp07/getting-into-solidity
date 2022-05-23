pragma solidity >=0.8.4;

contract AccessControl{
    event GrantRole(address indexed account, bytes32 indexed role);
    event RevokeRole(address indexed account, bytes32 indexed role);
    
    // role => account => bool
    mapping(bytes32 => mapping(address => bool)) public roles;

    // 0xdf8b4c520ffe197c5343c6f5aec59570151ef9a492f2c624fd45ddde6135ec42
    bytes32 private constant ADMIN=keccak256(abi.encodePacked("ADMIN"));

    // 0x2db9fd3d099848027c2383d0a083396f6c41510d7acfd92adc99b6cffcf31e96
    bytes32 private constant USER=keccak256(abi.encodePacked("USER"));

    modifier onlyRole(bytes32 _role){
        require(roles[_role][msg.sender], "not authorized");
        _;
    }
    constructor(){
        _grantRole(ADMIN, msg.sender);
    }
    function _grantRole(bytes32 _role, address account) internal{
        roles[_role][account]=true;
        emit GrantRole(account, _role);
    }
    function grantRole(bytes32 _role, address account) external onlyRole(ADMIN){
        _grantRole(_role, account);
    }
    function _revokeRole(bytes32 _role, address account) external onlyRole(ADMIN){
        roles[_role][account]=false;
        emit RevokeRole(account, _role);
    }
    
}