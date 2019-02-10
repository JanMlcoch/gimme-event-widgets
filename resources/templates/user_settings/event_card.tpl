<div class="eventDate">
    -&nbsp; {{date}}
</div>
<div class="eventContent">
    <div class="eventContentLeft">
        <div class="eventIconImage">

        </div>
    </div>
    <div class="eventContentMiddle">
        <div class="eventContentLeftTop">
            <h3>{{name}}</h3>
        </div>
        <div class="eventContentLeftBottom">
            <div class="eventContentPlace">{{placeName}} / {{placeCity}}</div>
            <span class="eventContentAnnotation">{{annotationShort}}</span>
            {{#showMore}}
                (<a class="showMoreLink" href="javascript:;">{{lang.showMore}}</a>)
            {{/showMore}}
        </div>
    </div>
    <div class="eventContentRight">
        {{#past}}
            <button type="button" class="akcButton cloneButton">{{lang.cloneEvent}}</button>
        {{/past}}
        {{^past}}
            <button type="button" class="akcButton editButton">{{lang.editEvent}}</button>
        {{/past}}
        <button type="button" class="akcButton deleteButton">{{lang.deleteEvent}}</button>
    </div>
</div>