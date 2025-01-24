import mongoose from "mongoose";
import db from "../config/db.js"


const userSchema = new mongoose.Schema({
    email: {
        type: String,
        required: true,
        unique: true,
    },
    username: {
        type: String,
        required : true,
        unique: true,
    },
    password: {
        type: String,
        required: true
    },
    socketId: {
        type: String,
    },
    // status:{
    //     type: String,
    // },
    // lastSeen: {
    //     type: Date,
    // }
})

const UserModel = db.model('user', userSchema)

export default UserModel;