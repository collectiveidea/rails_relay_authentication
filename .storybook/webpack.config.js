const path = require('path');

module.exports = {
  module: {
    rules: [
      {
        test: /\.css$/,
        use: [
          'style-loader',
          {
            loader: 'css-loader',
            options: {
              modules: true,
              importLoaders: 1,
              localIdentName: "[name]__[local]___[hash:base64:5]",
            }
          },
          {
            loader: 'postcss-loader',
            options: {
              plugins: () => [
                require('autoprefixer'), // Automatically include vendor prefixes
                require('postcss-nested'), // Enable nested rules, like in Sass
              ]
            }
          }
        ],
        include: path.resolve(__dirname, '../')
      }
    ]
  }
}
