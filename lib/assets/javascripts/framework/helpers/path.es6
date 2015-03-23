export function join(/*arguments*/) {
  let joindPath = Array.prototype.reduce.call(arguments, (p, c, i, a) => {
    if (!c) { return p; }
    return p + c + '/';
  }, '');
  return joindPath.replace(/\/{2,}/g, '/').trim().replace(/\/*$/, '');
}
