const KateToken = artifacts.require("KateToken");

contract('KateToken', (accounts) => {

  let instance;

  before(async () => {
    instance = await KateToken.deployed();
  });

  it('Check balance', async () => {
    let balance = await instance.getOwnerBalance();
    balance = web3.utils.fromWei(balance, 'ether');
    assert.equal(balance, '1000000000', "Balance should be 1000000000 for contract creator.");
  });

  it('Check owner', async () => {
    let owner = await instance.getOwner();
    assert.equal(owner, accounts[0], `Expected owner ${accounts[0]} but got ${owner}`);
  });

  it('Check transfer funds', async () => {
    let amount = web3.utils.toWei('1000', 'ether');
    await instance.transfer(accounts[1], amount);
    let balance = await instance.balanceOf(accounts[1]);
    balance = web3.utils.fromWei(balance);    
    assert.equal(balance, '1000', `Account: ${accounts[1]} should have a balance of: ${amount} but has ${balance} ethers.`);
  });  

});