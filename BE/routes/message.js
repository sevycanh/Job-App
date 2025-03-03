const router = require("express").Router();
const messageController = require("../controllers/messageController");
const { verifyTokenAndAuthorization, verifyToken } = require("../middleware/verifyToken");

// Send message
router.post("/", verifyTokenAndAuthorization, messageController.sendMessage);

// GET message
router.get("/:id", verifyTokenAndAuthorization, messageController.getAllMessage);

module.exports = router
