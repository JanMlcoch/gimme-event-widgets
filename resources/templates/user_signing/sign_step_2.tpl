<form>
    <div class="appSignUpDots center-block">
        <div class="full"></div>
        <div></div>
        <div></div>
    </div>
    <div class="appSignUpData center-block">
        <input type="text" class="firstName akcInput half floatLeft" placeholder="{{lang.firstName}}" />
        <input type="text" class="surname akcInput half" placeholder="{{lang.surname}}" />
        <div class="errorMessage"></div>
        <input type="text" class="login akcInput" placeholder="{{lang.login}}" />
        <div class="errorMessage login"></div>
        <input type="text" class="email akcInput" placeholder="{{lang.email}}" />
        <div class="errorMessage email"></div>
        <input type="password" class="password1 akcInput" placeholder="{{lang.password1}}" />
      <div class="errorMessage password">
        <div class="password1Message"></div>
        <div class="password2Message"></div>
      </div>
        <input type="password" class="password2 akcInput" placeholder="{{lang.password2}}" />

        <div>{{lang.licence}} <a href="">{{lang.licenceInner}}</a>.</div>
    </div>
    <div class="appSignUpButtons">
        <button type="button" class="createAccount akcButton">{{lang.createAccount}}</button>
        <button type="button" class="nextButton akcButton" disabled>{{lang.next}}</button>
    </div>
</form>

