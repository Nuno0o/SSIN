pragma solidity ^0.4.0;

contract BallotCreator {
    constructor () public {
    }
    function createBallot(uint8 nOptions, string publicKey) public returns (Ballot ballotAddress){
        return new Ballot(msg.sender, nOptions, publicKey);
    }
}

contract Ballot {
    struct Voter {
        bool canVote;
        string vote;
    }
    //Owner of the ballot
    address chairperson;
    //Map of addresses to voter
    mapping(address => Voter) voters;
    //List of addresses that voted
    address[] voted;
    //Public key to use to encrypt votes
    string public_key;
    //Number of choices to vote(can't be controlled as the data is encrypted, but is used when verifying)
    uint n_choices;
    //Voting ended
    bool ended;
    /// Create a new ballot with $(_numProposals) different proposals, public encryption key and chairperson
    constructor(address _owner, uint8 _numProposals, string _publicKey) public {
        chairperson = _owner;
        n_choices = _numProposals;
        public_key = _publicKey;
        voters[chairperson].canVote = true;
        ended = false;
    }
    /// Get address of chairperson(creator of the ballot)
    function getChairperson() public constant returns (address) {
        return chairperson;
    }
    /// Get if user has right to vote
    function getRightToVote() public constant returns (bool) {
      return voters[msg.sender].canVote;
    }
    /// Get number of proposals
    function getNChoices() public constant returns (uint) {
        return n_choices;
    }
    /// Get list of votes
    function getVotes() public constant returns (address[]) {
        return voted;
    }
    /// Get public encryption key
    function getKey() public constant returns (string) {
        return public_key;
    }
    /// Get if vote ended
    function getEnded() public constant returns (bool) {
        return ended;
    }
    /// End election
    function endVoting() public returns (bool) {
        ended = true;
        return true;
    }
    /// Give permission to vote, can only be called by chairperson
    function givePermission(address user) public returns (bool){
        if(msg.sender != chairperson) return false;
        voters[user].canVote = true;
        return true;
    }

    /// Vote
    function castVote(string vote) public returns (bool){
        if(voters[msg.sender].canVote != true) return false;
        voters[msg.sender].vote = vote;
        bool alreadyVotedBefore = false;
        for(uint i = 0; i < voted.length; i++){
            if(voted[i] == msg.sender){
                alreadyVotedBefore = true;
                break;
            }
        }
        if(!alreadyVotedBefore){
            voted.push(msg.sender);
        }
        return true;
    }
    /*/// Get winning proposal
    function winningProposal() public constant returns (uint8 _winningProposal) {
        uint256 winningVoteCount = 0;
        for (uint8 prop = 0; prop < proposals.length; prop++)
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop;
            }
    }*/
}
