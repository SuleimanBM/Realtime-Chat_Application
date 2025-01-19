import * as  services from "../services/userServices.js";
export const register = async (req, res) => {
    const {email, username, password } = req.body;
    if(!email || !username || !password) {
        return res.status(400).json({message: "Please fill all the fields"});
    }
    username = username.toLowerCase();
    user = await services.registerUser(email, username, password);
}