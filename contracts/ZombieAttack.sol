pragma solidity ^0.4.19;

import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {
    // Start here
    uint randNonce = 0;
    // Create attackVictoryProbability here
    uint attackVictoryProbability = 70;

    function randMod(uint _modulus) internal returns(uint){
        // use SafeMath's `add` here:
        randNonce = randNonce.add(1);
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
            // use SafeMath's `add` here:
            myZombie.winCount = myZombie.winCount.add(1);
            myZombie.level = myZombie.level.add(1);
            enemyZombie.lossCount = enemyZombie.lossCount.add(1);
            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        } else {
            myZombie.lossCount = myZombie.lossCount.add(1);
            enemyZombie.winCount = enemyZombie.winCount.add(1);
            _triggerCooldown(myZombie);
        }
    }
}