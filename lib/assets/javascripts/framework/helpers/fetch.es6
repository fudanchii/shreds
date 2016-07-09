import fetch from 'fetch';

export default class Fetch {
  constructor(options = {}) {
    this.baseURL = options.baseURL ||
      (document.location.protocol + '//' + document.location.host);
    this.endpoints = options.endpoints;
    this.headers = new Headers(options.headers);
    if (options.errorHandler) {
      this.dispatcher = options.errorHandler.dispatcher;
      this.failAction = options.errorHandler.failAction;
    }
  }

  defaults() {
    return {
      method: 'GET',
      headers: this.headers,
      credentials: 'same-origin',
      redirect: 'follow'
    };
  }

  failHandling(message, error) {
    if ((!this.dispatcher) || (!this.failAction)) {
      console.error(message, error);
      return;
    }
    this.dispatcher.dispatch({
      type: this.failAction,
      failMsg: message,
      data: error
    });
  }

  resolveEndpoint(id, args = {}) {
    if (typeof this.endpoints[id] !== 'string') {
      return '';
    }

    let path = this.endpoints[id].replace(/:([\w]+)/g, (match, captured) => {
      return (args.params || {})[captured].replace(/^\/+|\/+$/g, '') || match;
    });

    let qkey = Object.keys(args.queries || {});
    if (qkey.length) {
      url = new URL(this.baseURL);
      url.pathname = path;
      qkey.forEach((key) => {
        url.searchParams.append(key, args.queries[key]);
      });
      return url;
    }

    return path;
  }

  doFetch(endpoint, args) {
    let url = this.resolveEndpoint(endpoint, args);
    return fetch(url, args.inits || this.defaults())
      .catch((ex) => this.failHandling('cannot do fetch', ex));
  }

  getJSON(endpoint, args) {
    return this.doFetch(endpoint, args).then((response) => response.json())
      .catch((ex) => this.failHandling('cannot parse response as json', ex));
  }

}

