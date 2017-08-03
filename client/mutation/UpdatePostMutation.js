import { commitMutation, graphql } from 'react-relay'

const mutation = graphql`
  mutation UpdatePostMutation($input: UpdatePostInput!) {
    updatePost(input: $input) {
      post {
        id
        title
        description
        image
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
