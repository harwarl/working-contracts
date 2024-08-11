async function main() {
  const escrow = await hre.ethers.getContractAt(
    "Escrow",
    "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512"
  );

  const signers = await ethers.getSigners();

  const tx = await escrow.connect(signers[4]).approve();
  const receipt = await tx.wait();
  console.log(receipt);
  return { receipt };
}

main()
  .then(() => {
    process.exit(0);
  })
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
