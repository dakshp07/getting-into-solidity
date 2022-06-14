// SPDX-License-Identifier: MIT
// Constant Sum Automated Market Maker
pragma solidity >=0.8.4;
import "./interface/IERC20.sol";

contract CSAMM{
    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint public reserve0;
    uint public reserve1;

    uint public totalSupply;
    mapping(address=>uint) public balanceOf;

    constructor(address _token0, address _token1){
        token0=IERC20(_token0);
        token1=IERC20(_token1);
    }

    function _mint(address _to, uint _amt) private {
        balanceOf[_to]+=_amt;
        totalSupply+=_amt;
    }

    function _update(uint _res0, uint _res1) private {
        reserve0=_res0;
        reserve1=_res1;
    }

    function _burn(address _from, uint _amt) private {
        balanceOf[_from]-=_amt;
        totalSupply-=_amt;
    }

    function swap(address _tokenIn, uint _amtIn) external returns (uint amtOut){
        require(_tokenIn==address(token0) || _tokenIn==address(token1), "invalid token");
        bool isToken0=_tokenIn==address(token0);
        (IERC20 tokenIn, IERC20 tokenOut, uint resIn, uint resOut)=isToken0?(token0, token1, reserve0, reserve1) : (token1, token0, reserve1, reserve0);
        // transfer token in
        tokenIn.transferFrom(msg.sender, address(this), _amtIn);
        uint amtIn=tokenIn.balanceOf(address(this))-resIn;
        // compute the amount out (include fees)
        // amount of token in = amount of token out
        // fees=0.3%
        amtOut=(amtIn*997)/1000; // taking 0.3% as fees and sending rest as out
        // update reserve0, reserve1
        (uint res0, uint res1)=isToken0?(resIn+amtIn, resOut-amtOut):(resOut-amtOut, resIn+amtIn);
        _update(res0, res1);
        // transfer token out
        tokenOut.transfer(msg.sender, amtOut);
    }
    function addLiquidity(uint _amt0, uint _amt1) external returns(uint shares){
        token0.transferFrom(msg.sender, address(this), _amt0);
        token1.transferFrom(msg.sender, address(this), _amt1);

        uint bal0=token0.balanceOf(address(this));
        uint bal1=token1.balanceOf(address(this));

        uint d0=bal0-reserve0;
        uint d1=bal1-reserve1;

        /*
        a=amt in;
        l=total liquidity;
        s=shares to mint;
        t=total supply
        (l+a)/l=(t+s)/t;
        s=a*t/l;
        */

        if(totalSupply==0)
        {
            shares=d0+d1;
        }
        else
        {
            shares=((d0+d1)*totalSupply)/(reserve0+reserve1);
        }
        require(shares>0, "shares are 0");
        _mint(msg.sender, shares);

        _update(bal0, bal1);
    }
    function removeLiquidity(uint _shares) external returns(uint d0, uint d1){
        /*
        a=amt out;
        l=total liquidity;
        s=shares;
        t=total supply
        a/l=s/t;
        a=l*s/t;
         =(reserve0+reserve1)*s/t;
        */
        d0=(reserve0*_shares)/totalSupply;
        d1=(reserve1*_shares)/totalSupply;

        _burn(msg.sender, _shares);
        _update(reserve0-d0, reserve1-d1);
        if(d0>0)
        {
            token0.transfer(msg.sender, d0);
        }
        else
        {
            token1.transfer(msg.sender, d0);
        }
    }
}