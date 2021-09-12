import pino from 'pino'

export default pino({
    enabled: true,
    level: 'info',
    prettyPrint: {
        levelFirst: true,
        colorize: true
    },
    timestamp: () => `,"time":"${new Date(Date.now()).toISOString()}"`
})