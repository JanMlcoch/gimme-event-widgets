<div class="container">
    <div class="navbar-header">
        <img class="logoImg" src="images/symbol_small.png" alt="logo"><a class="logoText" href="">GimmeEvent</a>
        <button class="navbar-toggle collapsed" id="navbarBtn" type="button">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
    </div>
    <div id="navbar" class="navbar-collapse collapse navbar-collapse-custom">

        <ul class="nav navbar-nav">
            {{^logged}}
                <li>
                    <button type="button" class="appRecommendedEvents akcButton">{{lang.recommendedEvents}}</button>
                </li>
                <li>
                    <button type="button" class="appSignIn akcButton">{{lang.signIn}}</button>
                </li>
                <li>
                    <button type="button" class="appSignUpRoute akcButton">{{lang.signUp}}</button>
                </li>
            {{/logged}}
            {{#logged}}
                <li>
                    <button type="button" class="appRecommendedEvents akcButton">{{lang.recommendedEvents}}</button>
                </li>
                <li>
                    <button type="button" class="appPlannedEvents akcButton">{{lang.plannedEvents}}</button>
                </li>
                <li>
                    <button type="button" class="appAddEventRoute akcButton">{{lang.addEvent}}</button>
                </li>
                <li>
                    <button type="button" class="appUserSettingsRoute akcButton">{{lang.userSettings}}</button>
                </li>

                <li>
                    <button type="button" class="appUserLogOut akcButton">{{lang.logOut}}</button>
                </li>


            {{/logged}}
        </ul>
        <div class="headerBlock">
            <div class="languageSign">{{langShortCut}}</div>
        </div>
        {{#logged}}
            <div class="headerBlock">
                <div>
                    <a href="#user_settings" class="appNavbarWidgetUserLogin">{{userLogin}}</a>
                </div>
            </div>
            <div class="headerBlock">
                <img class="appNavbarWidgetSettings icon-settings" src="{{loggedUserIcon}}" />
            </div>
        {{/logged}}
    </div>
</div>