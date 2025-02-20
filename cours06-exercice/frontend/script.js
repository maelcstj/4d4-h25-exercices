document.addEventListener('DOMContentLoaded', function () {
    // Fetch users and transactions when the page loads
    getUsers();
    getTransactions();
});

function getUsers() {
    fetch('http://localhost:3000/users')
        .then(response => response.json())
        .then(users => {
            const userList = document.getElementById('userList');
            userList.innerHTML = users.map(user => `<li>${user.username} - ${user.email}</li>`).join('');
        })
        .catch(error => console.error('Error fetching users:', error));
}

function getTransactions() {
    fetch('http://localhost:3001/transactions')
        .then(response => response.json())
        .then(transactions => {
            const transactionList = document.getElementById('transactionList');
            transactionList.innerHTML = transactions.map(transaction => `<li>${transaction.description} - ${transaction.amount}</li>`).join('');
        })
        .catch(error => console.error('Error fetching transactions:', error));
}
