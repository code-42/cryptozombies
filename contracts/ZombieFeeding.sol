pragma solidity ^0.4.19

import "./zombiefactory.sol";

contract ZombieFeeding is ZombieFactory {

    function feedAndMultiply(uint _zombieId, uint _targetDna) public {

        // make sure we own this zombie
        require(msg.sender == zombieToOwner[_zombieId]);

        // myZombie is a storage pointer to the _zombieId passed in
        Zombie storage myZombie = zombies[_zombieId];

    }
    
}