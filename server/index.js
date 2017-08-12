import path from 'path'
import express from 'express'
import request from 'request'
import historyApiFallback from 'connect-history-api-fallback'

require('./logger.js')

const IMAGE_PORT = 9000
const GRAPHQL_PORT = 8080
const RELAY_PORT = 3000
const RAILS_PORT = 3030

// __dirname is {projectRoot}/server, so we have to step one directory up
const pathBase = path.resolve(__dirname, '../')

const app = express()

app.use(historyApiFallback())
app.use('/', express.static(`${pathBase}/build`))

app.use('/graphql', (req, res) => {
  req.pipe(request(`http://localhost:${RAILS_PORT}/graphql`)).pipe(res)
})

if (process.env.NODE_ENV !== 'production') {
  /** ***********************************************************
   *
   * Webpack Dev Middleware with hot reload
   *
   *************************************************************/

  /* eslint-disable global-require, import/no-extraneous-dependencies */
  const webpack = require('webpack')
  const config = require('../webpack.config.js')
  const webpackDevMiddleware = require('webpack-dev-middleware')
  const webpackHotMiddleware = require('webpack-hot-middleware')
  /* eslint-enable */

  const compiler = webpack(config)
  app.use(webpackDevMiddleware(compiler, config.devServer))
  app.use(webpackHotMiddleware(compiler))
  app.use(express.static(config.output.publicPath))

  app.listen(RELAY_PORT, (err) => {
    if (err) {
      // eslint-disable-next-line no-undef
      log(err)
    } else {
      // eslint-disable-next-line no-undef
      log(`App is now running on http://localhost:${RELAY_PORT}`)
    }
  })
} else {
  /** ****************
   *
   * Express server for production
   *
   *****************/
  const host = process.env.HOST || 'localhost'
  const port = process.env.PORT || 3000

  app.listen(port, () =>
    // eslint-disable-next-line no-undef
    log('Essential React listening at http://%s:%s', host, port),
  )
}
