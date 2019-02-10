<ul class="cityAutocompleteOptionsList {{#empty}}hidden{{/empty}}">
    {{#options}}
        <li class="cityAutocompleteOptionItem" data-id="{{placeId}}">
            {{cityName}}
        </li>
    {{/options}}
</ul>