import { Router } from "express"
import authRouter from "./auth.routes"
import studentRouter from "./student.routes"

const router = Router()

router.use("/", authRouter)
router.use("/student", studentRouter)

export default router