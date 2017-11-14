# Defines a "behavior" which triggers an action on a certain event.

class EventBehavior < ActiveRecord::Base
  include Attributable

  belongs_to :journal

  validates :event_name, presence: true, inclusion: { in: ->(_) { Event.allowed_events } }

  self.inheritance_column = 'action'

  def self.sti_name
    name.gsub(/Behavior$/, '').underscore
  end

  def self.find_sti_class(type_name)
    "#{type_name.camelize}Behavior".constantize
  end

  def call(user:, paper:, task:)
    event_params = { user: user, paper: paper, task: task }
    self.class.action_class.call(
      event_params: event_params,
      behavior_params: behavior_params
    )
  end

  def behavior_params
    entity_attributes.each_with_object({}) do |attribute, hsh|
      hsh[attribute.name] = attribute.value
    end
  end

  class << self
    attr_accessor :action_class
  end
end
