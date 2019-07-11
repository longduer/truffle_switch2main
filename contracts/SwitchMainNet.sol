// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------
pragma solidity ^0.5.0;

import "./SafeMath.sol";

contract ERC20 {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract Controlled {
    modifier onlyController { if (msg.sender != controller) revert(); _; }

    address public controller;

    constructor() public { controller = msg.sender;}

    function changeController(address _newController) onlyController public {
        controller = _newController;
    }
}

contract SwitchMainNet is Controlled {

    using SafeMath for uint256;

    address tracker_0x_address; // ContractA Address

    mapping ( address => uint256 ) public balances;

    constructor(address _address) public { tracker_0x_address = _address;}

    function receiveApproval(address from, uint256 _amount, address _token, bytes memory _data) public {
        require(tracker_0x_address == _token);
        balances[from]=balances[from].add(_amount);
        ERC20(_token).transferFrom(from, address(this), _amount);
    }

    function returnTokens() public {
        require(ERC20(tracker_0x_address).balanceOf(address(this)).sub(balances[msg.sender])>=0);
        require(ERC20(tracker_0x_address).transfer(msg.sender, balances[msg.sender]));
        balances[msg.sender] = 0;
    }

    function transferAllTokens(address to) onlyController public {
        ERC20(tracker_0x_address).transfer(to, ERC20(tracker_0x_address).balanceOf(address(this)));
    }
}