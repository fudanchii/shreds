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
    router.dispatcher = mockDispatcher;
  });

  it('can add static route', function () {
    router.addRoute('a');
    router.navigate('/a');
    expect(msg).to.be.an('object');
    expect(msg.path).to.equal('/a');
  });

  it('can can add static route with custom path', function () {
    router.addRoute('b', { path: '/bucks' });
    router.navigate('/bucks');
    expect(msg.path).to.equal('/bucks');
  });

  it('can add route with params', function () {
    router.addRoute('c', { path: '/c/:id' });
    router.navigate('/c/1234');
    expect(msg.path).to.equal('/c/1234');
    expect(msg.data).to.have.keys('id');
    expect(msg.data.id).to.equal('1234');
  });

  it('can add nested routes', function () {
    router.addRoute('d', { path: '/' }, function (r) {
      r(null, { path: 'e' });
    });
    router.navigate('/');
    expect(msg.path).to.equal('/');
    router.navigate('/e');
    expect(msg.path).to.equal('/e');
  });
});
