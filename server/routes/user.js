const express = require('express');
const userRouter = express.Router();
const auth = require("../middlewares/auth");
const { Product } = require('../models/product');
const User = require('../models/user');
const Order = require("../models/order");
const Notification = require('../models/notification');

// Add product to cart
userRouter.post("/api/add-to-cart", auth, async (req, res) => {
    try {
        const { id } = req.body;
        const product = await Product.findById(id);
        let user = await User.findById(req.user);
        const existingProduct = user.cart.find((item) => item.product._id.equals(product._id));
        if (existingProduct) {
            existingProduct.quantity++;
        }
        else {
            user.cart.push({ product, quantity: 1 });
        }
        user = await user.save();
        res.json(user);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});


// Delete product from cart
userRouter.delete("/api/remove-from-cart/:id", auth, async (req, res) => {
    try {
        const { id } = req.params;
        const product = await Product.findById(id);
        let user = await User.findById(req.user);
        
        // Find and update the product in cart
        const cartItemIndex = user.cart.findIndex(
            (item) => item.product._id.equals(product._id)
        );
        
        if (cartItemIndex !== -1) {
            user.cart[cartItemIndex].quantity--;
            
            // Remove item if quantity reaches 0
            if (user.cart[cartItemIndex].quantity <= 0) {
                user.cart.splice(cartItemIndex, 1);
            }
        }
        
        user = await user.save();
        res.json(user);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// save user address
userRouter.post("/api/save-user-address", auth, async (req, res) => {
    try {
        const { address } = req.body;
        let user = await User.findById(req.user);
        user.address = address;
        user = await user.save();
        res.json(user);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// order product
userRouter.post("/api/order", auth, async (req, res) => {
    try {
        const { cart, totalPrice, address } = req.body;
        let products = [];
        for (let i = 0; i < cart.length; i++) {
            let product = await Product.findById(cart[i].product._id);
            if (product.quantity >= cart[i].quantity) {
                product.quantity -= cart[i].quantity;
                products.push({ product, quantity: cart[i].quantity });
                await product.save();
            }
            else {
                return res.status(400).json({ msg: `${product.name} is out of stock!` });
            }
        }
        let user = await User.findById(req.user);
        user.cart = [];
        user = await user.save();
        let order = new Order({
            products,
            totalPrice,
            address,
            userId: req.user,
            orderedAt: new Date().getTime(),
        });
        order = await order.save();
        res.json(order);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Add new route for direct order
userRouter.post("/api/order-direct", auth, async (req, res) => {
    try {
        const { products, quantities, totalPrice, address } = req.body;
        let orderProducts = [];

        for (let i = 0; i < products.length; i++) {
            let product = await Product.findById(products[i]._id);
            if (product.quantity >= quantities[i]) {
                product.quantity -= quantities[i];
                orderProducts.push({ product, quantity: quantities[i] });
                await product.save();
            } else {
                return res.status(400).json({ msg: `${product.name} is out of stock!` });
            }
        }

        let order = new Order({
            products: orderProducts,
            totalPrice,
            address,
            userId: req.user,
            orderedAt: new Date().getTime(),
        });

        order = await order.save();
        res.json(order);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// get my order
userRouter.get("/api/orders/me", auth, async (req, res) => {
    try {
        const orders = await Order.find({ userId: req.user });
        res.json(orders);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});



// Get notifications for user
userRouter.get("/api/notifications", auth, async (req, res) => {
    try {
        const notifications = await Notification.find({ 
            userId: req.user 
        })
        .sort({ createdAt: -1 }) // Sort by newest first
        .limit(50); // Limit to last 50 notifications
        
        res.json(notifications);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Mark notification as read
userRouter.post("/api/notifications/mark-read/:id", auth, async (req, res) => {
    try {
        const notification = await Notification.findOneAndUpdate(
            {
                _id: req.params.id,
                userId: req.user
            },
            { isRead: true },
            { new: true }
        );

        if (!notification) {
            return res.status(404).json({ msg: "Notification not found" });
        }

        res.json(notification);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Mark all notifications as read
userRouter.post("/api/notifications/mark-all-read", auth, async (req, res) => {
    try {
        await Notification.updateMany(
            { userId: req.user, isRead: false },
            { isRead: true }
        );
        
        res.json({ msg: "All notifications marked as read" });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Delete notification
userRouter.delete("/api/notifications/:id", auth, async (req, res) => {
    try {
        const notification = await Notification.findOneAndDelete({
            _id: req.params.id,
            userId: req.user
        });

        if (!notification) {
            return res.status(404).json({ msg: "Notification not found" });
        }

        res.json({ msg: "Notification deleted successfully" });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Delete all notifications for user
userRouter.delete("/api/notifications/delete-all", auth, async (req, res) => {
    try {
        await Notification.deleteMany({ userId: req.user });
        res.json({ msg: "All notifications deleted successfully" });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Add option to clear notifications older than X days
userRouter.delete("/api/notifications/clear-old", auth, async (req, res) => {
    try {
        const daysOld = req.query.days || 30; // Default to 30 days
        const dateThreshold = new Date();
        dateThreshold.setDate(dateThreshold.getDate() - daysOld);

        await Notification.deleteMany({
            userId: req.user,
            createdAt: { $lt: dateThreshold }
        });

        res.json({ msg: `Notifications older than ${daysOld} days deleted` });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Get product by ID
userRouter.get("/api/product/:id", auth, async (req, res) => {
    try {
        const product = await Product.findById(req.params.id);
        
        if (!product) {
            return res.status(404).json({ msg: "Product not found" });
        }
        
        res.json(product);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});



module.exports = userRouter;