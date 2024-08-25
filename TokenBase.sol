// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "./Interface.sol";

abstract contract TokenBase is BluePrint{


    uint256 private totalSupply;
    string private name;
    string private symbol;
    uint private decimal; 
    mapping (address => uint256) private _balance;
    mapping (address => mapping(address => uint256)) private allowances;

    constructor(string memory _name, string memory _symbol){
        name = _name;
        symbol = _symbol;
        decimal = 18;
    }


    function getName() public view virtual returns (string memory){
        return name;
    }
    function getSymbol() public view virtual returns (string memory){
        return symbol;
    }
    function getTotalSupply() virtual override public view returns(uint256){
        return totalSupply;
    }
    function balanceOf(address account) virtual override public view returns(uint256){
        return _balance[account];
    }
    function transfer(address _recipent, uint256 amount) public virtual override returns (bool){
        _transfer(msg.sender, _recipent, amount);
        return true;
    }
    function approve(address spender,uint256 amount) public virtual override returns (bool){
        _approve(msg.sender, spender, amount);
        return true;
    }
    
    function transferFrom(address sender,address recipent, uint256 amount) public virtual override returns(bool){
        
        uint256 currentAllowance = allowances[sender][msg.sender];
        require (currentAllowance >= amount, "TokenBase: Transfer amount exceeded allowance");
        _transfer(sender, recipent, amount); 
        unchecked{
            _approve(sender, msg.sender, currentAllowance-amount);
        }
        return true;
    }
    function allowance(address owner, address spender) public view virtual override  returns (uint256){
        return allowances[owner][spender];
    }

    // intenal function
    function _transfer(address sender, address recipent, uint256 amount) internal virtual{

        require(sender != address(0), "TokenBase: Transfer from the zero address");
        require(recipent != address(0), "TokenBase: Transfer to the zero address");
        uint256 senderBalance = _balance[sender];
        require(senderBalance >= amount, "TokenBase: Transfer amount exceeded");

        unchecked{//wont look for underflow and overflow
            _balance[sender] = senderBalance - amount; 
        }
        _balance[recipent] += amount;

        emit Transfer(sender, recipent, amount);
    }
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "TokenBase: Approve from the zero address");
        require(spender != address(0), "TokenBase: approve to the zero address");

        allowances[owner][spender] = amount;

    }
    function _mint(address account, uint256 amount) internal virtual{

        require(account != address(0), "TokenBase: mint to zero address");

        totalSupply += amount;
        _balance[account] += amount;
    }
    function _burn(address account, uint256 amount) internal virtual{

        require(account != address(0), "TokenBase: burn from zero address");

        uint256 accountBalance = _balance[account];
        require(accountBalance >= amount, "TokenBase: burn amount exceeded");

        unchecked{
            _balance[account] -= amount;
        }
        totalSupply -= amount;
    }

}