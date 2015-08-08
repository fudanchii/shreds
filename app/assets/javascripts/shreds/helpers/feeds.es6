import Component from 'framework/component';

Component.addHelpers({
  unreadIcon(unread) {
    unread = unread === null || _.isUndefined(unread) ? true : unread;
    return (unread ? 'radio' : 'check circle outline');
  },
  unreadLabel(unread) {
    unread = unread === null || _.isUndefined(unread) ? true : unread;
    return unread ? 'read' : 'unread';
  }
});

