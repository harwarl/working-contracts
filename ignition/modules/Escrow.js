const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");
const { ethers } = require("hardhat");

module.exports = buildModule("EscrowModule", (m) => {
  const arbiterAddress = m.getParameter(
    "_arbiter",
    "0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65"
  );
  const beneficiaryAddress = m.getParameter(
    "_beneficiary",
    "0xBcd4042DE499D14e55001CcbB24a551F3b954096"
  );

  const escrow = m.contract("Escrow", [arbiterAddress, beneficiaryAddress], {
    value: ethers.parseEther("1"),
  });

  return { escrow };
});
