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

function commit({ environment, input, files, onCompleted, onError }) {
  const variables = { input }
  const uploadables = (files === undefined) ? {} : { image: files.item(0) }

  commitMutation(environment, {
    mutation,
    variables,
    uploadables,
    onCompleted,
    onError,
  })
}

export default {
  commit,
}
