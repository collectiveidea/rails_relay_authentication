/* eslint-disable no-console */
const chalk = require('chalk')
const fetch = require('node-fetch')
const fs = require('fs')
const {
  buildClientSchema,
  introspectionQuery,
  printSchema,
} = require('graphql/utilities')
const path = require('path')
const GRAPHQL_PORT = 8080
const RAILS_PORT = 3030
const SERVER = `http://localhost:${RAILS_PORT}/graphql`
const schemaPath = path.join(__dirname, '../server/graphql/schema')

async function updateSchema() {
  try {
    // Save JSON of full schema introspection for Babel Relay Plugin to use
    fetch(SERVER, {
      method: 'POST',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ query: introspectionQuery }),
    }).then(res => res.json()).then((schemaJSON) => {
      fs.writeFileSync(
        `${schemaPath}.json`,
        JSON.stringify(schemaJSON, null, 2)
      )

      // Save user readable type system shorthand of schema
      const graphQLSchema = buildClientSchema(schemaJSON.data)
      fs.writeFileSync(
        `${schemaPath}.graphql`,
        printSchema(graphQLSchema)
      )
    })
    console.log(chalk.green('Schema has been regenerated'))
  } catch (err) {
    console.error(chalk.red(err.stack))
  }
}

// Run the function directly, if it's called from the command line
if (!module.parent) updateSchema()

export default updateSchema
