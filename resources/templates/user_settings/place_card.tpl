<div class="placeInfoRow">
    <div class="placeInfoLeft">
        {{#isEdit}}
            <label>{{lang.placeName}}
                <input type="text" class="placeName" value="{{name}}">
            </label>
            <label>{{lang.placeGPS}}
                <input type="text" class="placeGPS" value="{{latitude}},{{longitude}}">
            </label>
            <button class="selectInMap">{{lang.selectInMap}}</button>
        {{/isEdit}}
        {{^isEdit}}
            <h2>{{name}}</h2>
            <p>N: {{latitude}}</p>
            <p>E: {{longitude}}</p>
        {{/isEdit}}
    </div>
    <div class="placeInfoRight">
        <h2>{{city}}</h2>
        <div>{{region}}</div>
        {{#haveEvent}}<div class="placeInfoUsed">{{lang.usedInEvent}}</div>{{/haveEvent}}
    </div>
</div>
<div class="placeDescriptionRow">
    {{#isEdit}}
        <label>{{lang.placeDescription}}<br>
            <textarea rows="3" cols="60" class="placeDescription">{{descriptionToEdit}}</textarea>
        </label>
    {{/isEdit}}
    {{^isEdit}}
        {{description}}
    {{/isEdit}}
</div>
{{^isEdit}}
    <button class="editButton akcButton">{{lang.edit}}</button>
    <button class="deleteButton akcButton">{{lang.delete}}</button>
{{/isEdit}}
{{#isEdit}}
    <button class="confirmButton akcButton">{{lang.confirmEdit}}</button>
    <button class="cancelButton akcButton">{{lang.cancelEdit}}</button>
{{/isEdit}}
