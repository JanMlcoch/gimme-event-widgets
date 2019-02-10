<div class="facebookEventLeft" {{^hasImage}}hidden{{/hasImage}}>
    {{#hasImage}}
        <a href="{{fbLink}}" target="_blank">
            <img class="facebookEventImage" src="{{imgUrl}}" alt="Facebook event image" width="150px">
        </a>
    {{/hasImage}}
</div>
<div class="facebookEventRight">
    <div class="facebookEventTop">
        <a href="{{fbLink}}" target="_blank"><h2>{{name}}</h2></a>
        <span>{{from_date}}</span><span>{{to_date}}</span>
        <div>{{place}}</div>
    </div>
    <div class="facebookEventBottom">
        <div class="facebookEventAction">
            {{#isImported}}
                <span class="facebookEventImported">{{lang.imported}}</span>
            {{/isImported}}
            {{^isImported}}
                <button type="button" class="facebookEventImportButton akcButton small">{{lang.importEvent}}</button>
            {{/isImported}}
        </div>
    </div>
</div>
