import * as  services from "../services/userServices.js";


export const searchUsers = async (req, res) => {
    const {username} = req.body;
    const user = await services.searchByUsername(username);
    if(user) {
        return res.status(200).json({message: "User found", user})
    }
    return res.status(404).json({message: "User not found"});
}