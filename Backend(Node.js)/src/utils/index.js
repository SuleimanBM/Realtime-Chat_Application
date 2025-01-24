import bcrypt from "bcrypt";
import jsonwebtoken from "jsonwebtoken"
import createHttpError from "http-errors";

export const hashPassword = async (password) => {
    const hash = await bcrypt.hash(password, 16);
    return hash;
}

export const verifyPassword = async (inputPassword,storedPassword) => {
    const compare = await bcrypt.compare(inputPassword, storedPassword);
    return compare;
}

export const generateToken = async (id) => {
    const token = jsonwebtoken.sign({ id }, process.env.JWT_SECRET, {
        expiresIn: "15d",
    });
    return token;
}

