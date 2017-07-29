/* eslint-disable */

import React from 'react'
import PropTypes from 'prop-types'
import { routerShape } from 'found/lib/PropTypes'
import { createFragmentContainer, graphql } from 'react-relay'
import Formsy from 'formsy-react'
import { FormsyText } from 'formsy-material-ui'
import RaisedButton from 'material-ui/RaisedButton'

import ResetPasswordMutation from '../../mutation/ResetPasswordMutation'
import { ERRORS } from '../../../config'

import styles from './Login.css'

class ResetPasswordPage extends React.Component {
  static propTypes = {
    router: routerShape.isRequired,
    relay: PropTypes.shape({
      environment: PropTypes.any.isRequired,
    }).isRequired,
    viewer: PropTypes.shape({
      isLoggedIn: PropTypes.bool,
    }).isRequired,
  }

  setFormElement = (element) => {
    this.formElement = element
  }

  resetPassword = ({ newPassword }) => {
    const environment = this.props.relay.environment
    ResetPasswordMutation.commit({
      environment,
      input: { newPassword, token: this.props.params.token },
      onCompleted: () => this.props.router.go(-1),
      onError: (errors) => {
        console.error('password reset failed', errors[0])
        const formError = {}
        switch (errors[0]) {
          case ERRORS.WrongEmailOrPassword:
            formError.newPassword = 'Password is invalid'
            break
          default:
            break
        }
        this.formElement.updateInputsWithError(formError)
      },
    })
  }

  render() {
    const viewer = this.props.viewer
    if (viewer.isLoggedIn) {
      this.props.router.push('/')
      return <div />
    }

    const submitMargin = { marginTop: 20 }

    return (
      <div className={styles.content}>
        <h2>Create a New Password</h2>

        <div className={styles.hint}>
          Enter your new password.
        </div>

        <Formsy.Form
          ref={this.setFormElement}
          onSubmit={this.resetPassword}
          className={styles.form}
        >

          <FormsyText
            name="newPassword"
            type="password"
            validations="minLength:8"
            validationError="Your password must be at least 8 characters long."
            floatingLabelText="Password"
            fullWidth
          />

          <FormsyText
            name="confirmPassword"
            type="password"
            floatingLabelText="Confirm Password"
            validations="equalsField:newPassword"
            validationError="Passwords must match."
            fullWidth
          />

          <RaisedButton
            type="submit"
            label="Submit"
            secondary
            fullWidth
            style={submitMargin}
          />

        </Formsy.Form>
      </div>
    )
  }
}

export default createFragmentContainer(
  ResetPasswordPage,
  graphql`
    fragment ResetPassword_viewer on Viewer {
      isLoggedIn
    }
  `,
)
