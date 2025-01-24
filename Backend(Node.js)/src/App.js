import express from "express";
import bodyParser from "body-parser";
import dotenv from "dotenv";
import http from "http";
import { Server as IO } from "socket.io";
import socketManager from "./sockets/socketManager.js";
import route from "./routers/index.js";

dotenv.config();
const app = express();

app.use(bodyParser.json());
app.use(route)
app.use("*",(req, res) => {
    res.send("Hello world!");
})
const server = http.createServer(app);

const io = new IO(server, { cors: { origin: "*",methods: ["GET", "POST"]}});

socketManager(io);

export default server;