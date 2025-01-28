import User from "../models/userModel.js";
import  { hashPassword, verifyPassword}from "../utils/index.js";
import createHttpError from "http-errors";
import Fuse from "fuse.js";

export const registerUser = async (email, username, password) => {
    password = await hashPassword(password);
    const user = await User.create({ email, username, password });
    if (!user){
        throw new createHttpError.InternalServerError("Failed to register user");
    }
    return user.save();
}

export const findUserByUsername = async (username) => {
    const user = await User.findOne({ username: username});
    if (!user){
        throw new createHttpError.NotFound("User not found");
    }
    return user;

}

export const searchByUsername = async (username) => {
    // Fetch all users first (you can optimize by limiting the result size)
    const allUsers = await User.find();

    // Set up Fuse.js with options
    const fuse = new Fuse(allUsers, {
        keys: ['username'], // Field to search in
        threshold: 0.3,     // Similarity threshold (lower = stricter match)
    });

    // Perform a fuzzy search
    const result = fuse.search(username);

    if (!result.length) {
        throw new createHttpError.NotFound("No similar usernames found");
    }

    // Map results to their original user objects
    return result.map((r) => r.item);
}

export const findByIdAndUpdate = async (id,socketId) => {
    const user = await User.findByIdAndUpdate(id, {socketId: socketId});
    if (!user){
        throw new createHttpError.NotFound()
    }
    return user;
}