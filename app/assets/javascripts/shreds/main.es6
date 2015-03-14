import Application from 'framework/application';

import Routes from 'shreds/services/routes';
import FeedUpdate from 'shreds/services/feed_update';

const Shreds = new Application({
  name: "shreds",
  debug: true
});

export default Shreds;
