/* eslint-disable @typescript-eslint/no-use-before-define */
/* eslint-disable react/prop-types */
/* eslint-disable require-jsdoc */
/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */
import PropTypes from 'prop-types';
import React, { useCallback, useEffect } from 'react';
import {
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  Button,
  useColorScheme,
  View,
  UIManager,
  findNodeHandle,
  NativeModules,
  NativeEventEmitter
} from 'react-native';
import {
  Colors,
  DebugInstructions,
  Header,
  LearnMoreLinks,
  ReloadInstructions
} from 'react-native/Libraries/NewAppScreen';
import { AudioRecorder, AudioUtils } from 'react-native-audio';
import RCTFileWaveView from './RCTFileWaveView.js';
import RCTSoundWaveView from './RCTSoundWaveView.js';
import type { Node } from 'react';
// let audioPath = AudioUtils.DocumentDirectoryPath + '/test.aac';

//  import SoundCloudWaveform from 'react-native-soundcloud-waveform';

const { SoundWaveView, AudioPlayerWaveformView } = NativeModules;

const Section = ({ children, title }): Node => {
  const isDarkMode = useColorScheme() === 'dark';
  return (
    <View style={styles.sectionContainer}>
      <Text
        style={[
          styles.sectionTitle,
          {
            color: isDarkMode ? Colors.white : Colors.black
          }
        ]}
      >
        {title}
      </Text>
      <Text
        style={[
          styles.sectionDescription,
          {
            color: isDarkMode ? Colors.light : Colors.dark
          }
        ]}
      >
        {children}
      </Text>
    </View>
  );
};

const App: () => Node = () => {
  const isDarkMode = useColorScheme() === 'dark';

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter
  };
  const playerRef = React.createRef();

  useEffect(() => {
    // setMeteringLevels();
  }, []);

  const setMeteringLevels = async () => {
    await AudioPlayerWaveformView.setLevels([
      0.079654366, 0.07239192, 0.04092394, 0.04715808, 0.066934794, 0.18236597, 0.00639865,
      0.01868773, 0.01850173, 0.04223208, 0.09677348, 0.0764632, 0.09055693, 0.0894879, 0.0915373,
      0.09695448, 0.48548305, 0.44841215, 0.02616228, 0.02851183, 0.05865989, 0.079654366,
      0.07239192, 0.04092394, 0.079654366, 0.07239192, 0.04092394, 0.04715808, 0.066934794,
      0.18236597, 0.00639865, 0.01868773, 0.01850173, 0.04223208, 0.09677348, 0.0764632, 0.09055693,
      0.0894879, 0.0915373, 0.09695448, 0.48548305, 0.44841215, 0.02616228, 0.02851183, 0.05865989,
      0.079654366, 0.07239192, 0.04092394, 0.32616228, 0.22851183, 0.15865989, 0.079654366,
      0.07239192, 0.04092394, 0.04715808, 0.066934794, 0.18236597, 0.40639865, 0.41868773,
      0.41850173, 0.34223208, 0.49677348, 0.5764632, 0.49055693, 0.3894879, 0.3915373, 0.39695448,
      0.48548305, 0.44841215, 0.32616228, 0.22851183, 0.15865989, 0.079654366, 0.07239192,
      0.04092394, 0.04715808, 0.066934794, 0.18236597, 0.40639865, 0.41868773, 0.41850173,
      0.34223208, 0.49677348, 0.5764632, 0.49055693, 0.3894879, 0.3915373, 0.39695448, 0.48548305,
      0.44841215, 0.32616228, 0.22851183, 0.15865989, 0.079654366, 0.07239192, 0.04092394,
      0.04715808, 0.066934794, 0.18236597, 0.40639865, 0.41868773, 0.31850173, 0.14223208,
      0.49677348, 0.5764632, 0.49055693, 0.3894879, 0.3915373, 0.39695448, 0.48548305, 0.44841215,
      0.32616228, 0.22851183, 0.15865989, 0.079654366, 0.07239192, 0.04092394, 0.04715808,
      0.066934794, 0.18236597, 0.40639865, 0.41868773, 0.41850173, 0.34223208, 0.49677348,
      0.5764632, 0.49055693, 0.3894879, 0.3915373, 0.39695448, 0.48548305, 0.44841215, 0.32616228,
      0.22851183, 0.15865989, 0.079654366, 0.07239192, 0.04092394, 0.04715808, 0.066934794,
      0.18236597, 0.40639865, 0.41868773, 0.41850173, 0.34223208, 0.49677348, 0.5764632, 0.49055693,
      0.3894879, 0.3915373, 0.39695448, 0.48548305, 0.44841215, 0.32616228, 0.22851183, 0.15865989,
      0.079654366, 0.07239192, 0.04092394, 0.04715808, 0.066934794, 0.18236597, 0.40639865,
      0.41868773, 0.41850173, 0.34223208, 0.49677348, 0.5764632, 0.49055693, 0.3894879, 0.3915373,
      0.39695448, 0.48548305, 0.44841215, 0.32616228, 0.22851183, 0.15865989, 0.079654366,
      0.07239192, 0.04092394, 0.04715808, 0.066934794, 0.18236597, 0.40639865, 0.41868773,
      0.41850173, 0.34223208, 0.49677348, 0.5764632, 0.49055693, 0.3894879, 0.3915373, 0.39695448,
      0.48548305, 0.44841215, 0.32616228, 0.22851183, 0.15865989
    ]);
  };

  const recordingPermissionOnPress = async () => {
    await SoundWaveView.askAudioRecordingPermission((err, r) =>
      console.info('recordingPermissionOnPress', r)
    );
  };

  const playOnPress = async () => {
    // await UIManager.dispatchViewManagerCommand(
    //   findNodeHandle(this),
    //   // we are calling the 'start' command for start recording
    //   UIManager.getViewManagerConfig('SoundWaveView').Commands.start,
    //   [],
    // );

    await SoundWaveView.start((err, r) => console.log(r));
  };

  const stopOnPress = async () => {
    await SoundWaveView.stop((err, r) => console.log(r));
  };
  const setTime = () => {
    return 70;
  };

  const pauseOnPress = async () => {
    await SoundWaveView.pause((err, r) => console.log(r));
  };

  const reSetOnPress = async () => {
    await SoundWaveView.reset((err, r) => console.log(r));
    await AudioPlayerWaveformView.reset((err, r) => console.log(r));
  };

  const playProgressOnPress = async () => {
    await AudioPlayerWaveformView.play((err, r) => console.log({ err, r }, '<== err on play'));
  };

  const pauseProgressOnPress = async () => {
    await AudioPlayerWaveformView.pause((err, r) => console.log(r));
  };

  const stopProgressOnPress = async () => {
    await AudioPlayerWaveformView.stop((err, r) => console.log(r));
  };

  const setFile = async (e) => {
    console.log('onFinished', e.nativeEvent);
    console.log('e.nativeEvent.fileUrl', e.nativeEvent.fileUrl);
    // await SoundWaveView.reset((err, r) => console.log(r));
    // SoundWaveView.setUrl(e.nativeEvent.fileUrl);
    await AudioPlayerWaveformView.setUrl(e.nativeEvent.fileUrl);
  };

  return (
    <SafeAreaView style={backgroundStyle}>
      <StatusBar barStyle={isDarkMode ? 'light-content' : 'dark-content'} />
      <ScrollView contentInsetAdjustmentBehavior="automatic" style={backgroundStyle}>
        <View
          style={{
            backgroundColor: isDarkMode ? Colors.black : Colors.white
          }}
        >
          <RCTSoundWaveView
            ref={playerRef}
            style={styles.cameraContainer}
            waveWidth={2}
            gap={5}
            progressColor={'#ffffff'}
            bgClor={'#824567'}
            isDrawSilencePadding={false}
            //  minHeight={1}
            // radius={radius}
            onError={(e) => {
              console.log('onError', e.nativeEvent);
            }}
            // onBuffer={e => {
            //   console.log('onBuffer', e.nativeEvent);
            // }}
            onStarted={(e) => {
              console.log('onStarted', e.nativeEvent);
            }}
            onPause={(e) => {
              console.log('onPause', e.nativeEvent);
            }}
            onFinished={setFile}
            onProgress={(e) => {
              console.log('onProgress', e.nativeEvent);
            }}
            onSilentDetected={(e) => {
              console.log('onSilentDetected', e.nativeEvent);
            }}
          />
          <RCTFileWaveView style={styles.cameraContainer} />
          <Section title="Recoding Changes">
            <Button
              transparent
              style={styles.leftIcon}
              title="Recording Permission"
              onPress={recordingPermissionOnPress}
            />
            <Button transparent style={styles.leftIcon} title="Play" onPress={playOnPress} />
            <Button transparent style={styles.leftIcon} title="Stop" onPress={stopOnPress} />
            <Button transparent style={styles.leftIcon} title="Pause" onPress={pauseOnPress} />
            <Button transparent style={styles.leftIcon} title="Reset" onPress={reSetOnPress} />
          </Section>
          <Section title="File Changes">
            <Button
              transparent
              style={styles.leftIcon}
              title="Playsss"
              onPress={playProgressOnPress}
            />
            <Button
              transparent
              style={styles.leftIcon}
              title="Stop"
              onPress={stopProgressOnPress}
            />
            <Button
              transparent
              style={styles.leftIcon}
              title="Pause"
              onPress={pauseProgressOnPress}
            />
            <Button transparent style={styles.leftIcon} title="Reset" onPress={reSetOnPress} />
          </Section>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  cameraContainer: {
    flex: 1,
    width: 'auto',
    height: 100,
    // backgroundColor: Colors.white
    backgroundColor: Colors.transparent
  },
  highlight: {
    fontWeight: '700'
  },
  leftIcon: {
    height: 50,
    padding: 10,
    width: 35
  },
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24
  },
  sectionDescription: {
    fontSize: 18,
    fontWeight: '400',
    marginTop: 8
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600'
  }
});

// RCTAudioVisualizerManager.propTypes = {
//   onAudioStarted: PropTypes.func,
//   onAudioFinished: PropTypes.func,
// };

export default App;
