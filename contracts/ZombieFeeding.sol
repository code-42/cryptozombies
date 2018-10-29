pragma solidity ^0.4.19

import "./zombiefactory.sol";

contract KittyInterface {
        function getKitty(uint256 _id) external view returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    );
}

contract ZombieFeeding is ZombieFactory {

    // remove assigment and declare local variable
    KittyInterface kittyContract;

    // add setKittyContractAddress method
    function setKittyContractAddress(address _address) external{
        kittyContract = KittyInterface(_address);
    }


    function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) public {

        // make sure we own this zombie
        require(msg.sender == zombieToOwner[_zombieId]);

        // myZombie is a storage pointer to the _zombieId passed in
        Zombie storage myZombie = zombies[_zombieId];

        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) /2;

        // Add an if statement here
        // for strings compare their keccak256 hashes
        // to check equality
        if (keccak256(_species) == keccak256("kitty")) {
            newDna = newDna - newDna % 100 + 99;
        }

        _createZombie("NoName", newDna);

    }

    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        // add third parameter and call function if _species == kitty
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
    
}