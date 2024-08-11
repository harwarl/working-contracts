const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("CollectibleModule", (m) => {
  const collectible = m.contract("Collectible");

  return { collectible };
});
