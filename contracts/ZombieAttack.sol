pragma solidity ^0.4.19;

import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {
    // Start here
    uint randNonce = 0;
    // Create attackVictoryProbability here
    uint attackVictoryProbability = 70;

    function randMod(uint _modulus) internal returns(uint){
        randNonce++;
        return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
    }

    // Create new function here
    // 1. Add modifier here
    function attack(uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId) {
        // 2. Start function definition here
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage enemyZombie = zombies[_targetId];
        uint rand = randMod(100);

        // update winCount and lossCount
        if(rand <= attackVictoryProbability){
            myZombie.winCount++;
            myZombie.level++;
            enemyZombie.lossCount++;
            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        } else {
            myZombie.lossCount++;
            enemyZombie.winCount++;
            _triggerCooldown(myZombie);
        }
    }
}