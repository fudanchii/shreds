function Assert(condition, msg) {
  if (!condition) {
    throw new Error(msg);
  }
}
