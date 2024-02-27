import hre, { viem } from "hardhat";
import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { parseEther, serializeTransaction } from "viem";

describe("Tama Gas Check", () => {
    async function deployContractFixture() {
        const tama = await hre.viem.deployContract("contracts/Tama.sol:Tama");

        const character0 = await hre.viem.deployContract("Character0");
        const character1 = await hre.viem.deployContract("Character1");
        const character2 = await hre.viem.deployContract("Character2");
        const character3 = await hre.viem.deployContract("Character3");

        await tama.write.setCharacters([
            character0.address,
            character1.address,
            character2.address,
            character3.address,
        ]);
        await tama.write.setMaxMint([10n]);
        await tama.write.setPlayTime([0n]);
        const value = parseEther("0.01");
        await tama.write.purchase([1n], { value });
        return { tama };
    }
    it("Should fill SVG contracts", async function () {
        const { tama } = await loadFixture(deployContractFixture);

        const char0 = await tama.read.tama0();
        console.log("Tama 0: " + char0);
        const char1 = await tama.read.tama1();
        console.log("Tama 1: " + char1);
        const char2 = await tama.read.tama2();
        console.log("Tama 2: " + char2);
        const char3 = await tama.read.tama3();
        console.log("Tama 3: " + char3);
        expect(char0 && char1 && char2 && char3).not.equal("0");
    });

    it("Should mint", async function () {
        const { tama } = await loadFixture(deployContractFixture);
        const value = parseEther("0.01");
        expect(await tama.read.totalSupply()).to.equal(1n);
        const gas = await tama.estimateGas.purchase([1n], { value });
        console.log("Mint gas: " + gas);
    });

    it("Should hatch", async function () {
        const { tama } = await loadFixture(deployContractFixture);
        const gas = await tama.estimateGas.start([0n]);
        console.log("Hatching gas: " + gas);
        await tama.write.start([0n]);
        const getData = await tama.read.gameData([0n]);
        const startCheck = getData[1];
        expect(startCheck).not.equal(0n);
    }).timeout(120000);

    it("Should set level 1", async function () {
        const { tama } = await loadFixture(deployContractFixture);
        await tama.write.start([0n]);
        await tama.write.setPlayPoints([100n]);
        const gas = await tama.estimateGas.play([0n]);
        console.log("Level1 gas: " + gas);
        await tama.write.play([0n]);
        const getData = await tama.read.gameData([0n]);
        const level = getData[0];
        expect(level).equal(1);

    }).timeout(120000);

    it("Should set level 2", async function () {
        const { tama } = await loadFixture(deployContractFixture);
        await tama.write.start([0n]);
        await tama.write.setPlayPoints([100n]);
        await tama.write.play([0n]);
        await tama.write.play([0n]);
        await tama.write.play([0n]);
        await tama.write.play([0n]);
        const gas = await tama.estimateGas.play([0n]);
        console.log("Level2 gas: " + gas);
        await tama.write.play([0n]);
        const getData = await tama.read.gameData([0n]);
        const level = getData[0];
        expect(level).equal(2);

    }).timeout(120000);
});
