import Decorator from 'framework/decorator';

const spinnerRegistry = {};

function spin(el) {
  el.classList.add('disabled');
  el.classList.add('loading');
  return el;
}

function stop(spinner) {
  if (spinner) {
    spinner.className.replace(/\s?disabled\s?/, '');
    spinner.className.replace(/\s?loading\s?/, '');
  }
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
