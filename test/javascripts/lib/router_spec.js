//= require spec_helper

describe('router.js', function () {
  var router = null;
  var msg = '';

  before(function () {
    router = new Router({ debug: false, anchor: Shreds.$ });
    Shreds.$.on('action:foo1', function () {
      msg = 'foo1';
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
    router.define('/foo1', 'action:foo1');
    router.routes.length.should.equal(1);
  });

  it('can navigate to routes', function () {
    router.navigate('/foo1');
    msg.should.equal('foo1');
  });

});
