<div class="userSettingsHeader">
    <h1 class="userSettingsHeader1">{{lang.userEventsHeader}}</h1>
    {{#isAdmin}}
        <label>{{lang.showAllEvents}}
        <input type="checkbox" class="showAllEventsCheckbox"{{#showAllEvents}} checked{{/showAllEvents}} />
        </label>
    {{/isAdmin}}
</div>
<div class="userSettingsEvents">
    <div class="eventsLeft">
        {{#events}}
            <div class="eventContainer event{{id}}">

            </div>
        {{/events}}
    </div>
</div>
