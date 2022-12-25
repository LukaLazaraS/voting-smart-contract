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

    modifier isVoterNew(address _address) {
        require(
            voters[_address].age == 0,
            "You have already registered as a voter"
        );
        _;
    }

    constructor() {}

    function viewAllVoters() public view returns (uint, Voter[] memory) {
        return (votersArr.length, votersArr);
    }

    function registerAsVoter(
        string calldata _fullname,
        string calldata _identicalNumber,
        uint8 _age
    ) external isVoterNew(msg.sender) is18(_age) isZeroBalance {
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
    bool votingStatus;

    struct Candidate {
        uint8 participantNumber;
        uint256 identicalNumber;
        string fullname;
        string slogan;
        uint256 votes;
    }

    event ChangeVotingStatus(bool votingStatus);

    modifier checkMaxCandidates() {
        require(candidatesArr.length < maxCandidates, "Too many candidates");
        _;
    }

    modifier isOwner() {
        require(msg.sender == owner, "You must be the Owner");
        _;
    }

    modifier isVotingTrue() {
        require(votingStatus, "Voting is already off");
        _;
    }

    modifier isVotingFalse() {
        require(!votingStatus, "Voting is already on");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function showAllCanidates() public view returns (uint, Candidate[] memory) {
        return (candidatesArr.length, candidatesArr);
    }

    function checkVotingProcess() public view returns (bool) {
        return votingStatus;
    }

    function startVotingProcess() external isOwner isVotingFalse {
        votingStatus = true;
        emit ChangeVotingStatus(votingStatus);
    }

    function stopVotingProcess() external isOwner isVotingTrue {
        votingStatus = false;
        emit ChangeVotingStatus(votingStatus);
    }

    function addCandidate(
        uint8 _participantNumber,
        uint256 _identicalNumber,
        string calldata _fullname,
        string calldata _slogan
    ) external isOwner checkMaxCandidates {
        candidatesArr.push(
            Candidate(
                _participantNumber,
                _identicalNumber,
                _fullname,
                _slogan,
                0
            )
        );
        candidates[_participantNumber] = Candidate(
            _participantNumber,
            _identicalNumber,
            _fullname,
            _slogan,
            0
        );
    }

    function deleteCandidate(uint8 index) external isOwner {
        for (uint i = index; i < candidatesArr.length - 1; i++) {
            candidatesArr[i] = candidatesArr[i + 1];
        }
        candidatesArr.pop();
    }

    fallback() external payable {}

    receive() external payable {}
}
