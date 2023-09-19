const settings = require("./../config/settings")
const axios = require('axios')
const cheerio = require('cheerio')
const { DynamoDb } = require('./factory')
const { randomUUID } = require('node:crypto')
const { PutItemCommand } = require("@aws-sdk/client-dynamodb")

class Handler {
  static async main(event) {
    console.log('at', (new Date()).toISOString(), JSON.stringify(event, null, 2))

    const { data } = await axios.get(settings.API_COMMIT_MESSAGE_URL)

    const $ = cheerio.load(data);
    const [ commitMessage ] = $('#content').text().trim().split('\n')

    console.log( { commitMessage})

    const params = {
      TableName: settings.DB_TABLE_NAME,
      Item: {
        commitMessage: {
          S: commitMessage
        },
        id: {
          S: randomUUID()
        },
        createdAt: {
          S: (new Date()).toISOString()
        }
      }
    }

    const prepare = new PutItemCommand(params)

    await DynamoDb.send(prepare)
    console.log('process finished at', (new Date()).toISOString())

    return {
      statusCode: 200
    }
  }
}

module.exports = {
  scheduler: Handler.main
}
