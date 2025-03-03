const Message = require("../models/Message");
const User = require("../models/User");
const Chat = require("../models/Chat");

module.exports = {
  getAllMessage: async (req, res) => {
    try {
      const pageSize = 15; //Number of messages per page
      const page = req.query.page || 1; //Current page number

      // Calculate the of messages to skip
      const skipMessages = (page - 1) * pageSize;

      // Find messages with pagination
      var messages = await Message.find({ chat: req.params.id })
        .populate("sender", "username profile email")
        .populate("chat")
        .sort({ updatedAt: -1 }) //Sort message by descending order
        .skip(skipMessages) // Skip messages based on pagination
        .limit(pageSize); //Limit the number of messages par page

      messages = await User.populate(messages, {
        path: "chat.users",
        select: "username profile email",
      });

      console.log(messages);

      res.json(messages);
    } catch (error) {
      res.status(500).json({ error: "Could not retrieve messages" });
    }
  },

  sendMessage: async (req, res) => {
    const { content, chatId, receiver } = req.body; // giống như lấy key

    if (!content || !chatId) {
      console.log("Invalid Data");
      return res.status(400).json("Invalid data");
    }

    var newMessage = {
      sender: req.user.id,
      content: content,
      receiver: receiver,
      chat: chatId,
    };

    try {
      var message = await Message.create(newMessage);
      message = await message.populate("sender", "username profile email");
      message = await message.populate("chat");
      message = await User.populate(message, {
        path: "chat.users",
        select: "username profile email",
      });

      await Chat.findByIdAndUpdate(req.body.chatId, { latestMessage: message });
      res.json(message);
    } catch (error) {
      res.status(400).json({ error: error });
    }
  },
};
