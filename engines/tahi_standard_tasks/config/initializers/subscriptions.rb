Subscriptions.configure do
  add 'paper:resubmitted', Paper::Resubmitted::ReopenRevisionTasks
  add 'tahi_standard_tasks/register_decision_task:completed', RegisterDecisionTask::Completed::KeenLogger, RegisterDecisionTask::Completed::EventStoreLogger
  add 'tahi_standard_tasks/paper_editor_task:completed', EditorAssigned::KeenLogger, EditorAssigned::EventStoreLogger
  add 'tahi_standard_tasks/paper_reviewer_task:completed', AllReviewersAssigned::KeenLogger, AllReviewersAssigned::EventStoreLogger
end
