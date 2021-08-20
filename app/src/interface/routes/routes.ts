import { Router } from "express"
import studentRouter from "./student.routes"

const router = Router()

router.use("/student", studentRouter)

export default router