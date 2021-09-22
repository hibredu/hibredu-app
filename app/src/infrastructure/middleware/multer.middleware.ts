import { Options, diskStorage } from 'multer'
import { resolve } from 'path'
import { randomBytes } from 'crypto'
import multerS3 from 'multer-s3'
import aws from 'aws-sdk'

const MAX_SIZE_FIVE_MEGABYTES = 5 * 1024 * 1024;

const storageTypes = {
    local: diskStorage({
      destination: (req, file, callback) => {
        callback(null, resolve(__dirname, '..', '..', '..', '..', 'tmp', 'uploads'));
      },
      filename: (req, file, callback) => {
        randomBytes(16, (err, hash) => {
          if (err) {
            callback(err, file.filename);
          }
  
          const filename = `${hash.toString("hex")}-${file.originalname}`;
          callback(null, filename);
        });
      },
    }),
    s3: multerS3({
      s3: new aws.S3({
        accessKeyId: process.env.AWS_ACCESS_KEY_ID,
        secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
      }),
      bucket: process.env.BUCKET_NAME,
      contentType: multerS3.AUTO_CONTENT_TYPE,
      key: (req, file, callback) => {
        randomBytes(16, (err, hash) => {
          if (err) {
              callback(err, file.filename)
          }
  
          const fileName = `${hash.toString("hex")}-${file.originalname}`;
          callback(null, fileName);

        });
      },
    }),
  };

export const multerConfig = {
    dest: resolve(__dirname, '..', '..', '..', '..', 'tmp', 'uploads'),
    storage: storageTypes[process.env.STORAGE_TYPE],
    limits: {
        fileSize: MAX_SIZE_FIVE_MEGABYTES
    },
    fileFilter: (request, file, callback) => {
        const formats = [
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            //AINDA NÃO SERÁ PERMITIDO -> 'text/csv' 
        ];

        if (formats.includes(file.mimetype)) {
            callback(null, true)
        } else {
            callback(new Error('Format not accepted'))
        }
    }
} as Options