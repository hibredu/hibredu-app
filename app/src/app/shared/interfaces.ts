import Student from "../entities/student.entity";

export interface IClassroomResponse {
    id: number,
    name: string,
    metrics: {
        deliveredActivities: number,
        deliveryPercentage: number,
        hitRate: number,
        alerts: number
    },
    students: Student[]
}