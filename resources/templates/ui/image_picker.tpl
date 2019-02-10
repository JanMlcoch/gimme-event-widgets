{{#showLabel}}
    <label for="appEventImage">{{label}}</label>
{{/showLabel}}
<div class="imagePickerCont">
    {{#imageSelected}}
        <div class="eventImageSelected">
            <img class="eventImage">
            <button type="button" class="imageCancelButton">X</button>
        </div>
    {{/imageSelected}}

    <div class="eventImageToSelect{{#imageSelected}} hidden{{/imageSelected}}">
        <input id="appEventImage" type="file"/><br>
    </div>

</div>
<div id="cropper" class="hidden">
    <div class="appCroppedImage"></div>
    <div>Zoom:</div>
    <div id="cropperZoom"></div>
    <button type="button" class="appCropImage"></button>
</div>
