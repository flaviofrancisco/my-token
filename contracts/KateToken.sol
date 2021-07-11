// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract owned {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}

contract KateToken is owned {
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals = 18;

    mapping(address => uint256) private _balanceOf;
    mapping(address => mapping(address => uint256)) allowence;

    event Burn(address indexed from, uint256 value);
    event Transfer(address indexed _from, address indexed _to, uint256 tokens);
    event Approval(
        address indexed _tokenOwner,
        address indexed _spender,
        uint256 tokens
    );

    function getName() public view returns (string memory) {
        return _name;
    }

    function getSymbol() public view returns (string memory) {
        return _symbol;
    }

    function getTotalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function getOwnerBalance() public view returns (uint256) {
        return _balanceOf[owner];
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function balanceOf(address wallet) public view returns (uint256) {
        return _balanceOf[wallet];
    }

    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        uint256 initialSupply
    ) public {
        _totalSupply = initialSupply * 10**uint256(_decimals);        
        _symbol = tokenSymbol;
        _name = tokenName;
        _mintToken(owner, _totalSupply);
    }

    function _transfer(
        address _from,
        address _to,
        uint256 _value
    ) internal {
        require(_to != address(0));
        require(_balanceOf[_from] >= _value);
        require(_balanceOf[_to] + _value >= _balanceOf[_to]);
        _balanceOf[_from] -= _value;
        _balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
    }

    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(_value <= allowence[_from][msg.sender]);
        allowence[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value)
        public
        returns (bool success)
    {
        allowence[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function _mintToken(address _target, uint256 _mintedAmount)
        internal
        onlyOwner
    {
        _balanceOf[_target] += _mintedAmount;
        _totalSupply += _mintedAmount;
        emit Transfer(address(0), owner, _mintedAmount);
        emit Transfer(owner, _target, _mintedAmount);
    }

    function _burn(uint256 _value) internal onlyOwner returns (bool success) {
        require(_balanceOf[msg.sender] >= _value);
        _balanceOf[msg.sender] -= _value;
        _totalSupply -= _value;
        emit Burn(msg.sender, _value);
        return true;
    }
}
