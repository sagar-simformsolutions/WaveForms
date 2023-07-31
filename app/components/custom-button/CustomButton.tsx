import React from 'react';
import { ActivityIndicator, Text, TouchableOpacity, View } from 'react-native';
import { useTheme } from '../../hooks';
import styleSheet from './CustomButtonStyle';
import type { CustomButtonPropsType } from './CustomButtonTypes';

/**
 * The custom button component.
 * @param {CustomButtonPropsType} props - the props for the button component.
 * @returns {React.ReactElement} A React Element.
 */
const CustomButton = ({
  buttonContainer,
  buttonStyle,
  disableStyle,
  disabled,
  isLoading,
  onPress,
  buttonText,
  loaderColor
}: Partial<CustomButtonPropsType>): React.ReactElement => {
  const { styles } = useTheme(styleSheet);
  return (
    <View style={[styles.container, buttonContainer]}>
      <TouchableOpacity
        style={[styles.defaultButtonStyle, buttonStyle, disabled && disableStyle]}
        disabled={disabled}
        activeOpacity={0.6}
        onPress={onPress}
      >
        {isLoading ? (
          <ActivityIndicator color={loaderColor} />
        ) : (
          <Text style={styles.defaultButtonText}>{buttonText}</Text>
        )}
      </TouchableOpacity>
    </View>
  );
};

export default CustomButton;
