import Decorator from 'framework/decorator';

Decorator.add('setTitle', (title) => {
  document.title = (title || 'Feeds') + ' · shreds';
});
