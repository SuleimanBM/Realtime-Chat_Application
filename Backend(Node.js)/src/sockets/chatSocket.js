import { verifyToken } from "../utils/index.js";
import Chat from "../models/chatsModel.js"
import { findUserBy } from "../services/userServices.js";

const chatSocket = async (io, socket) => {
    const token = socket.handshake.query.token;
    const user = await verifyToken(token)
    
    socket.on("message:send", async ({ receiverId, message }) => {
        const senderId = user.id;
        const chatId = [user.id, receiverId].sort().join("_"); // Ensure consistent chatId
        try {
            // Save message to the database
            const newMessage = await Chat.create({
                chatId: chatId,
                sender: senderId,
                receiver: receiverId,
                content: message,
                createdAt: new Date(),
            });

            // Find the receiver in the database
            const receiver = await User.findById(receiverId);
            if (!receiver) {
                console.log("Receiver not found");
                return;
            }

            const receiverSocket = receiver.socketId;

            if (receiverSocket) {
                // Emit the message to the receiver's socket
                io.to(receiverSocket).emit("message:receive", newMessage);
            } else {
                // Optional: Handle offline receivers (e.g., store for notifications)
                console.log("Receiver is offline");
            }

            // Update chat metadata (e.g., last message)
            // await Chat.findOneAndUpdate(
            //     { _id: chatId },
            //     {
            //         lastMessage: message,
            //         lastMessageAt: new Date(),
            //     },
            //     { upsert: true } // Create the chat document if it doesn't exist
            // );
        } catch (error) {
            console.error("Error sending message:", error);
            // Optional: Emit error back to the sender
            socket.emit("message:error", { error: "Failed to send message" });
        }
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