pragma solidity ^0.4.19;

// 1. Import here
import "./ownable.sol";
import "./safemath.sol";

// 2. Inherit here:
contract ZombieFactory is ownable {

    // 2. Declare using safemath here
    using SafeMath for uint256;
    // 1. Declare using SafeMath32 for uint32
    using SafeMath32 for uint32;
    // 2. Declare using SafeMath16 for uint16
    using SafeMath16 for uint16;

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    // 1. Define `cooldownTime` here
    uint cooldownTime = 1 days;

    struct Zombie {
        string name;
        uint dna;
        // Add new data here
        uint32 level;
        uint32 readyTime;
        // 1. Add new properties here
        uint16 winCount;
        uint16 lossCount;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    function _createZombie(string _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    }

}
