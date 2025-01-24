import User from "../models/userModel.js";
import  { hashPassword, verifyPassword}from "../utils/index.js";
import createHttpError from "http-errors";

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