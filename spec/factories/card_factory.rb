FactoryGirl.define do
  factory :card do
    name "Test Card"
    journal
    latest_version 1

    trait :versioned do
      after(:create) do |card|
        FactoryGirl.create(:card_version, card: card, version: card.latest_version)
      end
    end
    trait :for_answerable do
      transient do
        answerable TahiStandardTasks::PublishingRelatedQuestionsTask
        idents 'publishing_related_questions--short_title'
      end

      after(:create) do |card, evaluator|
        idents = Array(evaluator.idents)
        root = create(:card_content, card: card)
        idents.each do |ident|
          create(:card_content, parent: root, card: card, ident: ident)
        end
        evaluator.answerable.update(card: card)
      end
    end
  end
end
