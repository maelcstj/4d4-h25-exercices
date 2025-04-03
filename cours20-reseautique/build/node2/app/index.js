const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.use(express.json()); // For handling JSON requests

const transactions = [
    { id: 1, user: "Alice", amount: 50.75, type: "purchase" },
    { id: 2, user: "Bob", amount: 200, type: "deposit" }
];

// Create a router
const router = express.Router();

// List all transactions
router.get('/', (req, res) => res.json({ message: 'Welcome to Transaction Management' }));

// Get a transaction by ID
router.get('/transactions/:id', (req, res) => {
    const transaction = transactions.find(t => t.id === parseInt(req.params.id));
    transaction ? res.json(transaction) : res.status(404).json({ error: "Transaction not found" });
});

// Get all transactions
router.get('/transactions', (req, res) => {
    res.json(transactions);
});

// Middleware Ingress fix for the transaction service /backend/node2 -> / 
// Mount the router at /backend/node2
app.use('/', router);
app.use('/backend/node2', router);

app.listen(port, () => console.log(`Transaction Management Service running on port ${port}`));
