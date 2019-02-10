<div class="appLoginWidgetCont{{^signInPart}} hidden{{/signInPart}}"></div>
<div class="appSignUpCont">
    <h2 class="clear">{{lang.signInWith}}</h2>
  <button type="button" class="gPlus center-block akcButton">{{lang.gPlus}}</button>
    <!--<button type="button" disabled class="facebook center-block akcButton">{{lang.facebook}}</button>-->
    <div>
      <fb:login-button scope="public_profile,email" onlogin="checkFacebookStatus();">
      </fb:login-button>
    </div>
  <div class="external-login-error-message errorMessage invisible"></div>
    <hr class="akcHr">
    <h2 class="clear">{{lang.signUp}}</h2>
    <button type="button" class="newAccount center-block akcButton">{{lang.newAccount}}</button>
</div>
