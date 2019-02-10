<div class="centralBlock center-block forgottenPasswordBlock">
  <h2>{{lang.forgottenPassword}}</h2>
  <label for="forgottenPasswordInput">{{lang.forgottenText}}</label>
  <input class="akcInput" id="forgottenPasswordInput" type="text"><br>
  <button type="button" class="resetPassword akcButton">{{lang.resetPassword}}</button>
  {{#result}}
    {{#emailSent}}
      <h3 class="confirmed">
        {{lang.confirmText}}
      </h3>
    {{/emailSent}}
    {{^emailSent}}
      <h3 class="error">
        {{lang.errorText}}
      </h3>
    {{/emailSent}}
  {{/result}}
</div>