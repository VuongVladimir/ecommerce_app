// IMPORT FROM PACKAGES
const express = require("express");
const mongoose = require("mongoose");
// IMPORT FROM OTHER FILES
const authRouter = require("./routes/auth");
const adminRouter = require("./routes/admin");
const productRouter = require("./routes/product");
const userRouter = require("./routes/user");

// INIT
const PORT = process.env.PORT || 3000;
const app = express();
const DB = process.env.MONGODB_URL || "mongodb+srv://sugartank:super156789@cluster0.5xpcm.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";
// middleware
app.use(express.json());
app.use(authRouter);
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