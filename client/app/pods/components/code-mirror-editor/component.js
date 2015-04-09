// https://github.com/IvyApp/ivy-codemirror

import Ember from 'ember';
import LazyLoader from 'ember-cli-lazyloader/lib/lazy-loader';

export default Ember.Component.extend({
  tagName: 'textarea',

  /**
   * The value of the editor.
   *
   * @property value
   * @type {String}
   * @default null
   */
  value: null,

  lineNumbers: true,
  lineWrapping: true,
  readOnly: false,
  rtlMoveVisually: true,
  theme: 'default',

  /**
   * Force CodeMirror to refresh.
   *
   * @method refresh
   */
  refresh: function() {
    this.get('codeMirror').refresh();
  },


  // Private

  _editorSetup: function() {
    this._loadAssets().then(()=> {
      this._initCodemirror();
    });
  }.on('didInsertElement'),

  _loadAssets: function() {
    this._loadCSS();
    return this._loadScripts();
  },

  _loadScripts: function() {
    var scripts = [
      '/codemirror/codemirror.min.js',
      '/codemirror/mode/stex.js'
    ];

    return LazyLoader.loadScripts(scripts);
  },

  _loadCSS: function() {
    return LazyLoader.loadCSS('/codemirror/codemirror.css');
  },

  _initCodemirror: function() {
    var codeMirror = CodeMirror.fromTextArea(this.get('element'), {
      lineNumbers:     this.get('lineNumbers'),
      lineWrapping:    this.get('lineWrapping'),
      readOnly:        this.get('readOnly'),
      rtlMoveVisually: this.get('rtlMoveVisually'),
      theme:           this.get('theme'),
      mode:            this.get('mode')
    });

    // Stash away the CodeMirror instance.
    this.set('codeMirror', codeMirror);

    // Set up handlers for CodeMirror events.
    this._bindCodeMirrorEvent('change', this, '_updateValue');

    // Set up bindings for CodeMirror options.
    this._bindCodeMirrorOption('lineNumbers');
    this._bindCodeMirrorOption('lineWrapping');
    this._bindCodeMirrorOption('readOnly');
    this._bindCodeMirrorOption('rtlMoveVisually');
    this._bindCodeMirrorOption('theme');

    this._bindCodeMirrorProperty('value', this, '_valueDidChange');
    this._valueDidChange();

    // Force a refresh on `becameVisible`, since CodeMirror won't render itself
    // onto a hidden element.
    this.on('becameVisible', this, 'refresh');
  },

  /**
   * Bind a handler for `event`, to be torn down in `willDestroyElement`.
   *
   * @private
   * @method _bindCodeMirrorEvent
   */
  _bindCodeMirrorEvent: function(event, target, method) {
    var callback = Ember.run.bind(target, method);

    this.get('codeMirror').on(event, callback);

    this.on('willDestroyElement', this, function() {
      this.get('codeMirror').off(event, callback);
    });
  },

  /**
   * @private
   * @method _bindCodeMirrorProperty
   */
  _bindCodeMirrorOption: function(key) {
    this._bindCodeMirrorProperty(key, this, '_optionDidChange');

    // Set the initial option synchronously.
    this._optionDidChange(this, key);
  },

  /**
   * Bind an observer on `key`, to be torn down in `willDestroyElement`.
   *
   * @private
   * @method _bindCodeMirrorProperty
   */
  _bindCodeMirrorProperty: function(key, target, method) {
    this.addObserver(key, target, method);

    this.on('willDestroyElement', this, function() {
      this.removeObserver(key, target, method);
    });
  },

  /**
   * Sync a local option value with CodeMirror.
   *
   * @private
   * @method _optionDidChange
   */
  _optionDidChange: function(sender, key) {
    this.get('codeMirror').setOption(key, this.get(key));
  },

  /**
   * Update the `value` property when a CodeMirror `change` event occurs.
   *
   * @private
   * @method _updateValue
   */
  _updateValue: function(instance) {
    this.set('value', instance.getValue());
  },

  _valueDidChange: function() {
    var codeMirror = this.get('codeMirror'),
        value = this.get('value');

    if (value !== codeMirror.getValue()) {
      codeMirror.setValue(value || '');
    }
  }
});
