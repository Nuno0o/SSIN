pragma solidity ^0.4.17;

contract Evote {
    address public owner;
    uint public last_completed_migration;


    struct Election{
        Option[] options;
        bool active;
        mapping(address => int) votes;
    }

    struct Option{
        string name;
    }
  

    modifier restricted() {
        if (msg.sender == owner) _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function setCompleted(uint completed) public restricted {
        last_completed_migration = completed;
    }

    function upgrade(address new_address) public restricted {
        Evote upgraded = Evote(new_address);
        upgraded.setCompleted(last_completed_migration);
    }
}
