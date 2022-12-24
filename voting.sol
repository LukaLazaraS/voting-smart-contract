// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Voting {
    mapping(address => Voter) voters;
    Voter[] votersArr;
    address private owner;

    struct Voter {
        string fullname;
        string identicalNumber;
        uint8 age;
    }

    modifier isOwner() {
        require(msg.sender == owner, "You must be the Owner");
        _;
    }

    modifier is18(uint8 _age) {
        require(_age > 17, "The minimum age for voting is 18");
        _;
    }

    modifier isZeroBalance() {
        require(
            msg.sender.balance > 100000000000000,
            "You must have more than 0.0001 ether"
        );
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function viewAllVoters() public view returns (uint, Voter[] memory) {
        return (votersArr.length, votersArr);
    }

    function registerAsVoter(
        string calldata _fullname,
        string calldata _identicalNumber,
        uint8 _age
    ) external is18(_age) isZeroBalance {
        voters[msg.sender] = Voter(_fullname, _identicalNumber, _age);
        votersArr.push(Voter(_fullname, _identicalNumber, _age));
    }

    fallback() external payable {}

    receive() external payable {}
}

contract Candidates {
    mapping(uint8 => Candidate) candidates;
    Candidate[] candidatesArr;
    uint8 maxCandidates = 10;
    address owner;

    struct Candidate {
        uint8 participantNumber;
        uint256 identicalNumber;
        string fullname;
        string slogan;
        uint256 votes;
    }

    modifier isOwner() {
        require(msg.sender == owner, "You must be the Owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addCandidate(
        uint8 _participantNumber,
        uint256 _identicalNumber,
        string calldata _fullname,
        string calldata _slogan
    ) external isOwner {
        candidates[_participantNumber] = Candidate(
            _participantNumber,
            _identicalNumber,
            _fullname,
            _slogan,
            0
        );
        candidatesArr.push(
            Candidate(
                _participantNumber,
                _identicalNumber,
                _fullname,
                _slogan,
                0
            )
        );
    }

    fallback() external payable {}

    receive() external payable {}
}
