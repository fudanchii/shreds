//= require spec_helper

describe('Shreds App', function () {
  it('is a global object', function () {
    expect(Shreds).to.be.an('object');
  });

  it('has sandbox object', function () {
    expect(Shreds.$).to.be.an.instanceof(jQuery);
  });

  it('has components property', function () {
    expect(Shreds.components).to.be.an.instanceof(Array);
  });

  it('has init function', function () {
    expect(Shreds).itself.to.respondTo('init');
  });

  it('can render', function () {
    expect(Shreds).itself.to.respondTo('render');
  });

  it('has syncView function', function () {
    expect(Shreds).itself.to.respondTo('syncView');
  });
});
