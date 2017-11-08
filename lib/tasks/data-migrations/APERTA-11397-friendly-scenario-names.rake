namespace :data do
  namespace :migrate do
    desc <<-DESC
      Change the references to scenarios to friendlier names.
    DESC
    task setup_friendly_scenario_names: :environment do
      # This list of scenarios is the same as TemplateContext.scenarios as at
      # APERTA-11397. TemplateContext.scenarios may change, that's why this list
      # is duplicated here.
      scenarios = {
        'Manuscript' => PaperScenario,
        'Reviewer Report' => ReviewerReportScenario,
        'Invitation' => InvitationScenario,
        'Paper Reviewer' => PaperReviewerScenario,
        'Preprint Decision' => PreprintDecisionScenario,
        'Decision' => RegisterDecisionScenario,
        'Tech Check' => TechCheckScenario
      }.invert

      # Remove module scopes
      LetterTemplate
        .where(scenario: 'TahiStandardTasks::RegisterDecisionScenario')
        .update_all(scenario: 'RegisterDecisionScenario')
      LetterTemplate
        .where(scenario: 'TahiStandardTasks::PreprintDecisionScenario')
        .update_all(scenario: 'PreprintDecisionScenario')

      LetterTemplate.find_each do |tpl|
        scenario_class = tpl.scenario
        if scenario_class == 'SendbacksContext'
          tpl.update(scenario: 'Tech Check')
          next
        end
        scenario_class = scenario_class.constantize
        tpl.update(scenario: scenarios[scenario_class]) if scenarios.key? scenario_class
      end
    end
  end
end