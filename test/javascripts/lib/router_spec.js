//= require spec_helper

describe('router.js', function () {
  var router = null;
  var msg = '';

  before(function () {
    router = new Router({ debug: false, anchor: Shreds.$ });
    Shreds.$.on('action:foo', function () {
      msg = 'foo';
    });
    Shreds.$.on('action:hello', function (ev, data) {
      msg = 'Hello, ' + data.name + '!';
    });
  });

  beforeEach(function () {
    msg = '';
  });

  it('is global object', function () {
    (typeof Router).should.equal('function');
  });

  it('may be instantiated', function () {
    (typeof router).should.equal('object');
  });

  it('initially has no route', function () {
    router.routes.length.should.equal(0);
  });

  it('can define routes', function () {
    (typeof router.define).should.equal('function');
    router.define('/foo', 'action:foo');
    router.routes.length.should.equal(1);
  });

  it('can navigate to routes', function () {
    router.navigate('/foo');
    msg.should.equal('foo');
  });

  it('can define parameterized routes', function () {
    router.define('/hello/:name', 'action:hello');
    router.routes.length.should.equal(2);
  });

  it('can navigate through parameterized routes', function () {
    router.navigate('/hello/world');
    msg.should.equal('Hello, world!');
  });

});
