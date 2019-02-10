<div class="userSettingsHeader">
    <h1 class="userSettingsHeader1">{{lang.userSocialHeader}}</h1>
</div>
<form>
    <div class="userSettingsSocial">
      <div class="socialConnectError"></div>
      <div class="userSettingsFacebookCont">
        {{#facebookConnected}}
          <div>Facebook connected</div>
        {{/facebookConnected}}
        {{^facebookConnected}}
          <fb:login-button scope="public_profile,email" onlogin="connectFacebookUser();">
          </fb:login-button>
        {{/facebookConnected}}
      </div>
      <div class="userSettingsGoogleCont">
        {{#googleConnected}}
          <div>Google connected</div>
        {{/googleConnected}}
        {{^googleConnected}}
          <button type="button" class="gPlus akcButton">{{lang.gPlus}}</button>
        {{/googleConnected}}
      </div>
    </div>
</form>
