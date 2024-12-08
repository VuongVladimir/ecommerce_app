const express = require('express');
const { Product } = require('../models/product');
const adminRouter = express.Router();
const admin = require("../middlewares/admin");
const Order = require("../models/order");
const User = require("../models/user");
const SellerRequest = require("../models/sellerRequest");

// // Add product
// adminRouter.post("/admin/add-product", admin, async (req, res) => {
//     try {
//         const { name, description, images, quantity, price, category } = req.body;
//         let product = new Product({
//             name,
//             description,
//             images,
//             quantity,
//             price,
//             category,
//         });
//         product = await product.save();
//         res.json(product);
//     } catch (e) {
//         res.status(500).json({ error: e.message });
//     }
// });

// // get all products
// adminRouter.get("/admin/get-products", admin, async (req, res) => {
//     try {
//         const products = await Product.find({});
//         res.json(products);
//     } catch (e) {
//         res.status(500).json({ error: e.message });
//     }
// });

// // Delete the product
// adminRouter.post("/admin/delete-product", admin, async (req, res) => {
//     try {
//         const { id } = req.body;
//         let product = await Product.findByIdAndDelete(id);
//         res.json(product);
//     } catch (e) {
//         res.status(500).json({ error: e.message });
//     }
// });

// // get all orders
// adminRouter.get("/admin/get-orders", admin, async (req, res) => {
//     try {
//         const orders = await Order.find({});
//         res.json(orders);
//     } catch (e) {
//         res.status(500).json({ error: e.message });
//     }
// });

// // change order status
// adminRouter.post("/admin/change-order-status", admin, async (req, res) => {
//     try {
//         const { id, status } = req.body;
//         let order = await Order.findById(id);
//         order.status = status;
//         order = await order.save();
//         res.json(order);
//     } catch (e) {
//         res.status(500).json({ error: e.message });
//     }
// });

// // test cursor
// adminRouter.get("/admin/analytics", admin, async (req, res) => {
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

// // Xóa hàm fetchCategoryWiseProduct vì không cần thiết nữa

// // adminRouter.get("/admin/analytics", admin, async (req, res) => {
// //     try {
// //         const orderList = await Order.find({});
// //         let totalEarnings = 0;

// //         for (let i = 0; i < orderList.length; i++) {
// //             totalEarnings += orderList[i].totalPrice;
// //         }
// //         // CATEGORY WISE ORDER FETCHING
// //         let mobileEarnings = await fetchCategoryWiseProduct("Mobiles");
// //         let essentialEarnings = await fetchCategoryWiseProduct("Essentials");
// //         let applianceEarnings = await fetchCategoryWiseProduct("Appliances");
// //         let booksEarnings = await fetchCategoryWiseProduct("Books");
// //         let fashionEarnings = await fetchCategoryWiseProduct("Fashion");

// //         let earnings = {
// //             totalEarnings,
// //             mobileEarnings,
// //             essentialEarnings,
// //             applianceEarnings,
// //             booksEarnings,
// //             fashionEarnings,
// //         };

// //         res.json(earnings);
// //     } catch (e) {
// //         res.status(500).json({ error: e.message });
// //     }
// // });

// // async function fetchCategoryWiseProduct(category) {
// //     let earnings = 0;
// //     let categoryOrders = await Order.find({
// //         "products.product.category": category,
// //     });

// //     for (let i = 0; i < categoryOrders.length; i++) {
// //         for (let j = 0; j < categoryOrders[i].products.length; j++) {
// //             earnings +=
// //                 categoryOrders[i].products[j].quantity *
// //                 categoryOrders[i].products[j].product.price;
// //         }
// //     }
// //     console.log(`${category} ${earnings}`);
// //     return earnings;
// // }

// // update product
// adminRouter.post("/admin/update-product", admin, async (req, res) => {
//     try {
//         const { id, name, description, images, quantity, price, category } = req.body;
//         let product = await Product.findById(id);
//         product.name = name;
//         product.description = description;
//         product.images = images;
//         product.quantity = quantity;
//         product.price = price;
//         product.category = category;
//         product = await product.save();
//         res.json(product);
//     } catch (e) {
//         res.status(500).json({ error: e.message });
//     }
// });


// Admin gets all pending seller requests
adminRouter.get('/admin/seller-requests', admin, async (req, res) => {
    try {
        const requests = await SellerRequest.find({ status: 'pending' })
            .populate('userId', 'name email') // Lấy thêm name và email từ user
            .lean();
        res.json(requests);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Admin approves or rejects seller request
adminRouter.post('/admin/process-seller-request', admin, async (req, res) => {
    try {
        const { requestId, status } = req.body;
        const request = await SellerRequest.findById(requestId);
        
        if (!request) {
            return res.status(404).json({ msg: "Request not found" });
        }

        request.status = status;
        await request.save();

        if (status === 'approved') {
            await User.findByIdAndUpdate(request.userId, {
                type: 'seller',
                shopName: request.shopName,
                shopDescription: request.shopDescription,
                address: request.address,
                shopAvatar: request.avatarUrl,
            });
        }

        res.json({ msg: `Seller request ${status}` });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Get all sellers
adminRouter.get("/admin/sellers", admin, async (req, res) => {
    try {
        const sellers = await User.find({ type: "seller" });
        res.json(sellers);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Disable seller account
adminRouter.post("/admin/disable-seller", admin, async (req, res) => {
    try {
        const { sellerId } = req.body;
        const seller = await User.findById(sellerId);
        
        if (!seller || seller.type !== "seller") {
            return res.status(404).json({ msg: "Seller not found" });
        }

        seller.type = "user";
        await seller.save();
        res.json({ msg: "Seller account disabled successfully" });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Get seller statistics
adminRouter.get("/admin/seller-stats", admin, async (req, res) => {
    try {
        const totalSellers = await User.countDocuments({ type: "seller" });
        const pendingRequests = await SellerRequest.countDocuments({ status: "pending" });
        
        res.json({
            totalSellers,
            pendingRequests
        });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});


module.exports = adminRouter;