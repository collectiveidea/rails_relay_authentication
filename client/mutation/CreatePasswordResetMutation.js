import { commitMutation, graphql } from 'react-relay'

const mutation = graphql`
  mutation CreatePasswordResetMutation($input: CreatePasswordResetInput!) {
    createPasswordReset(input: $input) {
      user {
        id
      }
    }
  }
`

function commit({ environment, input, onCompleted, onError }) {
  const variables = { input }

  commitMutation(environment, {
    mutation,
    variables,
    onCompleted,
    onError,
  })
}

export default {
  commit,
}
