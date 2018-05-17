abi = [{
    "constant": false,
    "inputs": [{
        "name": "nOptions",
        "type": "uint8"
      },
      {
        "name": "publicKey",
        "type": "string"
      }
    ],
    "name": "createBallot",
    "outputs": [{
      "name": "ballotAddress",
      "type": "address"
    }],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "constructor"
  }
]

abi2 = [{
    "constant": true,
    "inputs": [],
    "name": "getEnded",
    "outputs": [{
      "name": "",
      "type": "bool"
    }],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "getNChoices",
    "outputs": [{
      "name": "",
      "type": "uint256"
    }],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [{
      "name": "user",
      "type": "address"
    }],
    "name": "givePermission",
    "outputs": [{
      "name": "",
      "type": "bool"
    }],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "getRightToVote",
    "outputs": [{
      "name": "",
      "type": "bool"
    }],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "getChairperson",
    "outputs": [{
      "name": "",
      "type": "address"
    }],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "getKey",
    "outputs": [{
      "name": "",
      "type": "string"
    }],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [{
      "name": "addr",
      "type": "address"
    }],
    "name": "getVote",
    "outputs": [{
      "name": "",
      "type": "string"
    }],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [{
      "name": "choice",
      "type": "string"
    }],
    "name": "castVote",
    "outputs": [{
      "name": "",
      "type": "bool"
    }],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [],
    "name": "endVoting",
    "outputs": [{
      "name": "",
      "type": "bool"
    }],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "getVoters",
    "outputs": [{
      "name": "",
      "type": "address[]"
    }],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [{
        "name": "_owner",
        "type": "address"
      },
      {
        "name": "_numProposals",
        "type": "uint8"
      },
      {
        "name": "_publicKey",
        "type": "string"
      }
    ],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "constructor"
  }
]


creator = "0x903e511692f765212e8480e8f60ab8e1d4cfe8c9"

module.exports = {
  abi: abi,
  abi2: abi2,
  creator: creator
}
