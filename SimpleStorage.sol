// SPDX-License-Identifier: MIT
pragma solidity 0.8.7; 

contract SimpleStorage {
    // boolean, uint, int, address, bytes, and more

    uint256 public favoriteNumber; 

    mapping(string => uint256) public nameToAge;

    function store(uint256 _favoriteNumber) public virtual {
        favoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }

    function add() public pure returns (uint256) {
        return 1 + 1; 
    }


    People public person = People({age: 20, name: "Luke"});

    struct People {
        uint256 age;
        string name;
    }

    People[] public people; 

    function addPerson(string calldata _name, uint256 _age) public {
        people.push(People(_age, _name));
        nameToAge[_name] = _age;
    }

}