// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.11;

import "ds-test/test.sol";
import "../AvsBGame.sol";
import "../IAvsBGame.sol";
import "./Hevm.sol";

contract User {}
contract ContractTest is DSTest {
    
    
    
    User internal user;
    Hevm internal hevm;
    address _target;

    function setUp() public {
        hevm = Hevm(HEVM_ADDRESS);
        user = new User();
        _target = address(new AvsBGame());
        bytes32 data = keccak256(abi.encodePacked(address(this), IAvsBGame.Choice.A, bytes32("0")));
        emit log_uint(address(this).balance);
        
        // hevm.startPrank(address(user));
        // IAvsBGame(_target).castHiddenVote{value: 5e15 * 100}(data);
        // hevm.stopPrank();
        
        IAvsBGame(_target).castHiddenVote{value: 5e15}(data);
        emit log_uint(address(this).balance);
        hevm.warp(1643702400);
        IAvsBGame(_target).reveal(IAvsBGame.Choice.A, bytes32("0"));
        hevm.warp(1644912000 + 1);
    }

    function testExample() public {
        emit log_address(address(this));
        emit log_uint(address(this).balance);
        IAvsBGame(_target).claimPayout();
        emit log_uint(address(this).balance);
        IAvsBGame(_target).claimPayout();
        emit log_uint(address(this).balance);
    }
    receive() payable external {

    }
}
