import Ember from 'ember';
import TaskController from 'tahi/pods/task/controller';

export default TaskController.extend({
  varName2: "anything else",
  ringgold: [
    { id: 123, text: "Memorial University of Newfoundland" },
    { id: 124, text: "Ryerson University" },
    { id: 125, text: "Simon Fraser University" },
    { id: 123, text: "University of Manitoba" },
    { id: 123, text: "Faculty of Humanities and Social Sciences Library" },
    { id: 123, text: "Odense University Hospital" },
    { id: 123, text: "University of Southern Denmark" },
    { id: 123, text: "Bielefeld University" },
    { id: 123, text: "Helmholtz Association of German Research Centres" },
    { id: 123, text: "Max Planck Institutes" },
    { id: 123, text: "Ruhr University Bochum" },
    { id: 123, text: "Technische Universität München" },
    { id: 123, text: "University of Regensburg" },
    { id: 123, text: "University of Stuttgart" },
    { id: 123, text: "Fondazione Telethon" },
    { id: 123, text: "Institute for Health & Behavior" },
    { id: 123, text: "CINVESTAV Unidad Irapuato" },
    { id: 123, text: "Delft University of Technology" },
    { id: 123, text: "Temasek Life Sciences Laboratory" },
    { id: 123, text: "Lund University" },
    { id: 123, text: "ETH Zurich" },
    { id: 123, text: "Brunel University" },
    { id: 123, text: "John Innes Centre" },
    { id: 123, text: "London School of Hygiene & Tropical Medicine" },
    { id: 123, text: "Newcastle University" },
    { id: 123, text: "Queen’s University Belfast" },
    { id: 123, text: "University College London (UCL)" },
    { id: 123, text: "University of Birmingham" },
    { id: 123, text: "University of Glasgow" },
    { id: 123, text: "University of Leeds" },
    { id: 123, text: "University of St. Andrews " },
    { id: 123, text: "University of Stirling" },
    { id: 123, text: "George Mason University" }
  ],
  countries: [
    {id: 1, text: "USA"},
    {id: 2, text: "Mexico"}
  ],
  states: [
    {id: 1, text: "CA"},
    {id: 2, text: "NY"}
  ],
  inviteCode: '',
  endingComments: '',
  pubFee: 123.00,
  journalName: 'PLOS One',
  feeMessage: (function(){
    return "The fee for publishing in " + this.get("journalName") + " is $" + this.get("pubFee")
  }).property("journalName")
});
