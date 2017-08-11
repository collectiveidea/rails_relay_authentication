import React from 'react'
import PropTypes from 'prop-types'
import { routerShape } from 'found/lib/PropTypes'
import { createFragmentContainer, graphql } from 'react-relay'
import RaisedButton from 'material-ui/RaisedButton'
import styles from './PostDetail.css'

import DeletePostMutation from '../../mutation/DeletePostMutation'

class PostDetail extends React.Component {
  static propTypes = {
    router: routerShape.isRequired,
    relay: PropTypes.shape({
      environment: PropTypes.any.isRequired,
    }).isRequired,
    viewer: PropTypes.shape({
      post: PropTypes.shape({
        id: PropTypes.string.isRequired,
        title: PropTypes.string.isRequired,
        description: PropTypes.string.isRequired,
        image: PropTypes.string.isRequired,
        creator: PropTypes.shape({
          firstName: PropTypes.string.isRequired,
          lastName: PropTypes.string.isRequired,
        }).isRequired,
      }),
    }).isRequired,
  }

  deletePost = () => {
    const post = this.props.viewer.post
    const environment = this.props.relay.environment

    DeletePostMutation.commit({
      environment,
      input: { id: post.id },
      onCompleted: () => this.props.router.push('/user/posts'),
      onError: errors => console.error('Deleting post Failed', errors[0]),
    })
  }

  render() {
    const { viewer } = this.props
    const deleteButton = viewer.canPublish ? <div><RaisedButton label="Delete" onClick={this.deletePost} primary /></div> : null

    return (
      <div>
        <img
          className={styles.image}
          src={viewer.post.image}
          alt={viewer.post.title}
        />

        <div className={styles.container}>
          <h1 className={styles.title}>{viewer.post.title}</h1>
          <div className={styles.user}>
            by {viewer.post.creator.firstName} {viewer.post.creator.lastName}
          </div>

          <div>{viewer.post.description}</div>

          {deleteButton}
        </div>
      </div>
    )
  }
}

const container = createFragmentContainer(
  PostDetail,
  graphql`
    fragment PostDetail_viewer on Viewer {
      canPublish
      post (postId: $postId) {
        id
        title
        description
        image
        creator {
          firstName
          lastName
        }
      }
    }
  `,
)

export default container
