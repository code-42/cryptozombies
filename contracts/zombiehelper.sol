pragma solidity ^0.4.19;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

    // Start here
    modifier aboveLevel(uint _level, uint _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    // zombies level 2 and higher, users can change their name
    function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) {
        // first make sure we own the zombie
        require(msg.sender == zombieToOwner[_zombieId]);
        // then we can give it a new name
        zombies[_zombieId].name = _newName;
    }

    // zombies level 20 and higher, users can give them custom DNA.
    function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
        // first make sure we own the zombie
        require(msg.sender == zombieToOwner[_zombieId]);
        // then we can give it new DNA
        zombies[_zombieId].dna = _newDna;
    }

    function getZombiesByOwner(address _owner) external view returns(uint[]){
    
    }
}