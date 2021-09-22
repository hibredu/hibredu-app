import { Router } from "express"
import authMiddleware from "../../infrastructure/middleware/auth.middleware"
import alertRouter from "./alerts.routes"
import attendanceRouter from "./attendance.routes"
import authRouter from "./auth.routes"
import classroomRouter from "./classroom.routes"
import overviewRouter from "./overview.routes"
import schoolRouter from "./school.routes"
import studentRouter from "./student.routes"
import subjectRouter from "./subjects.routes"
import teacherRouter from "./teacher.routes"

const router = Router()

router.use("/", authRouter)
router.use("/school", schoolRouter)
router.use("/subject", subjectRouter)

router.use(authMiddleware);

router.use("/student", studentRouter)
router.use("/alert", alertRouter)
router.use("/attendance", attendanceRouter)
router.use("/classroom", classroomRouter)
router.use("/teacher", teacherRouter)
router.use("/overview", overviewRouter)

export default router