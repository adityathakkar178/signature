const express = require('express');
const { ethers } = require('ethers');

const app = express();

const port = 3001;

app.use(express.json());

app.post('/sign-message', (req, res) => {
    const { message, privateKey } = req.body;

    if (!message || !privateKey) {
        return res.status(400).json({ error: 'Message and private key are required' });
    }

    try {
        const wallet = new ethers.Wallet(privateKey);
        const signature = wallet.signMessage(message);
        res.json({ signature });
    } catch (error) {
        console.error('Error signing message:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
