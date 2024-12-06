const express = require('express');
const productRouter = express.Router();
const auth = require("../middlewares/auth");
const { Product } = require("../models/product");
const ratingSchema = require("../models/rating");

// /api/products?category=TV (lenh get tham so nam trong link)
productRouter.get("/api/products", auth, async (req, res) => {
    try {
        const products = await Product.find({ category: req.query.category })
            .populate('sellerId', 'shopName shopAvatar');
        res.json(products);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// search product
productRouter.get("/api/products/search/:name", auth, async (req, res) => {
    try {
        const products = await Product.find({
            name: { $regex: req.params.name, $options: "i" },
        }).populate('sellerId', 'shopName shopAvatar');
        res.json(products);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Rating product and Update avgRating
productRouter.post("/api/rate-product", auth, async (req, res) => {
    try {
        const { id, rating } = req.body;
        let product = await Product.findById(id);

        for (let i = 0; i < product.ratings.length; i++) {
            if (product.ratings[i].userId == req.user) {
                product.ratings.splice(i, 1); // Remove the old rating from the same user
                break;
            }
        }
        // Define a new rating schema for the user
        const ratingSchema = {
            userId: req.user,
            rating,
        };

        // Push the new rating to the product's ratings array
        product.ratings.push(ratingSchema);
        const sum = product.ratings.reduce((a, b) => a + b.rating, 0);
        if (product.ratings.length > 0) {
            product.avgRating = sum / product.ratings.length;
        }

        // Save the updated product to the database
        product = await product.save();
        res.json(product);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Deal of the day
productRouter.get("/api/deal-of-day", auth, async (req, res) => {
    try {
        let products = await Product.find({ avgRating: { $gte: 4 } }).sort({ avgRating: -1 }).populate('sellerId', 'shopName shopAvatar');

        res.json(products);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

module.exports = productRouter;