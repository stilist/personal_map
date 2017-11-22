var path = require('path')
var webpack = require('webpack')
const ExtractTextPlugin = require('extract-text-webpack-plugin')

module.exports = {
  entry: './src/application.js',
  output: {
    filename: 'application.js',
    path: path.resolve(__dirname, 'public', 'assets'),
    pathinfo: true,
    publicPath: '/assets/',
  },

  module: {
    rules: [{
      test: /\.css$/,
      use: ExtractTextPlugin.extract({
        fallback: 'style-loader',
        use: 'css-loader',
      }),
    }, {
      test: /\.(gif|jpe?g|png)$/,
      loader: 'file-loader',
    }, {
      test: /\.json$/,
      use: [{
        loader: 'url-loader',
        options: {
          limit: 1,
        },
      }],
    }],
  },
  plugins: [
    new ExtractTextPlugin('application.css'),
    // @see https://gist.github.com/Couto/b29676dd1ab8714a818f#gistcomment-2110690
    new webpack.ProvidePlugin({
      'window.fetch': 'imports-loader?this=>global!exports-loader?global.fetch!whatwg-fetch',
    }),
  ],
}
