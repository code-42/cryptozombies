pragma solidity ^0.4.19

import "./ZombieFactory.sol";

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

    // 1. Create modifier here
    modifier onlyOwnerOf(uint _zombieId){
        require(msg.sender == zombieToOwner[_zombieId]);
        _;
    }

    // add setKittyContractAddress method
    function setKittyContractAddress(address _address) external onlyOwner {
        kittyContract = KittyInterface(_address);
    }

    // 1. Define `_triggerCooldown` function here
    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(now + cooldownTime);
    }

    // 2. Define `_isReady` function here
    function _isReady(Zombie storage _zombie) internal view returns (bool) {
        return (_zombie.readyTime <= now);
    }


    function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) internal onlyOwnerOf(_zombieId) {

        // make sure we own this zombie
        // add modifier onlyOwnerOf() to function definition so remove this require line
        // require(msg.sender == zombieToOwner[_zombieId]);

        // myZombie is a storage pointer to the _zombieId passed in
        Zombie storage myZombie = zombies[_zombieId];

        // 2. Add a check for `_isReady` here
        require(_isReady(myZombie));

        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) /2;

        // Add an if statement here
        // for strings compare their keccak256 hashes
        // to check equality
        if (keccak256(_species) == keccak256("kitty")) {
            newDna = newDna - newDna % 100 + 99;
        }

        _createZombie("NoName", newDna);

        // 3. Call `triggerCooldown`
        _triggerCooldown(myZombie);

    }

    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        // add third parameter and call function if _species == kitty
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
    
}