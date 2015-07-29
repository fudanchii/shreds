var Router = require('framework/router');

describe('framework/router', function () {
  var router = null,
      msg = '',
      mockDispatcher = {
        dispatch: function (action) {
          msg = action;
        }
      };

  beforeEach(function () {
    msg = {};
  });

  before(function () {
    router = new Router();
    router.map(function (r) {
      r('a');
      r('b', { path: '/bucks' });
      r('c', { path: '/c/:id' });
      r('d', { path: '/' }, function (r) {
        r({ path: 'e' });
      });
      r('f', function (r) {
        r('g');
        r('h', { path: 'heyya' }, function (r) {
          r('i', { path: ':h_id' });
        });
      });
    });
    router.dispatcher = mockDispatcher;
  });

  it('can add static route', function () {
    router.navigate('/a');
    expect(msg).to.be.an('object');
    expect(msg.path).to.equal('/a');
  });

  it('can can add static route with custom path', function () {
    router.navigate('/bucks');
    expect(msg.path).to.equal('/bucks');
    expect(msg.name).to.equal('b');
  });

  it('can add route with params', function () {
    router.navigate('/c/1234');
    expect(msg.path).to.equal('/c/1234');
    expect(msg.name).to.equal('c');
    expect(msg.data).to.have.keys('id');
    expect(msg.data.id).to.equal('1234');
  });

  it('can add nested routes', function () {
    router.navigate('/');
    expect(msg.path).to.equal('/');
    expect(msg.name).to.equal('d');
    router.navigate('/e');
    expect(msg.path).to.equal('/e');
    expect(msg.name).to.equal('d');
  });

  it('should have concatenated name for named nested routes', function () {
    router.navigate('/f');
    expect(msg.path).to.equal('/f');
    expect(msg.name).to.equal('f');

    router.navigate('/f/g');
    expect(msg.path).to.equal('/f/g');
    expect(msg.name).to.equal('f/g');

    router.navigate('/f/heyya');
    expect(msg.path).to.equal('/f/heyya');
    expect(msg.name).to.equal('f/h');

    router.navigate('/f/heyya/123456');
    expect(msg.path).to.equal('/f/heyya/123456');
    expect(msg.name).to.equal('f/h/i');
    expect(msg.data).to.have.keys('h_id');
    expect(msg.data.h_id).to.equal('123456');
  });
});
