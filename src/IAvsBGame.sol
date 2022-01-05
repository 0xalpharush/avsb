pragma solidity ^0.8.11;

interface IAvsBGame {
    enum Choice {
        Hidden,
        A,
        B
    }
    function castHiddenVote(bytes32 commitment) external payable;
    function reveal(Choice choice, bytes32 blindingFactor) external;
    function claimPayout() external;
}