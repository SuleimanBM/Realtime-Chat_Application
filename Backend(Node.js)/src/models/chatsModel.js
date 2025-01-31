import mongoose from "mongoose";

const chatSchema = new mongoose.Schema({
    chatId: {
        type: String,
        required: true, // Unique identifier for the chat (e.g., user1_user2 or a generated ID)
    },
    sender: {
        type: String, // The ID of the user who sent the message
        required: true,
    },
    receiver: {
        type: String, // The ID of the user who receives the message
        required: true,
    },
    message: {
        type: String, // The content of the message
        required: true,
    },
    timestamp: {
        type: Date, // When the message was sent
        default: Date.now, // Automatically set the current time
    },
},
    {
        timestamps: true, // Adds createdAt and updatedAt fields automatically
    },
);

const Chat = mongoose.model("Chat", chatSchema);

export default Chat;