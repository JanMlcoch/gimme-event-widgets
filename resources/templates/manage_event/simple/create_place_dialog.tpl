<h3>{{lang.eventCreateNewPlace}}</h3>

<div class="inputWithLabel">
    <label for="eventPlaceName" class="inputWithLabel">{{lang.eventPlaceNameLabel}}</label>
    <input type="text" id="eventPlaceName" value="{{placeName}}">
    <div class="errorMessage eventPlaceNameValidatorMessage validatorMessage"></div>
</div>
<div class="eventPlaceDescriptionBlock clear">
    <label for="eventPlaceDescription" class="block">{{lang.eventPlaceDescriptionLabel}}</label>
    <textarea id="eventPlaceDescription" rows="5" cols="50">{{description}}</textarea>
    <div class="errorMessage eventPlaceDescriptionValidatorMessage validatorMessage"></div>
</div>
<div class="inputWithLabel">
    <label for="eventPlaceGPS" class="eventLabelWidth">{{lang.eventPlaceGPSLabel}}</label>
    <input type="text" id="eventPlaceGPS" value="{{placeGPS}}" disabled>
    <div class="errorMessage eventPlaceGPSValidatorMessage validatorMessage"></div>
</div>
<button type="button" class="akcButton shift appCretePlaceButton">{{lang.createPlaceLabel}}</button>