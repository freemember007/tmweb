App.homeHeader = Ember.View.extend({
  templateName: 'app/templates/header',

  showSignIn: ->
    this.set('signIn', true)
  
  hideSignIn: ->
    this.set('signIn', false)

});