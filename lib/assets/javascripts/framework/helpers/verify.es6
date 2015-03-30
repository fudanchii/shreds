export function verify(condition, reason) {
  if (!condition) {
    var error = new Error('Invariant Violation: ' + reason);
    error.framesToPop = 1;
    throw error;
  }
}
