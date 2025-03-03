const router = require("express").Router();
const userController = require("../controllers/userController");
const {verifyTokenAndAuthorization, verifyAndAdmin} = require("../middleware/verifyToken");

// Update user
router.put("/", verifyTokenAndAuthorization, userController.updateUser);

// Delete user
router.delete("/", verifyTokenAndAuthorization, userController.deleteUser);

// Get user
router.get("/", verifyTokenAndAuthorization, userController.getUser);

// Get all user
router.get("/", verifyAndAdmin, userController.getAllUsers);

module.exports = router