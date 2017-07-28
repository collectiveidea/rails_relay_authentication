/* eslint-disable */

import React from 'react'
import PropTypes from 'prop-types'
import { routerShape } from 'found/lib/PropTypes'
import { createFragmentContainer, graphql } from 'react-relay'
import Formsy from 'formsy-react'
import { FormsyText } from 'formsy-material-ui'
import RaisedButton from 'material-ui/RaisedButton'

import ForgotPasswordMutation from '../../mutation/ForgotPasswordMutation'
import { ERRORS } from '../../../config'

import styles from './Login.css'

class ForgotPasswordPage extends React.Component {
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

  forgotPassword = ({ email }) => {
    const environment = this.props.relay.environment
    ForgotPasswordMutation.commit({
      environment,
      input: { email },
      onCompleted: () => this.props.router.go(-1),
      onError: (errors) => {
        console.error('login failed', errors[0])
        const formError = {}
        switch (errors[0]) {
          case ERRORS.WrongEmailOrPassword:
            formError.email = 'Email is invalid'
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
        <h2>Reset Password</h2>

        <div className={styles.hint}>
          Enter your email address and we'll send you a link to reset your password.
        </div>

        <Formsy.Form
          ref={this.setFormElement}
          onSubmit={this.forgotPassword}
          className={styles.form}
        >

          <FormsyText
            name="email"
            floatingLabelText="E-Mail"
            fullWidth
            validations="isEmail"
            validationError="Please enter a valid email address"
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
  ForgotPasswordPage,
  graphql`
    fragment ForgotPassword_viewer on Viewer {
      isLoggedIn
    }
  `,
)
