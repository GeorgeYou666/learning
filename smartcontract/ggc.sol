pragma solidity ^0.5.0;

contract GGC_ERC20 {
    
    struct Account {
        uint256 amount;
        bool disabled;
    }
    
    // 地址对应账户信息
    mapping(address => Account) accounts;
    
    mapping(address => mapping(address => uint256)) aprov;
    
    // 返回ERC20代币的名字，例如”My test token”。
    function name() public pure returns (string memory) {
        return "George Coin"; 
    }
      
    // 返回代币的简称，例如：MTT，这个也是我们一般在代币交易所看到的名字。
    function symbol() public pure returns (string memory) {
        return "GGC";
    }
      
    // 返回token使用的小数点后几位。比如如果设置为3，就是支持0.001表示。
    function decimals() public pure returns (uint8 decimal) {
        return 18;
    }
      
    // 返回token的总供应量
    function totalSupply() public pure returns (uint total) {
        return 10000000000;
    }
      
    // 返回某个地址(账户)的账户余额
    function balanceOf(address _owner) public view returns (uint balance) {
        return accounts[_owner].amount;
    }
      
    // 从代币合约的调用者地址上转移_value的数量token到的地址_to，并且必须触发Transfer事件。
    function transfer(address _to, uint _value) public returns (bool success) {
        require(accounts[msg.sender].amount >= _value);
        accounts[msg.sender].amount -= _value;
        accounts[_to].amount += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
      
    // 从地址_from发送数量为_value的token到地址_to,必须触发Transfer事件。
    // transferFrom方法用于允许合同代理某人转移token。条件是from账户必须经过了approve。
    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
        require(accounts[_from].amount >= _value);
        accounts[_from].amount -= _value;
        accounts[_to].amount += _value;
        aprov[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
      
    // 允许_spender多次取回您的帐户，最高达_value金额。 如果再次调用此函数，它将以_value覆盖当前的余量。
    function approve(address _spender, uint _value) public returns (bool success) {
        aprov[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
      
    // 返回_spender仍然被允许从_owner提取的金额。
    function allowance(address _owner, address _spender) public view returns (uint remaining) {
        return aprov[_owner][_spender];
    }
      
    // 从一个地址转移到另一个地址的token转移的细节
    event Transfer(address indexed _from, address indexed _to, uint _value);
    // 从一个地址许可转移token到另一个地址的细节
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}
