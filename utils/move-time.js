const { network } = require("hardhat");

async function moveBlocks(amount){
    console.log("...Moving Time ...");
    await network.provider.send("evm_increaseTime", [amount]);
    console.log(`...Moved ${amount} Blocks`);
}

module.exports = {
    moveTime,
}