<div class="userSettingsHeader">
    <h1 class="userSettingsHeader1">{{lang.userSettingsHeader}}</h1>
</div>
<form>
    <div class="userSettingsBase">
        <div class="userSettingsLeft">
            <div class="userSettingsBaseAndImage userSettingsCol">
                <div class="userSettingsBaseAndImageNoHeader">
                    <div class="userSettingsImage">
                    </div>
                    <div class="userSettingsBaseInfo">
                        <div class="userSettingsDetail">
                            <label>{{lang.name}}:</label>
                            <div class="nameValue value" data-input="name">{{usersName}}</div>
                            <img class="userSettingsEditIcon" src="{{editImageSRC}}">
                            <input type="hidden" class="nameValueHiddenInput" />
                        </div>
                        <div class="userSettingsDetail">
                            <label>{{lang.surname}}:</label>
                            <div class="surnameValue value" data-input="surname">{{usersSurname}}</div>
                            <img class="userSettingsEditIcon" src="{{editImageSRC}}">
                            <div class="surnameNotValid validatorMessage"></div>
                            <input type="hidden" class="surnameValueHiddenInput" />
                        </div>
                        <div class="userSettingsDetail">
                            <label>{{lang.email}}:</label>
                            <div class="emailValue value" data-input="email">{{usersEmail}}</div>
                            <!--<img class="userSettingsEditIcon" src="{{editImageSRC}}">-->
                            <div class="emailNotValid validatorMessage"></div>
                            <input type="hidden" class="emailValueHiddenInput" />
                        </div>
                        <div class="userSettingsDetail">
                            <label>{{lang.language}}:</label>
                            <select name="language" class="value languageValue">
                                {{{languageOptions}}}
                            </select><br>
                        </div>
                        <div class="userSettingsDetail">
                            <label>{{lang.city}}:</label>
                            <div class="cityAutocompleteContainer">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="userSettingsRight">
            <h2 class="userSettingsDetailHeader">{{lang.changePassword}}</h2>

            <div class="userSettingsDetail">
                <label for="changePasswordOld">{{lang.oldPassword}}:</label>
                <input type="password" name="userSettingsOldPassword" id="changePasswordOld"><br>
                <div class="errorMessage oldPasswordNotValid"></div>
            </div>
            <div class="userSettingsDetail">
                <label for="changePasswordNew">{{lang.newPassword}}:</label>
                <input type="password" name="userSettingsNewPassword" id="changePasswordNew"><br>
                <div class="errorMessage newPassword1NotValid"></div>
            </div>
            <div class="userSettingsDetail">
                <label for="changePasswordNewAgain">{{lang.newPasswordAgain}}:</label>
                <input type="password" name="userSettingsNewPasswordAgain" id="changePasswordNewAgain"><br>
                <div class="errorMessage newPassword2NotValid"></div>
            </div>


            <!--<div class="userSettingsChangePasswordDetail">-->
                <!--<label for="userSettingsOldPassword" class="userSettingsDetailLabel">{{lang.oldPassword}}</label><br>-->
                <!--<label for="userSettingsNewPassword" class="userSettingsDetailLabel">{{lang.newPassword}}</label><br>-->
                <!--<label for="userSettingsNewPasswordAgain" class="userSettingsDetailLabel">{{lang.newPasswordAgain}}</label>-->
            <!--</div>-->
            <!--<div class="userSettingsChangePasswordInput">-->
                <!--<input type="password" name="userSettingsOldPassword"><br>-->
                <!--<span class="validatorMessage oldPasswordNotValid"></span><br>-->
                <!--<input type="password" name="userSettingsNewPassword"><br>-->
                <!--<span class="validatorMessage newPassword1NotValid"></span><br>-->
                <!--<input type="password" name="userSettingsNewPasswordAgain"><br>-->
                <!--<span class="validatorMessage newPassword2NotValid"></span>-->
            <!--</div>-->

            <div class="userSettingsChangePasswordButton">
                <button type="button" class="akcButton">{{lang.setNewPassword}}</button>
            </div>
            <!-- kde má být submit? -->

            <h2>{{lang.deleteAccount}}</h2>
            <div class="userSettingsDeleteAccount clear">
                <button type="button" class="akcButton">{{lang.deleteAccountBtn}}</button>
            </div>
        </div>

    </div>
</form>
