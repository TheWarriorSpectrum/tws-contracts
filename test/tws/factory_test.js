const { expect } = require("chai");

describe("Warrior Factory tests", async () => {
  // eslint-disable-next-line no-unused-vars
  let warriorFactory, owner, addr1, addr2;

  const OPTION_NINJA = 0;
  const OPTION_SPARTAN = 1;
  const OPTION_GLADIATOR = 2;

  beforeEach(async () => {
    const FACTORY = await ethers.getContractFactory("TheWarriorFactory");
    [owner, addr1, addr2, addr3, ...addrs] = await ethers.getSigners();
    warriorFactory = await FACTORY.deploy();
  });

  it("Gets warrior metadata", async () => {
    const ninjaURI = await warriorFactory.tokenURI(OPTION_NINJA);
    const spartanURI = await warriorFactory.tokenURI(OPTION_SPARTAN);
    const gladiatorURI = await warriorFactory.tokenURI(OPTION_GLADIATOR);

    expect(ninjaURI).to.be.equal(
      "https://ipfs.io/ipfs/QmWuQ2c88SMzaTrYxSZXwYgQ4w8MWVwr1pAba7kUaHHMFz"
    );
    expect(spartanURI).to.be.equal(
      "https://ipfs.io/ipfs/QmWUF76u726kkx3EehYS3HYfouhTLSbzu4MFBPHNjadi18"
    );
    expect(gladiatorURI).to.be.equal(
      "https://ipfs.io/ipfs/QmY2H7LYrQ6kmWRtQFYLMrAXToj1e1XU5wMSdNi3c6sb1z"
    );
  });
});
