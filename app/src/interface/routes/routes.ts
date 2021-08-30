import { Router } from "express"
import authRouter from "./auth.routes"
import classroomRouter from "./classroom.routes"
import studentRouter from "./student.routes"

const router = Router()

router.use("/", authRouter)
router.use("/student", studentRouter)
router.use("/classroom", classroomRouter)

export default router