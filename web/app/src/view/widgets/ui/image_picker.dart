part of view;

class ImagePickerWidget extends Widget {
  static const List supportedFormat = const [".png", ".jpg", ".jpeg", ".gif"];
  Element _imageContainer;
  Element _imageToSelect;
  Element _imageSelected;
  Element _imageCancelButton;
  InputElement _imageFileInput;
  String label;
  String _imgSrc;
  int width;
  int height;
  bool imageSelected;
  Element _slider;
  List<Function> onChange = [];
  List<Function> onCancel = [];

  void set imgSrc(String val) {
    _imgSrc = val;
    if (val != null) {
      imageSelected = true;
    } else {
      imageSelected = false;
    }
    requestRepaint();
  }

  String get imgSrc => _imgSrc;

  ImagePickerWidget(this.width, this.height, {String imgSrc, this.label}) {
    _imgSrc = imgSrc;
    template = parse(resources.templates.ui.imagePicker);
    resetWidget();
    widgetLang = lang.ui.imagePicker.toMap();
    layoutModel.leftPanelModel.createEvent.onImageChanged.add(() {
      this.imgSrc = layoutModel.leftPanelModel.createEvent.event.imageData;
    });
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }

  @override
  void functionality() {
    _imageContainer = select(".imagePickerCont");
    _imageToSelect = select(".eventImageToSelect");
    _imageFileInput = _imageToSelect.querySelector("input");
    _imageFileInput.onChange.listen(_bindFileInputOnChange);
    if (imageSelected) {
      _imageSelected = select(".eventImageSelected");
      _imageCancelButton = select(".imageCancelButton");
      ImageElement image = _imageSelected.querySelector(".eventImage");
      image.src = imgSrc;
      _imageCancelButton.onClick.listen((_) {
        imgSrc = null;
        onChange.forEach((Function f) => f());
      });
      _imageContainer.parent.onClick.listen((_) {
        _imageFileInput.click();
      });
    } else {
      _imageFileInput.onDragOver.listen(_onDragOver);
    }
    _imageContainer.onDragLeave.listen(_onDragLeave);
    _imageContainer.onDrop.listen(_onDrop);

    _slider = select("#cropperZoom");
  }

  @override
  Map out() {
    Map out = {};
    out["lang"] = lang.ui.imagePicker.toMap();
    out["imageSelected"] = imageSelected;
    out["showLabel"] = label != null;
    out["label"] = label;
    return out;
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }

  void _onDragOver(MouseEvent event) {
    event.stopPropagation();
    event.preventDefault();
    _imageContainer.classes.add('hover');
    event.dataTransfer.dropEffect = 'copy';
  }

  void _onDrop(MouseEvent event) {
    event.stopPropagation();
    event.preventDefault();
    _imageContainer.classes.remove('hover');
    _imageToSelect.classes.add('hidden');
    _processFile(event.dataTransfer.files.first);
  }

  void _processFile(File file) {
    FileReader reader = new FileReader();
    reader.onLoad.listen((_) {
      js.context.callMethod("doCrop", [
        reader.result,
        lang.ui.imagePicker.sendImage,
            (CanvasElement canvas, js.JsObject cropBoxData) {
          CanvasElement newCanvas = new CanvasElement();
          int width = cropBoxData["width"].toInt();
          int height = cropBoxData["height"].toInt();
          newCanvas
            ..width = width
            ..height = height;
          CanvasRenderingContext2D context = newCanvas.context2D;
          context.scale(width / canvas.width, width / canvas.width);
          context.drawImage(canvas, 0, 0);
          imgSrc = newCanvas.toDataUrl();
          onChange.forEach((Function f) => f());
        },
        width,
        height,
        _slider
      ]);
    });
    reader.readAsDataUrl(file);
  }

  void resetWidget() {
    imageSelected = false;
  }

  void _bindFileInputOnChange(_) {
    if (_imageFileInput.files.isEmpty) {
      _imageFileInput.style.opacity = "1";
      return;
    }
    File file = _imageFileInput.files.first;
    String ext = file.name.substring(file.name.lastIndexOf("."));
    ext = ext.toLowerCase();
    if (supportedFormat.contains(ext)) {
      _processFile(file);
    } else {
      _imageFileInput.value = "";
      window.alert(widgetLang["unsupported"]);
    }
  }

  void _onDragLeave(MouseEvent event) {
    event.stopPropagation();
    event.preventDefault();
    if (event.target != _imageContainer && event.target != _imageFileInput && event.target != _imageToSelect) {
      _imageContainer.classes.remove('hover');
    }
  }
}
