import React from 'react';
import { storiesOf } from '@storybook/react';
import { action } from '@storybook/addon-actions';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider'
import NavigationUserMenu from './../client/components/navigation/NavigationUserMenu';
import StubContainer from "react-storybooks-relay-container"

storiesOf('Button', module)
  .add('with text', () => (
    <button onClick={action('clicked')}>Hello Button</button>
  ))
  .add('with some emoji', () => (
    <button onClick={action('clicked')}>😀 😎 👍 💯</button>
  ));

storiesOf('NavigationUserMenu', module)
.add('can publish', () => {
  const viewer = {
    canPublish: true,
    isLoggedIn: true
  };

  const props = {
    viewer: viewer,
    navigateTo: (target) => action(target)
  }

  return(
    <MuiThemeProvider>
      <StubContainer Component={NavigationUserMenu} props={props} />
    </MuiThemeProvider>
  )
})
.add('cannot publish', () => {
  const viewer = {
    canPublish: false,
    isLoggedIn: true
  };

  const props = {
    viewer: viewer,
    navigateTo: (target) => action(target)
  }

  return(
    <MuiThemeProvider>
      <StubContainer Component={NavigationUserMenu} props={props} />
    </MuiThemeProvider>
  )
})  .add('is not logged in', () => {
  const viewer = {}

  const props = {
    viewer: viewer,
    navigateTo: (target) => action(target)
  }
  return(
    <MuiThemeProvider>
      <StubContainer Component={NavigationUserMenu} props={props} />
    </MuiThemeProvider>
  )
});
