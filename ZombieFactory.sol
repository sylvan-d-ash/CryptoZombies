pragma solidity >=0.8.0 <0.9.0;

contract ZombieFactory {
    struct Zombie {
        string name;
        uint dna;
    }

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    Zombie[] public zombies;

    event NewZombie(uint zombieId, string name, uint dna);

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    function _createZombie(string memory _name, uint _dna) internal {
        Zombie memory _zombie = Zombie(_name, _dna);
        zombies.push(_zombie);
        uint id = zombies.length - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;

        // Emit the NewZombie event to notify that a new zombie has been created
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0, "You already have a zombie!");

        uint randDna = _generateRandomDna(_name);
        randDna = randDna - (randDna % 100); 
        _createZombie(_name, randDna);
    }
}
