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
    expect(Router).to.be.a('function');
  });

  it('may be instantiated', function () {
    expect(router).to.be.an('object');
  });

  it('initially has no route', function () {
    expect(router.routes).to.have.length(0);
  });

  it('can define routes', function () {
    expect(router.define).to.be.a('function');
    router.define('/foo', 'action:foo');
    expect(router.routes).to.have.length(1);
  });

  it('can navigate to routes', function () {
    router.navigate('/foo');
    expect(msg).to.equal('foo');
  });

  it('can define parameterized routes', function () {
    router.define('/hello/:name', 'action:hello');
    expect(router.routes).to.have.length(2);
  });

  it('can navigate through parameterized routes', function () {
    router.navigate('/hello/world');
    expect(msg).to.equal('Hello, world!');
  });

});
