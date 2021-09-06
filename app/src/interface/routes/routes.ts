import { Router } from "express"
import authRouter from "./auth.routes"
import classroomRouter from "./classroom.routes"
import studentRouter from "./student.routes"
import teacherRouter from "./teacher.routes"

const router = Router()

router.use("/", authRouter)
router.use("/student", studentRouter)
router.use("/classroom", classroomRouter)
router.use("/teacher", teacherRouter)

export default router