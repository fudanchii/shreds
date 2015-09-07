import Decorator from 'framework/decorator';

const spinnerRegistry = {};

function spin(el) {
  el.classList.add('disabled');
  el.classList.add('loading');
  return el;
}

function stop(spinner) {
  if (spinner) {
    spinner.classList.remove('disabled');
    spinner.classList.remove('loading');
  }
}

Decorator.add('startSubscribeSpinner', () => {
  spinnerRegistry.subscribeSpinner = spin(document.getElementById('button-submit-feed'));
});

Decorator.add('stopSubscribeSpinner', () => {
  stop(spinnerRegistry.subscribeSpinner);
  delete spinnerRegistry.subscribeSpinner;
});

Decorator.add('startUploadSpinner', () => {
  spinnerRegistry.uploadSpinner = spin(document.getElementById('button-OPML-upload'));
});

Decorator.add('stopUploadSpinner', () => {
  stop(spinnerRegistry.uploadSpinner);
  delete spinnerRegistry.uploadSpinner;
});
