const mongoose = require("mongoose");

const sellerRequestSchema = mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    shopName: {
        type: String,
        required: true,
        trim: true,
    },
    shopDescription: {
        type: String,
        required: true,
        trim: true,
    },
    avatarUrl: {
        type: String,
        required: true,
    },
    status: {
        type: String,
        enum: ['pending', 'approved', 'rejected'],
        default: 'pending'
    },
    createdAt: {
        type: Date,
        default: Date.now
    },
    address: {
        type: String,
        required: true,
        trim: true,
    },
});

const SellerRequest = mongoose.model("SellerRequest", sellerRequestSchema);
module.exports = SellerRequest;