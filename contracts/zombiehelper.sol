pragma solidity ^0.4.19;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

    // 1. Define levelUpFee here
    uint levelUpFee = 0.001 ether;

    // Start here
    modifier aboveLevel(uint _level, uint _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    // 1. Create withdraw function here
    function withdraw() external onlyOwner {
        owner.transfer(this.balance);
    }
    

    // 2. Create setLevelUpFee function here
    function setLevelUpFee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    // 2. Insert levelUp function here
    function levelUp(uint _zombieId) external payable {
        require(msg.value == levelUpFee);
        zombies[_zombieId].level++;
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
        // return a uint[] array with all the zombies a particular user owns
        uint[] memory result = new uint[](ownerZombieCount[_owner]);
        // iterate through zombies array and add match to results
        uint counter = 0;
        for (uint i = 0; i < zombies.length; i++){
            if (zombieToOwner[i] == _owner){
                result[counter] = i;
                counter++;
            }
        }
        return result;
    
    }
}