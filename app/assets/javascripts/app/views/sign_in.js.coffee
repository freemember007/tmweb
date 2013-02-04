App.SignInView = Ember.View.extend({
  templateName: 'app/templates/sign_in'

  cancelSignIn: ->
    this.get("parentView").hideSignIn()

  signIn: ->
      $.post("/users/sign_in",$('.form-horizontal').serialize(),(data)->
        if data.success
          $('.sign_in').slideUp(300, ->self.location.href = "/" + data.domain_name)
        else
          alert "登录错误！"
      )

})