<div class="cityAutocompleteCont">

    <input type="text" title="city" value="{{selectedCity}}" class="cityAutocompleteInput {{^showInput}}hidden{{/showInput}}"/>
    <div class="cityAutocompleteSelectedValue {{#showInput}}hidden{{/showInput}}">{{selectedCity}}</div>

    <img class="userSettingsEditIcon cityAutocompleteChange {{#showInput}}hidden{{/showInput}}" src="{{editImageSRC}}">
    <div class="cityAutocompleteOptionsContainer {{^showInput}}hidden{{/showInput}}"></div>
</div>

<div class="foundCities">

</div>