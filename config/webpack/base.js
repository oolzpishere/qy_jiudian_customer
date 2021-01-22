const {webpackConfig, merge} = require('@rails/webpacker')

const customConfig = require('./custom')

console.log("webpackConfig: " + webpackConfig)
console.log("merge: " + merge)

module.exports = merge(webpackConfig, customConfig)
