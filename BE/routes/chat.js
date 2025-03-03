const router = require("express").Router();
const chatController = require("../controllers/chatController");
const { verifyTokenAndAuthorization, verifyToken } = require("../middleware/verifyToken");

// send mess
router.post("/", verifyTokenAndAuthorization,chatController.accessChat);

// GET All mess
router.get("/", verifyTokenAndAuthorization, chatController.getChat);

module.exports = router
