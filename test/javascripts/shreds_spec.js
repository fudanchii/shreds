//= require spec_helper

describe('Shreds app', function () {
  it('is global object', function () {
    (typeof Shreds).should.equal('object');
  });

  it('has sandbox object', function () {
    (Shreds.$ instanceof jQuery).should.equal(true);
  });

  it('has components property', function () {
    (Shreds.components instanceof Array).should.equal(true);
  });

  it('has init function', function () {
    (typeof Shreds.init).should.equal('function');
  });

  it('can render', function () {
    (typeof Shreds.render).should.equal('function');
  });

  it('has syncView function', function () {
    (typeof Shreds.syncView).should.equal('function');
  });
});
