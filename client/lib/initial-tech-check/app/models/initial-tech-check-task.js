import DS   from 'ember-data';
import Task from 'tahi/models/task';

export default Task.extend({
  changesForAuthorTask: DS.belongsTo('changes-for-author-task')
});
