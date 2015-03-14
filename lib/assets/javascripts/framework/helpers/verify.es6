export function verify(condition) {
  if (!condition) {
    var error = new Error('Invariant Violation');
    error.framesToPop = 1;
    throw error;
  }
}
