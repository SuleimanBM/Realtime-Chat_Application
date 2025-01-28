const mongoose = require("mongoose");

const chatSchema = new mongoose.Schema({
        type: {
            type: String,
            required: true,
            default: "private",
            enum: ["private", "group"]
        },
        members: [],
        name: {
            type: String,
        },
        admin: {
            type: String,
        }, // For sorting chats
});

const Chat = mongoose.model("Chat", chatSchema);

module.exports = Chat;