import React from 'react'
import PropTypes from 'prop-types'
import { createFragmentContainer, graphql } from 'react-relay'
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider'
import MenuItem from 'material-ui/MenuItem'

import LogoutMutation from '../../mutation/LogoutMutation'

function onLogout(environment) {
  LogoutMutation.commit({
    environment,
    onCompleted: () =>
      // eslint-disable-next-line no-undef
      location.assign(`${location.protocol}//${location.host}`),
    onError: errors => console.error('logout failed', errors[0]),
  })
}

const NavigationUserMenu = ({ viewer, navigateTo, relay }) => {
  const {
    canPublish,
    isLoggedIn,
  } = viewer || {}

  if (canPublish) {
    return (
      <MuiThemeProvider>
        <span>
          <MenuItem onClick={() => navigateTo('/user')}>
            Profile
          </MenuItem>

          <MenuItem onClick={() => navigateTo('/user/post/create')}>
            Create Post
          </MenuItem>

          <MenuItem onClick={() => navigateTo('/user/posts')}>
            My Posts
          </MenuItem>

          <MenuItem onClick={() => onLogout(relay.environment)}>
            Logout
          </MenuItem>
        </span>
      </MuiThemeProvider>
    )
  } else if (isLoggedIn) {
    return (
      <MuiThemeProvider>
        <span>
          <MenuItem onClick={() => navigateTo('/user')}>
            Profile
          </MenuItem>

          <MenuItem onClick={() => onLogout(relay.environment)}>
            Logout
          </MenuItem>
        </span>
      </MuiThemeProvider>
    )
  }

  return (
    <MuiThemeProvider>
      <MenuItem onClick={() => navigateTo('/login')}>Login</MenuItem>
    </MuiThemeProvider>
  )
}

NavigationUserMenu.propTypes = {
  relay: PropTypes.shape({
    environment: PropTypes.any.isRequired,
  }).isRequired,
  navigateTo: PropTypes.func.isRequired,
  viewer: PropTypes.shape({
    isLoggedIn: PropTypes.bool,
    canPublish: PropTypes.bool,
  }),
}

NavigationUserMenu.defaultProps = {
  viewer: {},
}

export default createFragmentContainer(
  NavigationUserMenu,
  graphql`
    fragment NavigationUserMenu_viewer on Viewer {
      isLoggedIn
      canPublish
    }
  `,
)
