var path = require('path')
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
    }],
  },
  plugins: [
    new ExtractTextPlugin('application.css'),
  ],
}
