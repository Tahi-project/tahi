import Ember from 'ember';
var NestedQuestionComponent;

NestedQuestionComponent = Ember.Component.extend({
  tagName: 'div',
  helpText: null,
  disabled: false,
  questionTextClass: "question-text",

  model: Ember.computed('task', 'ident', function() {
    let ident = this.get('ident');
    Ember.assert(`Expecting to be given an ident, but wasn't`, ident);

    let question = this.get('task').findQuestion(ident);

    Ember.assert(`Expecting to find question matching ident '${ident}' but didn't`, question);
    return question;
  }),

  additionalData: Ember.computed.alias('model.additionalData'),

  change: function(){
    Ember.run.debounce(this, this._saveAnswer, this.get('model.answer'), 200);
    return false;
  },

  _saveAnswer: function(answer){
    answer.save();
  }
});

export default NestedQuestionComponent;
