require('dotenv').config();

const webpack = require('webpack');

module.exports = {
  plugins: [
    new webpack.DefinePlugin({
      API_TOKEN: JSON.stringify(process.env.API_TOKEN),
      CHAT_ID: JSON.stringify(process.env.CHAT_ID)
    })
  ]
}
