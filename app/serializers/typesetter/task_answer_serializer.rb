module Typesetter
  # Base class for serializers that need to interact
  # with nested question answers.
  class TaskAnswerSerializer < ActiveModel::Serializer
    private

    def tasks_by_type(task_type)
      object.tasks.where(type: task_type)
    end

    def custom_task(task_name)
      tasks = object.tasks.where(type: 'CustomCardType', title: task_name)
      first_if_single(tasks)
    end

    def task(task_type)
      tasks = tasks_by_type(task_type)
      first_if_single(tasks)
    end

    def first_if_single(tasks)
      if tasks.length == 1
        tasks.first
      elsif tasks.length > 1
        fail Typesetter::MetadataError.multiple_tasks(tasks)
      else
        # This branch isn't strictly necessary, but here to raise visibility
        # that is an intentional decision.
        nil
      end
    end
  end
end
