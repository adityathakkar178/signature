const { ethers } = require('hardhat');
const { Web3 } = require('web3');

async function deployContractAndSignMessage() {
    const Example = await ethers.getContractFactory('Example');
    const example = await Example.deploy();
    await example.deployed();

    console.log('Contract deployed to address:', example.address);

    const web3 = new Web3(
        'https://eth-sepolia.g.alchemy.com/v2/Y5hJV1-XddtUaKmShCLpWevmegsGknmN'
    );
    const privateKey =
        '0x7f10991dd6f3e6324bf0c0e14f25e299252e253fbb35d48eb33fada6fcfd5a48';
    const message = 'Hello, world!';
    const wallet = web3.eth.accounts.privateKeyToAccount(privateKey);
    const signature = wallet.sign(message);

    console.log('Message:', message);
    console.log('Signature:', signature);
    console.log(wallet);
}

deployContractAndSignMessage().catch((error) => console.error(error));
