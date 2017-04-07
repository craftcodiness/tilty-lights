require 'serialport'

module Arduino
  SERIAL_PORT = "/dev/ttyUSB0"
  SERIAL_RATE = 115200
  PIXELS = 24

  def self.serial_port
    @port ||= begin
      res = SerialPort.new(SERIAL_PORT, baud: SERIAL_RATE)
      sleep(2)
      res
    end
  end

  def self.set_pixel(pixel, red, green, blue)
    sleep(0.01)
    # first byte is whice led number to switch on
    self.serial_port.write(pixel.chr)     

    # next 3 bytes are red, green and blue values
    # Note: 255 signifies the end of the command, so don't try and set an led value to that
    self.serial_port.write(red.chr)    
    self.serial_port.write(green.chr)    
    self.serial_port.write(blue.chr)

    # then end with a termination character
    self.serial_port.write(255.chr)  
  end

  def self.radial_pixel_index(value, range)
    (((PIXELS.to_f * value) / range).floor + PIXELS) % PIXELS
  end

  def self.render_accelerometer_data(json)
    puts "Accelerometer data: #{json.inspect}"
    pixels = (0..(PIXELS - 1)).map { [0,0,0] }
    pixels[radial_pixel_index(json["alpha"], 360)][1] = 100
    pixels[radial_pixel_index(json["beta"], 360)][0] = 100
    pixels[radial_pixel_index(json["gamma"], 180)][2] = 100
    pixels.each_with_index do |pixel,i|
      set_pixel(PIXELS - i - 1, pixel[0], pixel[1], pixel[2])
    end
  end
end
