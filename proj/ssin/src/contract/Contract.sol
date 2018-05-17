pragma solidity ^0.4.0;

contract PollCreator {
    // List of ongoing polls
    Poll[] polls;
    constructor () public {
    }
    function createPoll(uint8 nOptions, string publicKey) public returns (Poll pollAddress){
        Poll p = new Poll(msg.sender, nOptions, publicKey);
        polls.push(p);
        return p;
    }
    function listOfPolls() public constant returns (Poll[]){
        return polls;
    }
}

contract Poll {
    struct Voter {
        bool canVote;
        string vote;
    }
    //Owner of the poll
    address chairperson;
    //Id of block before creation
    uint block_number;
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
    /*-------------CONSTRUCTOR----------*/
    /// Create a new poll with $(_numProposals) different proposals, public encryption key and chairperson
    constructor(address _owner, uint8 _numProposals, string _publicKey) public {
        chairperson = _owner;
        n_choices = _numProposals;
        public_key = _publicKey;
        voters[chairperson].canVote = true;
        ended = false;
        block_number = block.number;
    }
    
    /*--------------GETTERS---------------*/
    
    /// Get address of chairperson(creator of the poll)
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
    /// Get public encryption key
    function getKey() public constant returns (string) {
        return public_key;
    }
    /// Get if vote ended
    function getEnded() public constant returns (bool) {
        return ended;
    }
    /// Get list of voters
    function getVoters() public constant returns (address[]){
        return voted;
    }
    /// Get vote of voter
    function getVote(address addr) public constant returns(string){
        return voters[addr].vote;
    }
    
    /*--------------TRANSACTIONS---------------*/
    
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
        if(voters[msg.sender].canVote != true || ended) return false;
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
}
