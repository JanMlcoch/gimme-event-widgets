<div class="plannedEventsContainer">
    <h2>{{lang.title}}</h2>
    {{#events}}
        <div class="plannedEvent" id="{{id}}">
            <div class="plannedEventLeft">
                <div class="plannedEventImage">

                </div>
            </div>
            <div class="plannedEventRight">
                <h4>{{name}}</h4>
                <div>{{dateFrom}}  -  {{dateTo}}</div>
                <div class="plannedEventDescription">
                    {{annotation}}
                </div>
            </div>
        </div>
    {{/events}}
</div>