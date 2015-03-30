import { verify } from 'framework/helpers/verify';

let _prefix = 'ID_',
    _lastID = 1;

export default
class ActionDispatcher {
  constructor() {
    this._isDispatching = false;
    this._isPending = {};
    this._isHandled = {};
    this._callbacks = {};
  }

  dispatch(payload) {
    verify(!this._isDispatching,
           `currently dispatching ${this._currentPayload.type}`);
    this._startDispatching(payload);
    try {
      for (var id in this._callbacks[payload.type]) {
        if (this._isPending[id]) {
          verify(this._isHandled[id], `Overlapped job dispatched for: ${id}`);
          continue;
        }
        verify(this._callbacks[payload.type][id],
               `handler for ${payload.type}/${id} is registered without any callables`);
        this._invokeCallback(id, payload);
      }
    } finally {
      this._stopDispatching();
    }
  }

  register(name, callback) {
    const id = name + ':' + _prefix + _lastID++;
    verify(name, 'can not register unnamed handler');
    this._callbacks[name] || (this._callbacks[name] = {});
    this._callbacks[name][id] = callback;
    return id;
  }

  _startDispatching(payload) {
    for (var id in this._callbacks[payload.type]) {
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
    this._callbacks[payload.type][id](payload);
    this._isHandled[id] = true;
  }
}
