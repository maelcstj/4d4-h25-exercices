const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.use(express.json()); // For handling JSON requests

const users = [
    { id: 1, name: "Alice", email: "alice@example.com" },
    { id: 2, name: "Bob", email: "bob@example.com" }
];

// List all users
app.get('/', (req, res) => res.json({ message: 'Welcome to User Management' }));

// Get a user by ID
app.get('/users/:id', (req, res) => {
    const user = users.find(u => u.id === parseInt(req.params.id));
    user ? res.json(user) : res.status(404).json({ error: "User not found" });
});

// Get all users
app.get('/users', (req, res) => {
    res.json(users);
});

app.listen(port, () => console.log(`User Management Service running on port ${port}`));
