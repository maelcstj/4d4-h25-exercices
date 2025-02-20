const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql');
const cors = require('cors');

const app = express();
const port = 3000;

const db = mysql.createConnection({
    host: 'users-db',            // TODO: modifier pour le nom du service de base de données dans Docker Compose
    user: 'mael',                // TODO: modifier pour le user de la base de données dans Docker Compose
    password: 'maelpassword',    // TODO: modifier pour le mot de passe de la base de données dans Docker Compose
    database: 'user_management'
});

db.connect(err => {
    if (err) {
        console.error('Error connecting to MySQL:', err);
        return;
    }
    console.log('Connected to MySQL database');
});

app.use(cors());
app.use(bodyParser.json());

// Get all users
app.get('/users', (req, res) => {
    const query = 'SELECT * FROM users';
    db.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching users from MySQL:', err);
            res.status(500).send('Internal Server Error');
            return;
        }
        res.json(results);
    });
});

app.listen(port, () => {
    console.log(`Users microservice listening at http://localhost:${port}`);
});
