const userSocket = (io, socket) => {
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