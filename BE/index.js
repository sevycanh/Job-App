const express = require("express");
const app = express();
const dotenv = require("dotenv");
const mongoose = require("mongoose");
const authRoute = require("./routes/auth");
const userRoute = require("./routes/user");
const jobRoute = require("./routes/job");
const bookmarkRoute = require("./routes/bookmark");
const chatRoute = require("./routes/chat");
const messageRoute = require("./routes/message");

dotenv.config();

mongoose
  .connect(process.env.MONGO_URL)
  .then(() => console.log("db connected"))
  .catch((err) => console.log(err));

app.use(express.json());
app.use("/api/", authRoute);
app.use("/api/user", userRoute);
app.use("/api/job", jobRoute);
app.use("/api/bookmark", bookmarkRoute);
app.use("/api/chats", chatRoute);
app.use("/api/messages", messageRoute);

const server = app.listen(process.env.PORT || 3001, () =>
  console.log(`Example app listening on port ${process.env.PORT}`)
);

const io = require("socket.io")(server, {
  pingTimeout: 60000,
  cors: {
    // local host
    // origin: "http://localhost:3000" or "...railway.app/"
    // hosted server
    origin: "http://localhost:3000/",
  },
});

io.on("connection", (socket) => {
  console.log("connected to sockets");

  socket.on("setup", (userId) => {
    socket.join(userId);
    socket.broadcast.emit("online-users", userId);
    // console.log("userId: ", userId);
  });

  socket.on("typing", (room) => {
    // console.log("typing");
    socket.to(room).emit("typing", room);
  });

  socket.on("stop typing", (room) => {
    // console.log("stop typing");
    socket.to(room).emit("stop typing", room);
  });

  socket.on("join chat", (room) => {
    socket.join(room);
    console.log("User Joined Room: " + room);
  });

  socket.on("new message", (newMessageReceived) => {
    var chat = newMessageReceived.chat;
    var room = chat._id;

    var sender = newMessageReceived.sender;

    if (!sender || !sender._id) {
      console.log("Sender not defined");
      return;
    }

    var senderId = sender._id;
    const users = chat.users;

    if (!users) {
      console.log("Users not defined");
      return;
    }

    socket.to(room).emit('message received', newMessageReceived);
    // socket.to(room).emit('message sent', "New Message");
  });

  socket.off('setup', ()=>{
    console.log('user offline');
    socket.leave(userId)
  })
});
