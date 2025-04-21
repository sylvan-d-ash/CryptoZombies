// SPDX-License-Identifier: MIT 
pragma solidity >=0.8.0 <0.9.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {
    modifier aboveLevel(uint _level, uint _zombieId) {
        require(zombies[_zombieId].level >= _level, "Zombie is not above the required level");
        _;
    }

    function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId], "You are not the owner of this zombie");
        zombies[_zombieId].name = _newName;
    }

    function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId], "You are not the owner of this zombie");
        zombies[_zombieId].dna = _newDna;
    }

    function getZombiesByOwner(address _owner) external view returns (uint[] memory) {
        uint[] memory result = new uint[](zombies.length);

        uint count = 0;
        for (uint i = 0; i < zombies.length; i++) {
            if (zombieToOwner[i] == _owner) {
                result[count] = i;
                count++;
            }
        }

        return result;
    }
}