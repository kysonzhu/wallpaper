import React, { Component } from 'react';
import {AppRegistry,Text } from 'react-native';

class Wallpaper extends Component {
  render() {
    return (
      <Text>Hello world!</Text>
    );
  }
}
//  项目名要有所对应
AppRegistry.registerComponent('Wallpaper', () => Wallpaper);