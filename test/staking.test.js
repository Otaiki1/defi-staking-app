const { ethers, deployments } = require("hardhat");

describe('Staking Test', async() => {
    let staking, rewardToken, deployer, stakeAmount;

    beforeEach(async() => {
        const accounts = await ethers.getSigners();
        deployer = accounts[0];
        await deployments.fixture(["all"]);

        staking = await ethers.getContract("Staking");
        rewardToken = await ethers.getContract("RewardToken");

        stakeAmount = ethers.utils.parseEther("100000")

    })


});
