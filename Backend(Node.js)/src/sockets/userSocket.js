import { verifyToken } from "../utils/index.js";
import { findByIdAndUpdate } from "../services/userServices.js";

const userSocket = (io, socket) => {

    const token = socket.handshake.query.token;
    //console.log("Extracted token from connection", token);
    const user = verifyToken(token)
    console.log("verified token in userSocket", user);
    const updateUser = findByIdAndUpdate(user.id, socket.id)
    // Track user online status
    socket.on('userOnline', (userId) => {
        console.log(`User ${userId} is online`);
        io.emit('onlineUsers', { userId, status: 'online' });
    });

    // Track user offline status
    socket.on('disconnect', () => {
        console.log(`User ${socket.id} disconnected`);
        io.emit('onlineUsers', { userId: socket.id, status: 'offline' });
    });

    // Typing indicator
    socket.on('typing', (chatRoomId) => {
        socket.to(chatRoomId).emit('userTyping', { userId: socket.id });
    });
};

export default userSocket;