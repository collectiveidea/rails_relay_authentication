/* eslint-disable import/no-extraneous-dependencies, global-require */
const webpack = require('webpack')
const path = require('path')
const ExtractTextPlugin = require('extract-text-webpack-plugin')

const publicPath = '/'

let appEntry
let plugins
let devServer
let devtool

if (process.env.PRODUCTION) {
  console.log('Running in production mode')
  
  appEntry = [path.resolve(__dirname, 'client')]
  devtool = 'source-map'
  plugins = [
    new webpack.optimize.OccurrenceOrderPlugin(),
    new webpack.optimize.CommonsChunkPlugin({name: 'vendor', filename: 'vendor.js'}),
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: JSON.stringify('production')
      }
    }),
    new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false,
        screw_ie8: true
      }
    }),
    new ExtractTextPlugin('[name].css')
  ]
  devServer = {}
} else {
  appEntry = [
    'webpack/hot/dev-server',
    'webpack-hot-middleware/client',
    path.resolve(__dirname, 'client'),
  ]

  plugins = [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoEmitOnErrorsPlugin(),
    new ExtractTextPlugin('[name].css'),
  ]

  devServer = {
    noInfo: false,
    publicPath,
    quiet: false,
    hot: true,
    stats: {
      assets: false,
      chunkModules: false,
      chunks: false,
      colors: true,
      hash: false,
      timings: false,
      version: false,
    },
    historyApiFallback: true,
  }

  devtool = 'eval'
}

module.exports = {
  devtool,
  entry: {
    app: appEntry,
  },
  output: {
    path: path.resolve(__dirname, 'build'),
    filename: '[name].js',
    publicPath,
  },
  resolve: {
    extensions: ['.js', '.jsx', '.css'],
  },
  devServer,
  plugins,
  module: {
    loaders: [
      {
        test: /\.jsx?$/,
        exclude: /node_modules/,
        loaders: ['babel-loader'],
      },
      {
        test: /\.css$/,
        loader: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: [
            'css-loader?modules&importLoaders=1&localIdentName=[name]__[local]___[hash:base64:5]',
            {
              loader: 'postcss-loader',
              options: {
                plugins: () => [
                  require('autoprefixer'), // Automatically include vendor prefixes
                  require('postcss-nested'), // Enable nested rules, like in Sass
                ],
              },
            },
          ],
        }),
      },
      {
        test: /\.js$/,
        loader: 'eslint-loader',
        exclude: /node_modules/,
        query: {
          configFile: './.eslintrc',
        },
      },
    ],
  },
}
