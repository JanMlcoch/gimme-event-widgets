<h2>{{signIn}}</h2>
<div class="appLoginWidget center-block">
    <form>
        <div class="errorMessage appLoginIncorrect invisible">{{wrongLogin}}</div>
        <div class="appLoginWidgetInputs">
            <input id="appLoginInput" type='text' class='login akcInput' placeholder="{{loginText}}">
            <input id="appPasswordInput" type='password' class='password akcInput' placeholder="{{passText}}">
        </div>
        <div class="appLoginWidgetConfirm">
            <input type='button' class='submitCredentials akcButton' value='{{submitText}}'>
        </div>
    </form>
    <a class="appLoginWidgetForgot" href="{{forgottenPasswordHref}}">{{forgot}}</a>
    <div class="appLoginWidgetForever">
        <input type="checkbox" id="loginForever">
        <label for="loginForever">{{forever}}</label>
    </div>
</div>
