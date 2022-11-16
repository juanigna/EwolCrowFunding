const {expect} = require("chai");
const {ethers} = require("hardhat");

let signers = {};

let ContractFactory;
let ContractInstance;


describe("CrowFunding", function(){
    describe("Deploy", function(){
        it("Shoul deploy the smart contract", async function(){
            const [deployer, firstUser] = await ethers.getSigners();
            ContractFactory = await ethers.getContractFactory("CrowdFund");
            ContractInstance = await ContractFactory.deploy()

        })
    })
})