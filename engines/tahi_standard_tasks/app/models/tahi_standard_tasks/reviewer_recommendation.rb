module TahiStandardTasks
  class ReviewerRecommendation < ActiveRecord::Base
    include Answerable
    include NestedQuestionable

    belongs_to :reviewer_recommendations_task

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true

    alias_method :task, :reviewer_recommendations_task

    # useful for nested_questions to always have path to owner
    def paper
      reviewer_recommendations_task.paper
    end
  end
end
