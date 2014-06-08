//= require spec_helper

describe('Shreds\'s "action" component:', function () {
  describe('markAsRead', function () {
    it('is a function', function () {
      expect(Shreds.action).itself.to.respondTo('markAsRead');
    });
  });
});
