pragma solidity ^0.4.17;

contract Ballot {
    address public owner;
    // Election started
    bool public started = false;
    // Election ended
    bool public ended = false;
    // Votes
    address[] public voters;
    // Options to vote in
    string[] public options;
    // Votes
    mapping(address => uint) private votes;
    mapping(uint => uint) private nvotes;
    // Only owner
    modifier restricted() {
        require(msg.sender == owner);
        _;
    }
    modifier electionOngoing() {
        require(started,"Voting hasn't started yet");
        require(!ended,"Voting has ended");
        _;
    }
    modifier electionEnded() {
        require(ended,"Election hasn't ended yet");
        _;
    }
    // Already voted
    function alreadyVoted(address _a) public view returns(bool){
        bool voted = false;
        for(uint i = 0; i < voters.length && !voted; i++){
            voted = voters[i] == _a;
        }
        return voted;
    }
    // Option exists
    function optionExists(uint _op) public view returns(bool) {
        return _op >= 0 && _op < options.length;
    }
    // Constructor
    constructor() public {
        owner = msg.sender;
    }
    // Destroy contract
    function kill() public {
        if(msg.sender == owner) selfdestruct(owner);
    }
    // Start election
    function startVote() public restricted {
        started = true;
    }
    // End election
    function endVote() public restricted {
        ended = true;
    }
    // Add option
    function addOption(string name) public {
        options.push(name);
        nvotes[options.length-1] = 0;
    }
    // Cast vote
    function castVote(uint _option) public electionOngoing {
        require(!alreadyVoted(msg.sender),"You have already voted.");
        require(optionExists(_option),"Option doesn't exist");
        voters.push(msg.sender);
        votes[msg.sender] = _option;
        nvotes[_option] += 1; 
    }
    // Get winner
    function getWinner() public view electionEnded returns(string){
        uint max = 0;
        for(uint i = 0; i < options.length; i++){
            if(nvotes[i] >= max){
                max = i;
            }
        }
        return options[max];
    }
}
