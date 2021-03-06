# Copyright (c) 2018 Public Library of Science

# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

module Typesetter
  # Base class for serializers that need to interact
  # with nested question answers.
  class TaskAnswerSerializer < Typesetter::BaseSerializer
    private

    def tasks_by_type(task_type)
      object.tasks.where(type: task_type)
    end

    ##
    # Only looks up CustomCardTask tasks with a given name
    #
    def custom_task(task_name)
      tasks = object.tasks.where(type: 'CustomCardTask', title: task_name)
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
        raise Typesetter::MetadataError.multiple_tasks(tasks)
      else
        # This branch isn't strictly necessary, but here to raise visibility
        # that is an intentional decision.
        nil
      end
    end

    def custom_tasks_questions_answers
      tasks = object.tasks.where(type: 'CustomCardTask')
                          .includes(answers: :card_content)
      question_answers = process_answers(tasks)
    end

    def process_answers(tasks)
      question_answers = {}
      tasks.each do |task|
        answers = task.answers
        answers.each do |answer|
          next if answer.card_content.ident.blank?
          if answer.card_content.value_type == 'attachment'
            question_answers[answer.card_content.ident.to_s] = process_file_attachments(answer)
          else
            question_answers[answer.card_content.ident.to_s] = answer.value
          end
        end
      end
      question_answers
    end

    def process_file_attachments(answer)
      title_caption = []
      answer.attachments.each do |attachment|
        title_caption << { title: attachment.title, caption: attachment.caption }
      end
      title_caption
    end

    def answers
      @answers ||= object.answers.includes(:card_content, :repetition)
    end

    def answer_for(ident, repetition)
      answers.detect { |answer|
        answer.card_content.ident == ident && answer.repetition == repetition
      }.try!(:value)
    end
  end
end
