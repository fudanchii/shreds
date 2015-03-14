export function join(/*arguments*/) {
  let joindPath = Array.prototype.reduce.call(arguments, (p, c, i, a) => {
    return p + c + '/';
  }, '');
  return joindPath.replace(/\/{2,}/g, '/').trim().replace(/\/*$/, '');
}
