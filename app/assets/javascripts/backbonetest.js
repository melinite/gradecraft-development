window.assignments = Backbone.Model.extend({
  defaults: {
    done: false
  },

  initialize: function () {
  },

  url: function () {
    return this.id ?  '/asignments/' + this.id : '/assignments'
  }
})
