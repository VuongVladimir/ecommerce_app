const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../.env') });

// IMPORT FROM PACKAGES
const cors = require('cors');
const express = require("express");
const mongoose = require("mongoose");

// IMPORT FROM OTHER FILES
const authRouter = require("./routes/auth");
const adminRouter = require("./routes/admin");
const productRouter = require("./routes/product");
const userRouter = require("./routes/user");
const sellerRouter = require("./routes/seller");

// INIT
const PORT = process.env.PORT || 3000;
const app = express();
const DB = process.env.MONGODB_URL;
//console.log('MongoDB URL:', DB);
// middleware
app.use(cors({
    origin: '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'x-auth-token'], // Add x-auth-token
    credentials: true
}));

app.use(express.json());
app.use(authRouter);
app.use(sellerRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);


// Connection
mongoose.connect(DB).then(() => {
    console.log("Connection Mongodb Successful");
}).catch((e) => {
    console.log(e);
    console.log("Failed to connect Mongodb");
});

app.get('/', (req, res) => {
    res.send('Hello from Express!');
  });
  

  app.listen(PORT, () => { 
    console.log(`connected at port ${PORT}`);
});