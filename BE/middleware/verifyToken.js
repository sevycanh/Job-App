const User = require("../models/User");
const jwt = require("jsonwebtoken");

const verifyToken = (req, res, next) => {
  const authHeader = req.headers.token;

  if (authHeader) {
    const token = authHeader.split(" ")[1];
    //Bearer cccccccccccjz
    jwt.verify(token, process.env.JWT_SEC, async (err, user) => { // user => data
      if (err) res.status(403).json("Invalid token");
      req.user = user;
      console.log("User info:", user);
      next();
    });
  } else {
    return res.status(401).json("You are not authenticated");
  }
};

const verifyTokenAndAuthorization = (req, res, next) => {
  verifyToken(req, res, () => {
    if (req.user.id || req.user.isAdmin) {
      next();
    } else {
      res.status(403).json("You are restricted from performing this operation");
    }
  });
};

const verifyTokenAndAdmin = (req, res, next) => {
  verifyToken(req, res, () => {
    if (req.user.isAdmin) {
      next();
    } else {
      res.status(403).json("You are restricted from performing this operation");
    }
  });
};

const verifyAndAuthorization = (req, res, next) => {
  verifyToken(req, res, () => {
    if (req.user.id === req.params.id) {
      console.log("Ok1");
      next();
    } else {
      res.status(403).json("You are restricted from performing this operation");
    }
  });
};

const verifyAndAdmin = (req, res, next) => {
    verifyToken(req, res, () => {
      if (req.user.isAdmin) {
        console.log("Ok_Admin");
        next();
      } else {
        res.status(403).json("You are restricted from performing this operation");
      }
    });
  };

module.exports = { verifyToken, verifyAndAuthorization, verifyAndAdmin, verifyTokenAndAdmin, verifyTokenAndAuthorization };
