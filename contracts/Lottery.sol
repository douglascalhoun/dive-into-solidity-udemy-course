//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.13;
import "hardhat/console.sol";

contract Lottery {
    address[] public players;
    address[] public gameWinners;
    address public owner;

    modifier onlyOwner(){
        require(msg.sender == owner, "ONLY_OWNER");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        require(msg.value == 0.1 ether, "WRONG_FEE");
        players.push(msg.sender);
    }

    function getBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    function pickWinner() public onlyOwner {
        require(players.length >= 3, "NOT_ENOUGH_PLAYERS");

        uint256 r = random();
        address payable winner;

        winner = payable(players[r % players.length]);
        gameWinners.push(winner);
        delete players;

        winner.call{value: address(this).balance}("");
    }

    // helper function that returns a big random integer
    // UNSAFE! Don't trust random numbers generated on-chain, they can be exploited! This method is used here for simplicity
    // See: https://solidity-by-example.org/hacks/randomness
    function random() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        players.length
                    )
                )
            );
    }
}
