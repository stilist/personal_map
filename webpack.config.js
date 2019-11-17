var path = require('path')

module.exports = {
  entry: [
    'whatwg-fetch',
    './src/application.js',
  ],
  output: {
    filename: 'application.js',
    path: path.resolve(__dirname, 'public', 'assets'),
    pathinfo: true,
    publicPath: '/assets/',
  },
  mode: 'development',

  module: {
    rules: [{
      test: /\.css$/,
      use: [
        'style-loader',
        'css-loader',
      ],
    }, {
      test: /\.(gif|jpe?g|png)$/,
      loader: 'file-loader',
    }, {
      test: /\.json$/,
      loader: 'url-loader',
      type: 'javascript/auto',
      options: {
        limit: 1,
      },
    }],
  },
}
