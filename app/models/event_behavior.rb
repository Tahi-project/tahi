# Defines a "behavior" which triggers an action on a certain event.

class EventBehavior < ActiveRecord::Base
  include Attributable

  validates :action, inclusion: { in: BehaviorAction.action_names.map(&:to_s) }
  validates :event_name, inclusion: { in: %w[paper_submitted] }

  belongs_to :journal

  has_attributes :event_behavior_attributes,
                 inverse_of: :event_behavior,
                 class_name: 'EventBehaviorAttribute',
                 types: {
                   boolean: %w[boolean_param],
                   json: %w[json_param],
                   string: %w[string_param]
                 }

  def call(user:, paper:, task:)
    BehaviorAction.find(action).new.call(parameters, event_data)
  end

  def parameters
    event_behavior_attributes.each_with_object({}) do |attribute, hsh|
      hsh[attribute.name] = attribute.value
    end
  end
end
