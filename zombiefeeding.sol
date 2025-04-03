pragma solidity >=0.8.0 <0.9.0;

import "./zombiefactory.sol";

abstract contract KittyInterface {
    function getKitty(uint _id) external view virtual returns (
        bool isGestating,
        bool isReady,
        uint cooldownIndex,
        uint nextActionAt,
        uint siringWithId,
        uint birthTime,
        uint matronId,
        uint sireId,
        uint generation,
        uint genes
    );
}

contract ZombieFeeding is ZombieFactory {
    // CryptoKitties address
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    // CryptoKitties contract
    KittyInterface kittyContract = KittyInterface(ckAddress);

    function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
        require(msg.sender == zombieToOwner[_zombieId], "You are not the owner of this zombie");

        Zombie storage myZombie = zombies[_zombieId];
        _targetDna = _targetDna % dnaModulus;

        // Combine the DNA of the two zombies
        uint newDna = (myZombie.dna + _targetDna) / 2;

        // Add '99' to the new DNA to ensure it's from a kitty
        if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
            newDna = newDna - (newDna % 100) + 99;
        }

        // Create a new zombie with the combined DNA
        _createZombie("NoName", newDna);
    }
}