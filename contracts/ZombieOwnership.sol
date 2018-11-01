pragma solidity ^0.4.19;

import "./zombieattack.sol";
import "./erc721.sol";

/// @title A contract that manages transfering zombie ownership
/// @author code-42 
/// @dev Compliant with OpenZeppelin's implementation of the ERC721 spec draft

contract ZombieOwnership is ZombieAttack, ERC721 {

    // 1. Define mapping here
    mapping (uint => address) zombieApprovals;

    function balanceOf(address _owner) public view returns (uint256 _balance) {
        // 1. Return the number of zombies `_owner` has here
        return ownerZombieCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address _owner) {
        // 2. Return the owner of `_tokenId` here
        return zombieToOwner[_tokenId];
    }

    // Define _transfer() here
    function _transfer(address _from, address _to, uint256 _tokenId) private {
        // ownerZombieCount[_to]++;
        // 1. Replace with SafeMath's `add`
        ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
        // ownerZombieCount[_from]--;
        // 2. Replace with SafeMath's `sub`
        ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
        zombieToOwner[_tokenId] = _to;
        Transfer(_from, _to, _tokenId);
    }

    function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        _transfer(msg.sender, _to, _tokenId);
    }

    // 2. Add function modifier here
    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        // 3. Define function here
        zombieApprovals[_tokenId] = _to;
        Approval(msg.sender, _to, _tokenId);
    }

    function takeOwnership(uint256 _tokenId) public {
        require(zombieApprovals[_tokenId] == msg.sender);
        address owner = ownerOf(_tokenId);
        _transfer(owner, msg.sender, _tokenId);
    }
}
