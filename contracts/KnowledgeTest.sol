//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract KnowledgeTest {
    string[] public tokens = ["BTC", "ETH"];
    address[] public players;
    address public owner;

    modifier onlyOwner(){
        require(msg.sender == owner, "ONLY_OWNER");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function changeTokens() public {
        tokens[0] = "VET";
    }

    function concatenate(string calldata a, string calldata b) public pure returns (string memory) {
        return string.concat(a, b);
    }

    function getBalance() public view returns (uint){
        return address(this).balance;
    }

    function transferAll(address to) public onlyOwner {
        to.call{value: address(this).balance}("");
    }

    function start() public {
        players.push(msg.sender);
    }

    receive() external payable {

    }
}
