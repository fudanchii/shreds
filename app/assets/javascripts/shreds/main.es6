import Application from 'framework/application';

import RoutesService from 'shreds/services/routes';
import WebAPIService from 'shreds/services/web_api';
import NProgressService from 'shreds/services/nprogress';
import ScrollService from 'shreds/services/scroll';

import ShredsAppStore from 'shreds/stores/shreds_app';

class ShredsAppView extends Component {
  static inject() {
    return {
      template: this.template('main_view'),
      data: ShredsAppStore.getData()
    };
  }
}

const Shreds = new Application({
  name: "shreds",
  debug: true,
  main: ShredsAppView
});

export default Shreds;
