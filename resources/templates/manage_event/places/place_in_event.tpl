{{#placesInEvent}}
    <div class="eventPlaceDetail" id="{{placeId}}">
        <div class="eventPlaceName">{{name}}</div>
        <div class="eventPlaceFlag">{{mapFlag}}</div>
        <div class="eventPlaceButtons">
            <button type="button" class="editButton akcButton small">{{lang.eventPlacesEditButton}}</button>
            <button type="button" class="removeButton akcButton small">{{lang.eventPlacesRemoveButton}}</button>
        </div>
        <div class="eventPlaceDescription">{{description}}</div>
    </div>
{{/placesInEvent}}