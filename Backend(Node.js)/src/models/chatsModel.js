const mongoose = require("mongoose");

const chatSchema = new mongoose.Schema({
    
        type: {
            type: String,
            required: true,
            default: "private",
            enum: ["private", "group"]
        }, // or "group"
        participants: [], // For private chats
        "groupName": "Developers Group", // For group chats
        "admin": ["userId1"], // For group chats
        "lastMessage": "Hey, how are you?", // For preview
        "lastMessageAt": "2025-01-24T10:30:00Z" // For sorting chats
    
});

const Chat = mongoose.model("Chat", chatSchema);

module.exports = Chat;