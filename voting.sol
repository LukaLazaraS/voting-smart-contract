// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Voting {
    struct Voter {
        address addr;
        string fullname;
        uint256 identicalNumber;
    }

    mapping(address => Voter) voters;
}

contract Candidates {
    struct Candidate {
        uint8 participantNumber;
        address addr;
        string fullname;
        uint256 identicalNumber;
    }

    mapping(address => Candidate) candidates;
}
