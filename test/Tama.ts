import hre, { viem } from "hardhat";
import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { parseEther, serializeTransaction } from "viem";

describe("Tama", () => {
    async function deployContractFixture() {

        const tama = await hre.viem.deployContract("contracts/Tama.sol:Tama");
        /*     const character0 = await hre.viem.deployContract("Character0");
            const character1 = await hre.viem.deployContract("Character1");
            const character2 = await hre.viem.deployContract("Character2");
            const character3 = await hre.viem.deployContract("Character3"); */

        return { tama };
    }
    it("Should fill contracts", async function () {
        const { tama } = await loadFixture(deployContractFixture);
        const character0 = await hre.viem.deployContract("Character0");
        const character1 = await hre.viem.deployContract("Character1");
        const character2 = await hre.viem.deployContract("Character2");
        const character3 = await hre.viem.deployContract("Character3");

        await tama.write.setCharacters([character0.address, character1.address, character2.address, character3.address]);
        const char0 = await tama.read.tama0();
        const char1 = await tama.read.tama1();
        const char2 = await tama.read.tama2();
        const char3 = await tama.read.tama3();
        expect(char0 && char1 && char2 && char3).not.equal("0");

    });

    it("Should mint", async function () {
        const { tama } = await loadFixture(deployContractFixture);
        const value = parseEther("0.01");
        await tama.write.purchase([1n], { value });
        expect(tama.read.totalSupply).equal([1n]);
    })

    it("Should play", async function () {
        const { tama } = await loadFixture(deployContractFixture);
        const value = parseEther("0.01");
        await tama.write.purchase([1n], { value });
        await tama.write.play([0n]);
        const counter = await tama.read.gameData([0n]).counter;
        expect(counter).equal([10n]);
    })
})