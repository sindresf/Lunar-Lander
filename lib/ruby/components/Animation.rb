require_relative 'component'

class Animation < Component
  attr_accessor :anim_images, :event, :is_event_current
  def initializer(anim_images, event, is_event_current)
    @anim_images = anim_images
    @event = event
    @is_event_current = is_event_current
  end
end