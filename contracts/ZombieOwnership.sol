pragma solidity ^0.4.19;

import "./ZombieAttack.sol";
import "./erc721.sol";

// multiple inheritance
contract ZombieOwnership is ZombieAttack, ERC721 {
    
}