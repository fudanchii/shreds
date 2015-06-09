import Component from 'framework/component';

Component.addHelpers({
  unreadIcon(unread) {
    const icon = 'glyphicon-ok-';
    unread = unread === null || kind(unread) === 'undefined' ? true : unread;
    return icon + (unread ? 'circle' : 'sign');
  },
  unreadLabel(unread) {
    unread = unread === null || kind(unread) === 'undefined' ? true : unread;
    return unread ? 'read' : 'unread';
  }
});

