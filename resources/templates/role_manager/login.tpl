{{^logged}}
  <input id="role_login_login" title="login" placeholder="login" type="text">
  <input id="role_login_password" title="password" placeholder="password" type="password">
  <input id="role_login_submit" title="submit" type="button" value="Login">
{{/logged}}
{{#logged}}
  <div>{{user.login}}</div>
  <input id="role_login_logout" title="submit" type="button" value="Logout">
{{/logged}}
