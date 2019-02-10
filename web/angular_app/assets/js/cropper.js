window.$cropperDiv = null;

function doCrop(urlData, langButtonSend, imageStringCallback, baseWidth, baseHeight, sliderElement) {
    function process() {
        var cropBoxData = $image.cropper("getCropBoxData");
        var canvas = $image.cropper("getCroppedCanvas", baseWidth, baseHeight);
        console.log("canvas size=" + canvas.width + " " + canvas.height);
        imageStringCallback(canvas, cropBoxData);
        $cropperDiv.dialog("close");
    }

    var image = new Image();

    image.src = urlData;
    var width = window.innerWidth * 0.8 - 50;
    var height = (window.innerHeight * 0.8) - 80;
    var imageWidth = image.width;
    var imageHeight = image.height;
    var imageAspect = imageWidth / imageHeight;
    var aspect = width / height;
    var dialogWidth;

    var dialogHeight;
    if (aspect > imageAspect) {
        dialogWidth = height * imageAspect;
        dialogHeight = height;
    } else {
        dialogWidth = width;
        dialogHeight = width / imageAspect;
    }

    window.$image = $(image);
    if ($cropperDiv != null) {
        try {
            $cropperDiv.dialog("close");
        }catch (e){

        }
        $cropperDiv.remove();
    }
    $cropperDiv = $("#cropper");
    if ($cropperDiv.length == 0) {
        alert("add cropper div to template");
    }
    $cropperDiv.show();
    $cropperDiv.removeClass("hidden");
    var $cropperImageDiv = $cropperDiv.find(".appCroppedImage");
    var $cropperButton = $cropperDiv.find(".appCropImage");
    $cropperImageDiv.empty();
    $cropperImageDiv.css({
        "width": dialogWidth,
        "height": dialogHeight
    });
    $cropperImageDiv.append($image);
    $cropperDiv.dialog({
        "width": dialogWidth + 50,
        "height": dialogHeight + 115
    });
    $image.cropper({
        aspectRatio: 1,
        autoCropArea: 0.5,
        strict: true,
        guides: false,
        highlight: false,
        dragCrop: false,
        cropBoxMovable: true,
        cropBoxResizable: false,
        minCropBoxWidth: baseWidth,
        minCropBoxHeight: baseHeight
    });

    var _lastValue = 0;
    $(sliderElement).slider({
        value: 0,
        slide: function (event, ui) {
            var delta = ui.value - _lastValue;
            _lastValue = ui.value;
            // var multiplicator = ui.value/100;
            // multiplicator = multiplicator*(100/_percentualState);
            // _percentualState*=(multiplicator+1);
            // console.log("call "+(_percentualState));
            $image.cropper("zoom", delta / 100);
        },
        min: -100,
        max: 100
    });

    $cropperButton.text(langButtonSend).click(function () {
        process();
    });
}