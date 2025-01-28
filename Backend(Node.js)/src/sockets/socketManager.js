import userSocket from './userSocket.js';
import chatSocket from './chatSocket.js';
import { Server } from "socket.io"
const socketManager = (io) => {
    io.on('connection', (socket) => {
        console.log(`User connected: ${socket.id}`);
        const token = socket.handshake.query.token;
        console.log("extracted token in socketManager ",token);
        // Attach specific socket event handlers
        userSocket(io, socket);
        chatSocket(io, socket);

        socket.on('disconnect', () => {
            console.log(`User disconnected: ${socket.id}`);
        });
    });
};

export default socketManager;
