import { Options, diskStorage } from 'multer'
import { resolve } from 'path'
import { randomBytes } from 'crypto'

export const multerConfig = {
    dest: resolve(__dirname, '..', '..', '..', '..', 'uploads'),
    storage: diskStorage({
        destination: (request, file, callback) => {
            callback(null, resolve(__dirname, '..', '..', '..', '..', 'uploads'))
        },
        filename: (request, file, callback) => {
            randomBytes(16, (error, hash) => {
                if (error) {
                    callback(error, file.filename)
                }
                const filename = `${hash.toString('hex')}`
                callback(null, filename)
            })
        }
    }),
    limits: {
        fileSize: 10 * 1024 * 1024 // 5MB
    },
    fileFilter: (request, file, callback) => {
        const formats = [
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            'text/csv'
        ];

        if (formats.includes(file.mimetype)) {
            callback(null, true)
        } else {
            callback(new Error('Format not accepted'))
        }
    }
} as Options