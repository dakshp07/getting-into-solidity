pragma solidity ^0.8.13;
import "./IERC20.sol";
contract Vault{
    IERC20 public immutable token; // our coins
    uint public totalSupply;
    mapping(address=>uint) public balanceOf;
    constructor(address _token){
        token=IERC20(_token);
    }
    function _mint(address _to, uint _amt) private {
        totalSupply+=_amt;
        balanceOf[_to]+=_amt;
    }
    function _burn(address _to, uint _amt) private {
        totalSupply-=_amt;
        balanceOf[_to]-=_amt;
    }
    function deposit(uint _amt) external {
        /*
        a=amt;
        b=balance of token before deposit
        t=total supply
        s=shares to mint
        (t+s)/t=(a+b)/b; // amt of shares to mint is proportional to the increase in balance of token
        s=a*t/b; // we get s from above eq
        */
        uint shares;
        if(totalSupply==0)
        {
            shares=_amt;
        }
        else
        {
            shares=(_amt*totalSupply)/token.balanceOf(address(this));
        }
        _mint(msg.sender, shares);
        token.transferFrom(msg.sender, address(this), _amt);
    }
    function withdraw(uint _shares) external {
        /*
        a=amt;
        b=balance of token before withdraw
        t=total supply
        s=shares to burn
        (t-s)/t=(a-b)/b; // amt of shares to burn is proportional to the decrease in balance of token
        s=a*t/b; // we get s from above eq
        */
        uint amt=(_shares*token.balanceOf(address(this)))/totalSupply;
        _burn(msg.sender, _shares);
        token.transfer(msg.sender, amt);
    }
}