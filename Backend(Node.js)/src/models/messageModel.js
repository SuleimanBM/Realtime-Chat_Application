const mongoose = require("mongoose");

const messageSchema = new mongoose.Schema({
    sender: { type: String, required: true },
    receiver: { type: String, required: true },  // User who sent the message
    message: { type: String, required: true }, // Message content
    timestamp: { type: Date, default: Date.now }, // When the message was sent
});

const Message = mongoose.model("Message", messageSchema);

module.exports = Message;
