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

    const value = parseEther("0.01");
    const one = 1;
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
    expect(await tama.read.totalSupply()).to.equal(1n);
  });

  it("Should hatch", async function () {
    const { tama } = await loadFixture(deployContractFixture);
    await tama.write.start([0n]);
    const getData = await tama.read.gameData([0n]);
    const startCheck = getData[1];
    expect(startCheck).not.equal(0n);
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
      `0x5fbdb2315678afecb367f032d93f642f64180aa3`,
      valueApprova,
    ]);
    await tama.write.start([0n]);
    await tama.write.eat([0n]);
    const getData = await tama.read.gameData([0n]);
    const lastEat = getData[2];
    expect(lastEat).not.equal(0n);
  });
});
