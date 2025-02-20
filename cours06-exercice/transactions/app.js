const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
const port = 3001;

// TODO: mongodb://user:password@hostname:port/dbname
const mongoUrl = 'mongodb://mael:maelpassword@users-db:27017/transactions'

mongoose.connect(mongoUrl,
 { 
    useNewUrlParser: true, 
    useUnifiedTopology: true
 });
const transactionSchema = new mongoose.Schema({
    description: String,
    amount: Number
});
const Transaction = mongoose.model('Transaction', transactionSchema);

app.use(cors());
app.use(bodyParser.json());

// Get all transactions
app.get('/transactions', async (req, res) => {
    try {
        const transactions = await Transaction.find();
        res.json(transactions);
    } catch (err) {
        console.error('Error fetching transactions from MongoDB:', err);
        res.status(500).send('Internal Server Error');
    }
});

app.listen(port, () => {
    console.log(`Transactions microservice listening at http://localhost:${port}`);
});
