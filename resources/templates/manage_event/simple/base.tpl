<div class="modifyEventBase col-md-12">
    <div class="eventBaseInfoBlock floatLeft">
        <div class="inputWithLabel eventNameBlock">
            <label for="eventName">{{lang.eventNameLabel}}*</label>
            <input type="text" class="eventLongInput appManageEventName" id="eventName" value="{{name}}" /><br>
            <div class="errorMessage eventNameValidatorMessage validatorMessage"></div>
        </div>
        <div class="appFromCont">
            <div class="floatLeft inputWithLabel">
                <label for="eventFrom">{{lang.eventFromLabel}}*</label>
                <input type="text" id="eventFrom" class="eventShortInput" value="{{from}}"><br>
                <div class="errorMessage eventFromValidatorMessage validatorMessage"></div>
            </div>
            <div class="floatLeft inputWithLabel shift">
                <label for="eventFromTime">{{lang.eventFromTimeLabel}}</label>
                <input type="text" id="eventFromTime" class="eventShortInput" value="{{fromTime}}"/><br>
                <div class="errorMessage eventFromTimeValidatorMessage validatorMessage"></div>
            </div>
            <div class="clear"></div>
        </div>
        <div class="appToCont">
            <div class="floatLeft inputWithLabel">
                <label for="eventTo">{{lang.eventToLabel}}*</label>
                <input type="text" id="eventTo" class="eventShortInput" value="{{to}}"><br>
                <div class="errorMessage eventToValidatorMessage validatorMessage"></div>
            </div>
            <div class="floatLeft shift inputWithLabel">
                <label for="eventToTime">{{lang.eventToTimeLabel}}</label>
                <input type="text" id="eventToTime" class="eventShortInput" value="{{toTime}}"/><br>
                <div class="errorMessage eventToTimeValidatorMessage validatorMessage"></div>
            </div>
            <div class="clear"></div>
        </div>
    </div>
    <div class="eventImageBlock floatLeft">
    </div>

    <div class="eventAnnotationBlock clear">
        <label for="appEventAnnotation">{{lang.eventAnnotationLabel}}*</label>
        <img class="addEventEditIcon" src="{{editImageSRC}}" title="{{lang.eventAnnotationTitle}}">
        <textarea id="appEventAnnotation" rows="4" cols="100">{{annotation}}</textarea><br>
        <div class="errorMessage eventAnnotationValidatorMessage validatorMessage"></div>
    </div>

    <div class="eventTagsBlock inputWithLabel">
        <div class="tagSmartSelectContainer"></div>
    </div>

    {{#hasPlace}}
        <div class="eventPlaceBlock">
            {{placeName}}
        </div>
    {{/hasPlace}}

    <button class="findAndSelectPlaceOnMap">{{lang.findAndSelectPlaceOnMap}}</button>

</div>


<div id="cropper" class="hidden">
    <div class="appCroppedImage"></div>
    <div>Zoom: </div>
    <div id="cropperZoom"></div>
    <button type="button" class="appCropImage"></button>
</div>