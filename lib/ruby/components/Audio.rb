require_relative 'component'

class Audio < Component
  attri_accessor :sound, :volume
  def initializer(sound, volume)
    @sound = sound
    @volume = volume
  end
end