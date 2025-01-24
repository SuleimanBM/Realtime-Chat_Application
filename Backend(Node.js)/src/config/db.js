import mongoose from 'mongoose';
import dotenv from 'dotenv';

dotenv.config();

// Connect to MongoDB using mongoose.connect
const connectDB = async () => {
    try {
        const conn = await mongoose.connect(process.env.DATABASE_URL); // No deprecated options
        console.log(`Database connected successfully`);
    } catch (error) {
        console.error('Database connection error:', error);
        process.exit(1); // Exit process with failure
    }
};

// Call the connection function
connectDB();

export default mongoose.connection;
