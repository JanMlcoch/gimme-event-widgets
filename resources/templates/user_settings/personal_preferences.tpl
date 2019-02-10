<div class="userSettingsHeader">
    <h1 class="userSettingsHeader1">{{lang.userPersonalPreferencesHeader}}</h1>
</div>
<form>
    <div class="userSettingsPreferences">

        <div class="inputWithLabel">
            <label for="preferencesTags"><h3>{{lang.preferencesTags}}:</h3></label>
            <input type="text" id="preferencesTags" value=""><br>
        </div>
        <div class="tagsBox">
            {{#tags}}
                <div class="tag">{{name}}<div class="removeTag"></div></div>

            {{/tags}}
        </div>

        <h3>{{lang.favoriteGenres}}</h3>
        <div class="genres">
            <div class="genre"><input type="checkbox">Hudební festival</div>
            <div class="genre"><input type="checkbox">Muzikál, opera, balet</div>
            <div class="genre"><input type="checkbox">Uzavřené akce</div>
            <div class="genre"><input type="checkbox">Zájezdy a dovolené</div>
            <div class="genre"><input type="checkbox">Koncert</div>
            <div class="genre"><input type="checkbox">Sportovní akce - účastník</div>
            <div class="genre"><input type="checkbox">Dny otevřených dveří</div>
            <div class="genre"><input type="checkbox">Gastro akce</div>
            <div class="genre"><input type="checkbox">Divadlo</div>
            <div class="genre"><input type="checkbox">Sportovní akce - divák</div>
            <div class="genre"><input type="checkbox">Tematické akce</div>
            <div class="genre"><input type="checkbox">Vzdělávání a věda</div>
            <div class="genre"><input type="checkbox">Výstava</div>
            <div class="genre"><input type="checkbox">Závody</div>
            <div class="genre"><input type="checkbox">Jarmarky, trhy</div>
            <div class="genre"><input type="checkbox">Památky</div>
        </div>

    </div>
</form>
