pragma solidity ^0.4.0;
contract Ballot {
    struct Voter {
        bool canVote;
        bool voted;
    }
    struct Proposal {
        uint voteCount;
    }
    address chairperson;
    mapping(address => Voter) voters;
    Proposal[] proposals;

    /// Create a new ballot with $(_numProposals) different proposals.
    constructor(uint8 _numProposals) public {
        chairperson = msg.sender;
        voters[chairperson].canVote = true;
        proposals.length = _numProposals;
    }
    /// Get address of chairperson(creator of the ballot)
    function getChairperson() public constant returns (address) {
        return chairperson;
    }
    /// Get if user has right to vote
    function getRightToVote() public constant returns (bool) {
      return voters[msg.sender].canVote && !voters[msg.sender].voted;
    }
    /// Get number of proposals
    function getNProposals() public constant returns (uint) {
        return proposals.length;
    }
    /// Get number of votes on certain proposal
    function getNVotes(uint8 index) public constant returns (uint) {
        if(index >= proposals.length || msg.sender != chairperson) return 0;
        return proposals[index].voteCount;
    }

    /// Give $(toVoter) the right to vote on this ballot.
    /// May only be called by $(chairperson).
    function giveRightToVote(address toVoter) public returns (bool) {
        if (msg.sender != chairperson || voters[toVoter].voted) return false;
        voters[toVoter].canVote = true;
        return true;
    }

    /// Give a single vote to proposal $(toProposal).
    function vote(uint8 toProposal) public returns (bool) {
        Voter storage sender = voters[msg.sender];
        if (sender.voted || toProposal >= proposals.length) return false;
        sender.voted = true;
        proposals[toProposal].voteCount += 1;
        return true;
    }
    /// Get winning proposal
    function winningProposal() public constant returns (uint8 _winningProposal) {
        uint256 winningVoteCount = 0;
        for (uint8 prop = 0; prop < proposals.length; prop++)
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop;
            }
    }
}
