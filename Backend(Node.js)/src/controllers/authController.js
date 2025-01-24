import * as  services from "../services/userServices.js";
import * as utils from "../utils/index.js";
export const register = async (req, res) => {
    const {email, username, password } = req.body;
    if(!email || !username || !password) {
        return res.status(400).json({message: "Please fill all the fields"});
    }
    const userName = username.toLowerCase();
    const checkUser = await services.findUserByUsername(userName);
    if(checkUser) {
        res.status(400).json({message: "User already exists"});
    }
    const user = await services.registerUser(email, userName, password);
    const token = await utils.generateToken(user._id);
    if(user){
        return res.status(200).json({ message: "User registered successfully", user,token })
    }
    return res.status(500).json({})
}

export const login = async (req, res) => {
    const { username, password} = req.body;
    if (!username || !password) {
        return res.status(400).json({ message: "Please enter usename and password" });
    }
    const user = await services.findUserByUsername(username);
    const compare = await utils.verifyPassword(password, user.password)
    if(!compare) {
        return res.status(400).json({message: "Passwords do not match"})
    }
    const token = await utils.generateToken(user._id);
    if(!token) {
        res.status(500).json({message:"Error generating token"})
    }

    return res.status(200).json({message: "Login successful", token})
}