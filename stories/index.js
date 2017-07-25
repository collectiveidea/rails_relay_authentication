import React from 'react';
import { storiesOf, action, linkTo } from '@kadira/storybook';
import Button from './Button';
import Welcome from './Welcome';
import NavigationUserMenu from './../client/components/navigation/NavigationUserMenu';
import StubContainer from "react-storybooks-relay-container"

storiesOf('Welcome', module)
  .add('to Storybook', () => (
    <Welcome showApp={linkTo('Button')}/>
  ));

storiesOf('Button', module)
  .add('with text', () => (
    <Button onClick={action('clicked')}>Hello Button</Button>
  ))
  .add('with some emoji', () => (
    <Button onClick={action('clicked')}>😀 😎 👍 💯</Button>
  ));

storiesOf('NavigationUserMenu', module)
  .add('can publish', () => {
    const viewer = {
      canPublish: true,
      isLoggedIn: true,
      user: {
        id: '1'
      }
    };

    const navigateTo = (target) => {
      console.log(target)
    };

    const props = {
      viewer: viewer,
      navigateTo: navigateTo
    }

    return <StubContainer Component={NavigationUserMenu} props={props} />;
  })
  .add('is logged in', () => (
    <Button onClick={action('clicked')}>😀 😎 👍 💯</Button>
  ));
