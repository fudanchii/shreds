import $ from 'jquery';
import I18n from 'I18n';

import Decorator from 'framework/decorator';

import NotificationActions from 'shreds/actions/notification';
import SubscriptionActions from 'shreds/actions/subscription';

Decorator.add('selectFileThenUpload', () => {
  $('#fileupload').trigger('click');
});

Decorator.add('initFileUpload', () => {
  $('#fileupload').fileupload({ dataType: 'json', replaceFileInput: false })
                  .on('fileuploadstart', () => { SubscriptionActions.startUploadSpinner(); })
                  .on('fileuploaddone',  (e, data) => {
                    const result = data.result;
                    if (result && result.error) {
                      NotificationActions.error(result.error);
                      SubscriptionActions.stopUploadSpinner();
                      return;
                    }
                    SubscriptionActions.opmlUploaded(result);
                  })
                  .on('fileuploadfail', () => {
                    NotificationActions.error(I18n.t('js.fail.upload'));
                    SubscriptionActions.stopUploadSpinner();
                  });
});
