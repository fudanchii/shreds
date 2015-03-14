import { verify } from 'framework/helpers/verify';

let _prefix = 'ID_',
    _lastID = 1;

export default
class ActionDispatcher {
  constructor() {
    this._isDispatching = false;
    this._isPending = {};
    this._isHandled = {};
    this.storeCallbacks = {};
  }

  dispatch(payload) {
    verify(!this._isDispatching);
    this._startDispatching(payload);
    try {
      for (var id in this.storeCallbacks[payload.type]) {
        if (this._isPending[id]) {
          verify(this._isHandled[id]);
          continue;
        }
        verify(this.storeCallbacks[payload.type][id]);
        this._invokeCallback(id, payload);
      }
    } finally {
      this._stopDispatching();
    }
  }

  waitFor(ids, payload) {
    verify(this._isDispatching);
    for (var i = 0; i < ids.length; i++) {
      var name = ids[i].split(':')[0];
      if (this._isPending[ids[i]]) {
        verify(this._isHandled[ids[i]]);
        continue;
      }
      verify(this.storeCallbacks[name][ids[i]]);
      this._invokeCallback(ids[i], payload);
    }
  }

  register(name, deps, callback) {
    let id = name + ':' + _prefix + _lastID++;
    this.storeCallbacks[name] || (this.storeCallbacks[name] = {});
    this.storeCallbacks[name][id] = callback;
    return id;
  }

  serviceRegister(callback) {
    let id = _prefix + _lastID++;
    this.serviceCallbacks[id] = callback;
    return id;
  }

  _startDispatching(payload) {
    for (var id in this.storeCallbacks[payload.type]) {
      this._isPending[id] = false;
      this._isHandled[id] = false;
    }
    this._isDispatching = true;
  }

  _stopDispatching() {
    this._isDispatching = false;
  }

  _invokeCallback(id, payload) {
    this._isPending[id] = true;
    this.storeCallbacks[payload.type][id](payload);
    this._isHandled[id] = true;
  }
}
