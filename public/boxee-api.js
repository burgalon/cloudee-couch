
var defineBoxeeControlFunctions = function () {
  // Hook Back/Menu button to ESC keypress
  function hookMenuToEsc(callback) {
    boxee.onKeyboardKeyBack = function() {
      browser.execute('var e = jQuery.Event("keydown"); e.which = 27; e.keyCode=27; $("body").trigger(e);')
    }
  }
  boxee.exec(hookMenuToEsc)

  function setApiMinVersion(args) {
    version = args[0];
    boxee.apiMinVersion = version || 7.0;
  }
  boxee.exec(setApiMinVersion);

  function showNotification(args) {
    var message = args[0];
    var thumbUrl = args[1] || '.';
    var duration = args[2] || 2;

    boxee.showNotification(message, thumbUrl, duration);
  }
  boxee.exec(showNotification);

  function cursorMode() {
    boxee.setMode(boxee.CURSOR_MODE);
  }
  boxee.exec(cursorMode);

  function keyboardMode() {
    boxee.setMode(boxee.KEYBOARD_MODE);
  }
  boxee.exec(keyboardMode);

  function getHttp(args) {
    url = args[0];
    return boxee.getHttp(url);
  }
  boxee.exec(getHttp);

  function openDialogCallback(confirmed) {
    boxee.showNotification("in openDialogCallback " + boxee.browserCallback);
    //browser.execute("window.hi('" + boxee.browserCallback + "(" + confirmed + ")')");
    browser.execute("window." + boxee.browserCallback + "(" + confirmed + ")");
  }
  boxee.exec(openDialogCallback);

  function promptDialog(args) {
    var title = args[0];
    var moreText = args[1] || '';

    boxee.browserCallback = args[2];

    boxee.openDialog("YesNo", title, moreText, 'openDialogCallback');
  }
  boxee.exec(promptDialog);
}

if (!window.boxee) {
  window.boxee = {
    fake: true,
    exec: function(string) {
      console.log("boxee.exec : " + string);
    },
    exec2: function(string) {
      console.log("boxee.exec2 : " + string);
      return '';
    }
  }
} else {
  defineBoxeeControlFunctions();
}

window.boxeeAPI = {

  hookMenuToEsc: function() {
    boxee.exec('hookMenuToEsc()');
  },
  notify: function(message, seconds) {
    seconds = seconds ? seconds : 2;
    var json = JSON.stringify([message, ".", seconds]);
    boxee.exec('showNotification(' + json + ')');
  },
  closeBrowser: function() {
    boxee.exec("browser.shutdown()");
  },
  closeApp: function() {
    boxee.exec("browser.shutdown()");
  },
  showBoxeeOSD: function() {
    boxee.exec("boxee.showBoxeeOSD()");
  },
  getURL: function(url, callback) {
    return $.Deferred(function(dfd) {
      var json = JSON.stringify([url]);
      var data = boxee.exec2("getHttp(" + json + ")");
      setTimeout(function() {
        dfd.resolve();
        callback(data);
      }, 0);
    }).promise();
  },
  clearPauseOverlay: function() {
    boxee.exec("playerState.isPaused = false;");
  },
  showPauseOverlay: function() {
    boxee.exec("playerState.isPaused = true;");
  },
  keyboardMode: function() {
    boxee.exec("keyboardMode()");
  },
  cursorMode: function() {
    boxee.exec("cursorMode()");
  },
  showNotification: function() {
    var array = Array.prototype.slice.call(arguments);
    var json = JSON.stringify(array);
    boxee.exec("showNotification(" + json + ")");
  },
  promptDialog: function(title, moreText, callback) {
    if (typeof callback === 'function') {
      boxee.promptDialogCallback = function(confirmed) {
        callback(confirmed);
      }
      var json = JSON.stringify([title, moreText, 'boxee.promptDialogCallback']);
      boxee.exec("promptDialog(" + json + ")");
    } else if (typeof callback === 'string') {
      var array = Array.prototype.slice.call(arguments);
      var json = JSON.stringify(array);
      boxee.exec("promptDialog(" + json + ")");
    }
  }
};