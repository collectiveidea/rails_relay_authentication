import React from 'react';
import { storiesOf } from '@storybook/react';
import { action } from '@storybook/addon-actions';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider'
import NavigationUserMenu from './../client/components/navigation/NavigationUserMenu';
import LoginPage from './../client/pages/user/Login';
import StubContainer from "react-storybooks-relay-container"

storiesOf('Button', module)
  .add('with text', () => (
    <button onClick={action('clicked')}>Hello Button</button>
  ))
  .add('with some emoji', () => (
    <button onClick={action('clicked')}>😀 😎 👍 💯</button>
  ));

storiesOf('LoginPage', module)
  .addDecorator(story => (
    <MuiThemeProvider>
      <div>
        <div id="container">
          {story()}
        </div>
      </div>
    </MuiThemeProvider>
  ))

  .add('not logged in', () => {
    const props = {
      viewer: {
        isLoggedIn: false
      }
    }

    return <StubContainer Component={LoginPage} props={props} />
  })

storiesOf('NavigationUserMenu', module)
  .addDecorator(story => (
    <MuiThemeProvider>
      {story()}
    </MuiThemeProvider>
  ))

  .add('can publish', () => {
    const props = {
      viewer: {
        canPublish: true,
        isLoggedIn: true
      },
      navigateTo: (target) => action(target)
    }

    return <StubContainer Component={NavigationUserMenu} props={props} />
  })
  .add('cannot publish', () => {
    const props = {
      viewer: {
        canPublish: false,
        isLoggedIn: true
      },
      navigateTo: (target) => action(target)
    }

    return <StubContainer Component={NavigationUserMenu} props={props} />
  })
  .add('is not logged in', () => {

    const props = {
      viewer: {},
      navigateTo: (target) => action(target)
    }
    return <StubContainer Component={NavigationUserMenu} props={props} />
  });
