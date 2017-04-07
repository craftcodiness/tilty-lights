# Tilty and Wilty

It tilts, it wilts! Visualise the orientation of your smartphone using an LED ring attached to an Ardino!

This application will launch a webserver to which your smartphone can connect. Using Javascript from the phone's browser, accelerometer data will be posted to the server, which is then rendered over the serial port as pixel data by an Arduino.

## Prequisits

You will need an Ardino and an LED ring. The Arduino will have to have been pre-programmed with the serial-to-pixel code available from [@edwardmccaughan's](https://github.com/edwardmccaughan) [rgb_led_control](https://github.com/edwardmccaughan/rgb_led_control).

## Installation

The server is a Ruby rackup process. Install the libraries and dependencies with bundler:

```
  bundle install
```

## Running

Connect the Arduino to USB port of your computer, to power the device and initialize its serial port. The Arduino should show up on `/dev/ttyUSB0` on your machine - if not you will need to edit `arduino.rb` to have the correct address for the serial device.

Launch the server with rackup:

```
  bundle exec rackup -E production config.ru
```

The server will listen on port 9292 by default. You can visit the page in your browser:

```
  http://localhost:9292/
```

If you want to make the page available to remote device, you might want to use [ngrok](https://ngrok.com):

```
  ngrok http 9292
```

## Usage

The ring will render the three axes of the smartphone gyroscope. In airplane terms, green is yaw, blue is roll, and red is pitch. If you lay your smartphone flat on the table and rotate it, you can use the green LED like a compass. As you lift the phone, the red and blue will model the alignment of the other two degrees of rotation of the phone.
