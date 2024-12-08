const mongoose = require("mongoose");
const ratingSchema = require("./rating");

const productSchema = mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true,
    },
    description: {
        type: String,
        required: true,
        trim: true,
    },
    images: [
        {
            type: String,
            required: true,
        },
    ],
    quantity: {
        type: Number,
        required: true,
    },
    price: {
        type: Number,
        required: true,
    },
    category: {
        type: String,
        required: true,
    },
    sellerId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    ratings: [ratingSchema],
    avgRating: {
        type: Number,
        default: 0,
    },
    discount: {
        percentage: {
          type: Number,
          default: 0,
        },
        startDate: {
          type: Date,
          default: null,
        },
        endDate: {
          type: Date, 
          default: null,
        }
      },
      // Thêm field này để lưu giá sau khi giảm
      finalPrice: {
        type: Number,
        default: function() {
          return this.price;
        }
      }
});


// Thêm middleware để tự động tính finalPrice
productSchema.pre('save', function(next) {
    if (this.discount && this.discount.percentage > 0) {
      const now = new Date();
      if (now >= this.discount.startDate && now <= this.discount.endDate) {
        this.finalPrice = this.price * (1 - this.discount.percentage / 100);
      } else {
        this.finalPrice = this.price;
      }
    } else {
      this.finalPrice = this.price;
    }
    next();
  });


const Product = mongoose.model("Product", productSchema);
module.exports = {Product, productSchema};