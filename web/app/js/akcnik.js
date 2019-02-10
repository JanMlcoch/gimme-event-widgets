/**
 * Created by Tal on 23.02.2016.
 */

function setDatePickerRegional(lang, regional) {
  $.datepicker.regional[lang] = regional;
  $.datepicker.setDefaults($.datepicker.regional[lang]);
}

function createDatePicker(selector, changed, onClose) {
  $(selector).datepicker({
    "onChange": changed,
    "onClose": onClose,
    "minDate": 0
  })
}

window.fbAsyncInit = function () {
  FB.init({
    appId: '2030883780470289',
    xfbml: true,
    version: 'v2.6'
  });
  setTimeout(function () {
    if (window.afterFacebookLoad) {
      for (var i = 0; i < window.afterFacebookLoad.length; i++) {
        window.afterFacebookLoad[i]();
      }
    }
  }, 0);
};

// function bindFacebookFunctionality(checkFacebookStatusFunction) {
//     (function(d, s, id){
//         var js, fjs = d.getElementsByTagName(s)[0];
//         if (d.getElementById(id)) {return;}
//         js = d.createElement(s); js.id = id;
//         js.src = "//connect.facebook.net/en_US/sdk.js";
//         fjs.parentNode.insertBefore(js, fjs);
//     }(document, 'script', 'facebook-jssdk'));
//     window.checkFacebookStatus = checkFacebookStatusFunction;
// }
function loadFacebookSDK(callback) {
  if (window.FB) {
    FB.XFBML.parse();
    callback();
    return;
  }
  if (window.afterFacebookLoad) {
    window.afterFacebookLoad.push(callback);
  } else {
    window.afterFacebookLoad = [callback];
  }
  (function (d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) {
      return;
    }
    js = d.createElement(s);
    js.id = id;
    js.src = "//connect.facebook.net/en_US/sdk.js";
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'facebook-jssdk'));
}

