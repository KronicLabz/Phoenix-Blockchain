// SPDX-License-Identifier: MIT
// File: lotto.sol


pragma solidity ^0.8.11;

/***************************
 *     The Phire Ball      *
 *  Community prize lotto  *
 *     By: KronicLabz      *
 **************************/

contract PhireBall {
    address public owner;
    address payable[] public players;
    uint public PhireBallId;
    mapping (uint => address payable) public PhireBallHistory;

    constructor() {
        owner = msg.sender;
        PhireBallId = 1;
    }

    function getWinnerByPhireBall(uint phireBall) public view returns (address payable) {
        return PhireBallHistory[phireBall];
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    function enter() public payable {
        require(msg.value > 25 ether);

        // address of player entering PhireBall
        players.push(payable(msg.sender));
    }

    function getRandomNumber() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    function pickWinner() public onlyowner {
        uint index = getRandomNumber() % players.length;
        players[index].transfer(address(this).balance);

        PhireBallHistory[PhireBallId] = players[index];
        PhireBallId++;
        

        // reset the state of the contract
        players = new address payable[](0);
    }

    modifier onlyowner() {
      require(msg.sender == owner);
      _;
    }
}
