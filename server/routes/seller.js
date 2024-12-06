const express = require('express');
const { Product } = require('../models/product');
const Order = require("../models/order");
const sellerRouter = express.Router();
const seller = require("../middlewares/seller");

const SellerRequest = require('../models/sellerRequest');

const auth = require('../middlewares/auth');
const User = require('../models/user');




// Register as seller
sellerRouter.post('/api/register-seller', auth, async (req, res) => {
    try {
        const { shopName, shopDescription, avatarUrl } = req.body;

        // Check if shop name already exists
        const existingShop = await User.findOne({ shopName });
        if (existingShop) {
            return res.status(400).json({ msg: "Shop name already exists" });
        }

        // Check if user already has a pending request
        const existingRequest = await SellerRequest.findOne({
            userId: req.user,
            status: 'pending'
        });

        if (existingRequest) {
            return res.status(400).json({ msg: "You already have a pending request" });
        }

        // Create new seller request
        const sellerRequest = new SellerRequest({
            userId: req.user,
            shopName,
            shopDescription,
            avatarUrl,
        });

        await sellerRequest.save();
        res.json({ status: 'pending', msg: "Seller request submitted successfully" });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Get seller request status
sellerRouter.get('/api/seller-request-status', auth, async (req, res) => {
    try {
        const request = await SellerRequest.findOne({
            userId: req.user
        }).sort({ createdAt: -1 }); // Get the most recent request

        if (!request) {
            return res.json({ status: 'none' });
        }

        res.json({ status: request.status });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});


// Add product
sellerRouter.post("/seller/add-product", seller, async (req, res) => {
    try {
        const { name, description, images, quantity, price, category } = req.body;
        let product = new Product({
            name,
            description,
            images,
            quantity,
            price,
            category,
            sellerId: req.user,
        });
        product = await product.save();
        res.json(product);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// get all products
sellerRouter.get("/seller/get-products", seller, async (req, res) => {
    try {
        const products = await Product.find({sellerId: req.user});
        res.json(products);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Delete the product
sellerRouter.post("/seller/delete-product", seller, async (req, res) => {
    try {
        const { id } = req.body;
        let product = await Product.findOneAndDelete({ 
            _id: id,
            sellerId: req.user 
        });
        if (!product) {
            return res.status(404).json({ msg: "Product not found or you're not authorized" });
        }
        res.json(product);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// get seller's orders
sellerRouter.get("/seller/get-orders", seller, async (req, res) => {
    try {
        const orders = await Order.find({
            'products.product.sellerId': req.user
        });
        res.json(orders);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// change order status
sellerRouter.post("/seller/change-order-status", seller, async (req, res) => {
    try {
        const { id, status } = req.body;
        let order = await Order.findOne({
            _id: id,
            'products.product.sellerId': req.user
        });
        if (!order) {
            return res.status(404).json({ msg: "Order not found or you're not authorized" });
        }
        order.status = status;
        order = await order.save();
        res.json(order);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});


// sellerRouter.get("/seller/analytics", seller, async (req, res) => {
//     try {
//         const orders = await Order.find({}).populate('products.product');
//         let totalEarnings = 0;
//         let categoryEarnings = {
//             Mobiles: 0,
//             Essentials: 0,
//             Appliances: 0,
//             Books: 0,
//             Fashion: 0
//         };

//         // orders.forEach(order => {
//         //     totalEarnings += order.totalPrice;
//         //     order.products.forEach(item => {
//         //         if (categoryEarnings.hasOwnProperty(item.product.category)) {
//         //             categoryEarnings[item.product.category] += item.quantity * item.product.price;
//         //         }
//         //     });
//         // });
//         orders.forEach(order => {
//             console.error("Order:", order._id, "Total Price:", order.totalPrice);
//             totalEarnings += order.totalPrice;
//             order.products.forEach(item => {
//                 console.error("Product:", item.product.name, "Category:", item.product.category, "Price:", item.product.price, "Quantity:", item.quantity);
//                 if (categoryEarnings.hasOwnProperty(item.product.category)) {
//                     categoryEarnings[item.product.category] += item.quantity * item.product.price;
//                 } else {
//                     console.error("Unknown category:", item.product.category);
//                 }
//             });
//         });
//         console.error("Total Earnings:", totalEarnings);
//         console.error("Category Earnings:", categoryEarnings);



//         let earnings = {
//             totalEarnings,
//             mobileEarnings: categoryEarnings.Mobiles,
//             essentialEarnings: categoryEarnings.Essentials,
//             applianceEarnings: categoryEarnings.Appliances,
//             booksEarnings: categoryEarnings.Books,
//             fashionEarnings: categoryEarnings.Fashion,
//         };
        
//         res.json(earnings);
//     } catch (e) {
//         res.status(500).json({ error: e.message });
//     }
// });

sellerRouter.get("/seller/analytics", seller, async (req, res) => {
    try {
        const orders = await Order.find({
            'products.product.sellerId': req.user,
            status: 3, // Chỉ tính các đơn hàng đã delivered
        }).populate('products.product');

        let totalEarnings = 0;
        let categoryEarnings = {
            Mobiles: 0,
            Essentials: 0,
            Appliances: 0,
            Books: 0,
            Fashion: 0
        };

        orders.forEach(order => {
            order.products.forEach(item => {
                if (item.product.sellerId.toString() === req.user) {
                    const earning = item.quantity * item.product.price;
                    totalEarnings += earning;
                    if (categoryEarnings.hasOwnProperty(item.product.category)) {
                        categoryEarnings[item.product.category] += earning;
                    }
                }
            });
        });

        let earnings = {
            totalEarnings,
            categoryData: Object.entries(categoryEarnings).map(([category, earning]) => ({
                category,
                earning
            }))
        };
        
        res.json(earnings);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});



// update product
sellerRouter.post("/seller/update-product", seller, async (req, res) => {
    try {
        const { id, name, description, images, quantity, price, category } = req.body;
        let product = await Product.findOne({
            _id: id,
            sellerId: req.user
        });
        
        if (!product) {
            return res.status(404).json({ msg: "Product not found or you're not authorized" });
        }

        product.name = name;
        product.description = description;
        product.images = images;
        product.quantity = quantity;
        product.price = price;
        product.category = category;
        product = await product.save();
        res.json(product);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});




// Follow a seller
sellerRouter.post("/seller/follow", auth, async (req, res) => {
    try {
        const { sellerId } = req.body;
        
        // Check if seller exists
        const seller = await User.findById(sellerId);
        if (!seller) {
            return res.status(404).json({ msg: "Seller not found" });
        }

        // Check if user is trying to follow themselves
        if (sellerId === req.user) {
            return res.status(400).json({ msg: "You cannot follow yourself" });
        }

        // Check if already following
        const user = await User.findById(req.user);
        if (user.following.includes(sellerId)) {
            return res.status(400).json({ msg: "Already following this seller" });
        }

        // Add seller to user's following
        await User.findByIdAndUpdate(req.user, {
            $push: { following: sellerId }
        });

        // Add user to seller's followers
        await User.findByIdAndUpdate(sellerId, {
            $push: { followers: req.user }
        });

        res.json({ msg: "Successfully followed seller" });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Unfollow a seller
sellerRouter.post("/seller/unfollow", auth, async (req, res) => {
    try {
        const { sellerId } = req.body;

        // Remove seller from user's following
        await User.findByIdAndUpdate(req.user, {
            $pull: { following: sellerId }
        });

        // Remove user from seller's followers
        await User.findByIdAndUpdate(sellerId, {
            $pull: { followers: req.user }
        });

        res.json({ msg: "Successfully unfollowed seller" });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Get shop data
sellerRouter.get("/seller/shop-data/:sellerId", auth, async (req, res) => {
    try {
        const shopOwner = await User.findById(req.params.sellerId);
        if (!shopOwner) {
            return res.status(404).json({ msg: "Seller not found" });
        }

        const products = await Product.find({ sellerId: req.params.sellerId });
        
        res.json({
            shopOwner,
            products,
        });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Update shop stats route to accept sellerId
sellerRouter.get("/seller/shop-stats/:sellerId", auth, async (req, res) => {
    try {
        const products = await Product.find({ sellerId: req.params.sellerId });
        const sellerData = await User.findById(req.params.sellerId);
        
        if (!sellerData) {
            return res.status(404).json({ msg: "Seller not found" });
        }

        let totalRatings = 0;
        let ratingCount = 0;
        products.forEach(product => {
            if (product.ratings && product.ratings.length > 0) {
                product.ratings.forEach(rating => {
                    totalRatings += rating.rating;
                    ratingCount++;
                });
            }
        });

        const avgShopRating = ratingCount > 0 ? (totalRatings / ratingCount).toFixed(1) : 0;

        res.json({
            totalProducts: products.length,
            avgRating: avgShopRating,
            followerCount: sellerData.followers.length,
        });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

module.exports = sellerRouter;