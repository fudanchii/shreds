import Application from 'framework/application';

import RoutesService from 'shreds/services/routes';
import WebAPIService from 'shreds/services/web_api';
import NProgressService from 'shreds/services/nprogress';
import ScrollService from 'shreds/services/scroll';

const Shreds = new Application({
  name: "shreds",
  debug: true
});

export default Shreds;
