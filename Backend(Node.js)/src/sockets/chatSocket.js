const chatSocket = (io, socket) => {
    socket.on("sendPrivateMessage", (data) => {
        const { timestamp, message, sender } = data;

        // Validate the incoming data
        if (!timestamp || !message || !sender) {
            console.error("Incomplete data received for sendPrivateMessage");
            return;
        }

        // Send the message back to the sender
        socket.emit("receivePrivateMessage", {
            timestamp,
            message,
            sender,
        });

        console.log(`Message sent back to sender (${sender}): ${message}`);
    });
    // Handle one-on-one chat: sending a message
    // socket.on('sendPrivateMessage', (data) => {
    //     // const { recipientId, message, senderId } = data;
    //     const {timestamp, message, sender} = data;
    //     // Emit the message to the recipient
    //     socket.emit("receivePrivateMessage",{timestamp, message, sender})
    //     // io.to(recipientId).emit('privateMessage', { message, senderId, timestamp: new Date() });
    //     // console.log(`Private message from ${senderId} to ${recipientId}: ${message}`);
    // });

    // Handle joining a chat room
    socket.on('joinRoom', (chatRoomId) => {
        socket.join(chatRoomId);
        console.log(`User ${socket.id} joined chat room ${chatRoomId}`);
        io.to(chatRoomId).emit('systemMessage', { message: `User ${socket.id} joined the room.` });
    });

    // Handle sending a message to a chat room
    socket.on('sendMessageToRoom', (data) => {
        const { chatRoomId, message, sender } = data;
        io.to(chatRoomId).emit('newRoomMessage', { message, sender, timestamp: new Date() });
        console.log(`Message in room ${chatRoomId} from ${sender}: ${message}`);
    });

    // Handle leaving a chat room
    socket.on('leaveRoom', (chatRoomId) => {
        socket.leave(chatRoomId);
        console.log(`User ${socket.id} left chat room ${chatRoomId}`);
        io.to(chatRoomId).emit('systemMessage', { message: `User ${socket.id} left the room.` });
    });

    // Notify users when a client disconnects
    socket.on('disconnect', () => {
        console.log(`User ${socket.id} disconnected`);
        io.emit('systemMessage', { message: `User ${socket.id} disconnected.` });
    });
};


export default chatSocket;