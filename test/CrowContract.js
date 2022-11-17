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
            ContractFactory = await ethers.getContractFactory("CrowdFund");
            ContractInstance = await ContractFactory.deploy(PaymentTokenInstance.address);
        })
    })
    

    describe("Adding funds to an user", function(){
        it("Should allow to mint token to an user", async function(){
            let PaymentTokenInstanceSeconUser = await PaymentTokenInstance.connect(signers.firstUser);
            let mintTokenTx = await PaymentTokenInstanceSeconUser.mint(100);
            await mintTokenTx.wait();
        })
    })
})