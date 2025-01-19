import userSocket from './userSocket.js';
import chatSocket from './chatSocket.js';
import { Server } from "socket.io"
const socketManager = (io) => {
    io.on('connection', (socket) => {
        console.log(`User connected: ${socket.id}`);

        // Attach specific socket event handlers
        chatSocket(io, socket);
        userSocket(io, socket);

        socket.on('disconnect', () => {
            console.log(`User disconnected: ${socket.id}`);
        });
    });
};

export default socketManager;
