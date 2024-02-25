import hre, { viem } from "hardhat";
import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { parseEther, serializeTransaction } from "viem";

describe("Tama", () => {
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
    const value = parseEther("0.01");
    await tama.write.purchase([1n], { value });
    return { tama };
  }
  it("Should fill SVG contracts", async function () {
    const { tama } = await loadFixture(deployContractFixture);

    const char0 = await tama.read.tama0();
    const char1 = await tama.read.tama1();
    const char2 = await tama.read.tama2();
    const char3 = await tama.read.tama3();
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
  });

  it("Should not hatch more than once", async function () {
    const { tama } = await loadFixture(deployContractFixture);
    await tama.write.start([0n]);
    expect(tama.write.start([0n])).to.be.rejected;
  });

  it("Should play", async function () {
    const { tama } = await loadFixture(deployContractFixture);
    await tama.write.start([0n]);
    await tama.write.play([0n]);
    const getData = await tama.read.gameData([0n]);
    const counter = getData[4];
    expect(counter).equal(10n);
  });

  it("Should eat", async function () {
    const { tama } = await loadFixture(deployContractFixture);
    const tamaFood = await hre.viem.deployContract(
      "contracts/Tama.sol:TamaFood"
    );
    await tama.write.setTamaFoodAddress([tamaFood.address]);
    const valueToken = parseEther("1");
    await tamaFood.write.mint([`0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266`], {
      value: valueToken,
    });
    const valueApprova = parseEther("500");
    await tamaFood.write.approve([
      `0xdf951d2061b12922bfbf22cb17b17f3b39183570`,
      valueApprova,
    ]);
    await tama.write.start([0n]);
    await tama.write.eat([0n]);
    const getData = await tama.read.gameData([0n]);
    const lastEat = getData[2];
    expect(lastEat).not.equal(0n);
  });

  it("Should change Play points and go to 500 points", async function () {
    const { tama } = await loadFixture(deployContractFixture);
    await tama.write.start([0n]);
    await tama.write.setPlayTime([0n]);
    await tama.write.setPlayPoints([100n]);
    await tama.write.play([0n]);
    await tama.write.play([0n]);
    await tama.write.play([0n]);
    await tama.write.play([0n]);
    await tama.write.play([0n]);
    const getData = await tama.read.gameData([0n]);
    const counter = getData[4];
    expect(counter).equal(500n);
  });
});
