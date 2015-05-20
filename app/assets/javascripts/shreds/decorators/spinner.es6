import Ladda from 'Ladda';

import Decorator from 'framework/decorator';

const spinnerRegistry = {};

function spin(el) {
  const spinner = Ladda.create(el);
  spinner.start();
  return spinner;
}

function stop(spinner) {
  if (spinner && spinner.stop) { spinner.stop(); }
}

Decorator.add('startSubscribeSpinner', () => {
  spinnerRegistry.subscribeSpinner = spin(document.getElementById('btnSubmitFeed'));
});

Decorator.add('stopSubscribeSpinner', () => {
  stop(spinnerRegistry.subscribeSpinner);
  delete spinnerRegistry.subscribeSpinner;
});

Decorator.add('startUploadSpinner', () => {
  spinnerRegistry.uploadSpinner = spin(document.getElementById('btnOPMLUpload'));
});

Decorator.add('stopUploadSpinner', () => {
  stop(spinnerRegistry.uploadSpinner);
  delete spinnerRegistry.uploadSpinner;
});
