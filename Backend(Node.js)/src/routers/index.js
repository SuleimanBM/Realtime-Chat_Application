import { Router } from "express"
import authRouter from "./authRouter.js"
import chatRouter from "./chatRouter.js";

const router = Router()

router.use("/auth", authRouter)
router.use("/chat", chatRouter)

export default router;