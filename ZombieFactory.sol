pragma solidity >=0.8.0 <0.9.0;

contract ZombieFactory {
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    Zombie[] public zombies;
    event NewZombie(uint zombieId, string name, uint dna);

    struct Zombie {
        string name;
        uint dna;
    }

    function _createZombie(string memory _name, uint _dna) private {
        Zombie memory _zombie = Zombie(_name, _dna);
        zombies.push(_zombie);
        uint id = zombies.length - 1;
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
