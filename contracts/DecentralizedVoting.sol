// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract DecentralizedVoting {
    address public owner;
    mapping(address => bool) public hasVoted;
    mapping(string => uint256) public votes;
    string[] public candidates;
    uint256 public votingEndTime;
    
    // Event to log vote casting
    event Voted(address indexed voter, string candidate);
    event VotingEnded(string winner);

    // Modifier to ensure only the owner can call certain functions
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    // Modifier to ensure voting is still ongoing
    modifier onlyDuringVoting() {
        require(block.timestamp < votingEndTime, "Voting period has ended");
        _;
    }

    // Constructor to initialize the contract
    constructor(string[] memory _candidates, uint256 _durationInMinutes) {
        owner = msg.sender;
        candidates = _candidates;
        votingEndTime = block.timestamp + _durationInMinutes * 1 minutes;
    }

    // Function to vote for a candidate
    function vote(string memory candidate) public onlyDuringVoting {
        require(!hasVoted[msg.sender], "You have already voted");
        require(isValidCandidate(candidate), "Invalid candidate");

        votes[candidate]++;
        hasVoted[msg.sender] = true;

        emit Voted(msg.sender, candidate);
    }

    // Function to check if a candidate is valid
    function isValidCandidate(string memory candidate) internal view returns (bool) {
        for (uint256 i = 0; i < candidates.length; i++) {
            if (keccak256(abi.encodePacked(candidates[i])) == keccak256(abi.encodePacked(candidate))) {
                return true;
            }
        }
        return false;
    }

    // Function to get the current vote count of a candidate
    function getVoteCount(string memory candidate) public view returns (uint256) {
        return votes[candidate];
    }

    // Function to end the voting and declare the winner
    function endVoting() public {
        require(block.timestamp >= votingEndTime, "Voting period not yet ended");
        
        string memory winner;
        uint256 highestVotes = 0;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (votes[candidates[i]] > highestVotes) {
                highestVotes = votes[candidates[i]];
                winner = candidates[i];
            }
        }

        emit VotingEnded(winner);
    }

    // Function to get all candidates
    function getCandidates() public view returns (string[] memory) {
        return candidates;
    }

    // ✅ New Function: Check if a user has voted
    function hasUserVoted(address user) public view returns (bool) {
        return hasVoted[user];
    }
}
