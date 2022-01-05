# Forge and EVM cheatcodes in action

## Instructions
After installing Forge and cloning this repo, run:
```
forge test --verbosity 4
```

## A vs B Game Vulnerability
`claimPayout` does not check if a user has already claimed. Thus, when the reveal deadline has passed, an attacker on the winning side can drain the contract. The proof-of-concept forces the attacker to win by using EVM cheatcodes, but realistically an attacker could vote for both options from separate accounts and guarantee the attack (unless there's a tie). In the example, all users should be able to claim their funds since no one voted for B, but the attacker claims all of the funds for themselves.

