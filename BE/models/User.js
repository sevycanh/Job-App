const mongoose = require("mongoose");

const UserSchema = new mongoose.Schema(
  {
    username: { type: String, required: true, unique: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    location: { type: String, required: false },
    isAdmin: { type: Boolean, default: false },
    isAgent: { type: Boolean, default: false },
    skills: { type: Array, default: false },
    profile: {
      type: String,
      required: true,
      default:
        "https://i.pinimg.com/236x/e8/89/93/e88993f7ec0a9103b23f309288616ad2.jpg",
    },
  },
  { timestamps: true }
);
module.exports = mongoose.model("User", UserSchema);
