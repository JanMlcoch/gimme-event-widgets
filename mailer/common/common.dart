library akcnik.mailer.common;

import 'dart:async';

typedef void CancelCallback([Future lastProcess]);

Future periodicTimer(Duration duration, Future func(CancelCallback cancel)) {
  Completer completer = new Completer();

  new Timer.periodic(duration, (Timer innerTimer) {
    func(([Future lastProcess]) {
      innerTimer.cancel();
      if (lastProcess != null) {
        lastProcess.then((_) {
          completer.complete();
        });
      } else {
        completer.complete();
      }
    });
  });
  return completer.future;
}
