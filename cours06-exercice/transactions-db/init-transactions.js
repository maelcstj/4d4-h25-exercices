// Connect to MongoDB server
const conn = new Mongo();
const db = conn.getDB("transactions");

// Create a transactions collection and insert some initial data
db.transactions.insertMany([
  { description: "Grocery Shopping", amount: 75.25 },
  { description: "Online Subscription", amount: 12.99 },
  { description: "Restaurant Dinner", amount: 45.50 },
  { description: "Electricity Bill", amount: 90.00 },
  { description: "Gym Membership", amount: 30.00 },
  { description: "Freelance Payment", amount: 200.00 },
  { description: "Movie Tickets", amount: 25.00 },
  { description: "Coffee Purchase", amount: 5.50 },
  { description: "Bookstore Purchase", amount: 40.75 },
  { description: "Car Fuel", amount: 60.00 }
]);

print("Initialization complete.");
