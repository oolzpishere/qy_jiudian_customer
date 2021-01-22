process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const webpackConfig = require('./base')

console.log(webpackConfig)
console.log("###################webpackConfig.module.rules:")
console.log(webpackConfig.module.rules)

module.exports = webpackConfig
