const express = require('express');
const { Web3 } = require('web3');
const fs = require('fs');

const app = express();
const port = 3001;

app.use(express.json());

app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header(
        'Access-Control-Allow-Headers',
        'Origin, X-Requested-With, Content-Type, Accept'
    );
    res.header('Access-Control-Allow-Credentials', true);
    if (req.method === 'OPTIONS') {
        res.header(
            'Access-Control-Allow-Methods',
            'PUT, POST, PATCH, DELETE, GET'
        );
        return res.status(200).json({});
    }
    next();
});

const getContractABI = () => {
    return new Promise((resolve, reject) => {
        const artifactsPath = './artifacts/contracts/Contract.sol/Example.json';
        fs.readFile(artifactsPath, 'utf8', (error, contractJSON) => {
            if (error) {
                console.error('Error getting contract ABI:', error);
                reject(error);
            } else {
                const contractData = JSON.parse(contractJSON);
                const abi = contractData.abi;
                resolve(abi);
            }
        });
    });
};

app.get('/contract-abi', (req, res) => {
    getContractABI()
        .then((abi) => {
            if (abi) {
                res.json({ abi });
            } else {
                res.status(500).json({
                    error: 'Failed to retrieve contract ABI.',
                });
            }
        })
        .catch((error) => {
            console.error('Error:', error);
            res.status(500).json({ error: 'Internal Server Error' });
        });
});

app.post('/sign', async (req, res) => {
    try {
        const web3 = new Web3(
            'https://eth-sepolia.g.alchemy.com/v2/Y5hJV1-XddtUaKmShCLpWevmegsGknmN'
        );
        const privateKey =
            '0x7f10991dd6f3e6324bf0c0e14f25e299252e253fbb35d48eb33fada6fcfd5a48';
        const message = req.body.message;
        console.log(message);
        const wallet = web3.eth.accounts.privateKeyToAccount(privateKey);
        const signature = wallet.sign(message);
        console.log(signature);
        res.status(200).json({
            message: 'Token minted successfully',
        });
    } catch (error) {
        console.error('Error signing message:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
