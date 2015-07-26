import Component from 'framework/component';

Component.addHelpers({
  unreadIcon(unread) {
    const icon = 'glyphicon-ok-';
    unread = unread === null || _.isUndefined(unread) ? true : unread;
    return icon + (unread ? 'circle' : 'sign');
  },
  unreadLabel(unread) {
    unread = unread === null || _.isUndefined(unread) ? true : unread;
    return unread ? 'read' : 'unread';
  }
});

