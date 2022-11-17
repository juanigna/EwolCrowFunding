const {expect} = require("chai");
const {ethers} = require("hardhat");

let signers = {};

let ContractFactory;
let ContractInstance;
let paymentTokenFactory;
let PaymentTokenInstance;

describe("CrowFunding", function(){
    describe("Deploy", function(){
        it("Shoul deploy the smart contract", async function(){
            const [deployer, firstUser] = await ethers.getSigners();
            signers.deployer =deployer;
            signers.firstUser = firstUser;
            paymentTokenFactory = await ethers.getContractFactory("ERC20Basic");
            PaymentTokenInstance = await paymentTokenFactory.deploy();
            await PaymentTokenInstance.deployed();
            ContractFactory = await ethers.getContractFactory("CrowdFund");
            ContractInstance = await ContractFactory.deploy(PaymentTokenInstance.address);
            await ContractInstance.deployed();
        })
    })
    

    describe("Adding funds to an user", function(){
        it("Should allow to mint token to an user", async function(){
            let PaymentTokenInstanceSeconUser = await PaymentTokenInstance.connect(signers.firstUser);
            let mintTokenTx = await PaymentTokenInstanceSeconUser.mint(100);
            await mintTokenTx.wait();
        })
    })

    describe("Launch a campaign", function(){
        it("Should allow to launch a campaign", async function(){
            let firstUserInstance = await ContractInstance.connect(signers.deployer);
            let launchCampaignTx = await firstUserInstance.launch(10, 1668708888, 1668709999);
            await launchCampaignTx.wait();
        })
    })
})