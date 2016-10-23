import fetch from 'fetch';

export default class Fetch {
  constructor(options = {}) {
    this.baseURL = options.baseURL ||
      (document.location.protocol + '//' + document.location.host);
    this.endpoints = options.endpoints;
    this.headers = new Headers(options.headers);
  }

  defaults(inits = {}) {
    return Object.assign({}, {
      method: 'GET',
      headers: this.headers,
      credentials: 'same-origin',
      redirect: 'follow'
    }, inits);
  }

  resolveEndpoint(id, args = {}, queries = {}) {
    if ((!this.endpoints[id]) || typeof this.endpoints[id].url !== 'string') {
      return '';
    }

    let path = this.endpoints[id].url.replace(/:([\w]+)/g, (match, captured) => {
      return (args[captured] + '').replace(/^\/+|\/+$/g, '') || match;
    });

    let qkey = Object.keys(queries);
    if (qkey.length) {
      const url = new URL(this.baseURL);
      url.pathname = path;
      qkey.forEach((key) => {
        url.searchParams.append(key, args.queries[key]);
      });
      return url;
    }

    return path;
  }

  doFetch(endpoint, args, queries, inits = {}) {
    let url = this.resolveEndpoint(endpoint, args, queries);
    inits.method = inits.method || this.endpoints[endpoint].method;
    return fetch(url, this.defaults(inits));
  }

  json(endpoint, args, queries, inits) {
    return this.doFetch(endpoint, args, queries, inits)
      .then(response => response.json());
  }

  cmd(endpoint, args, queries, inits) {
    return this.doFetch(endpoint, args, queries, inits)
      .then(response => {
        if (!response.ok) {
          throw `${response.status} (${response.statusText})`;
        }
      });
  }

  static r(method, url) {
    return {method, url};
  }

  static get(url) {
    return this.r('GET', url);
  }

  static post(url) {
    return this.r('POST', url);
  }

  static put(url) {
    return this.r('PUT', url);
  }

  static patch(url) {
    return this.r('PATCH', url);
  }

}

