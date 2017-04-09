require 'arduino-lights'

module ArduinoLights

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
