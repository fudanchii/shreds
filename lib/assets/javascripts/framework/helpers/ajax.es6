//= require framework/helpers/path
//= require framework/helpers/errors

import $ from 'jquery';
import { join } from 'framework/helpers/path';
import { fail } from 'framework/helpers/errors';


const req = {
  init(opts) {
    if (this.initialized) {
      console.error("Can't initialize req multiple times");
      return;
    }
    this.dispatcher = opts.dispatcher || fail("Need a dispatcher.");
    this.failAction = opts.failAction || fail("Need action to dispatch.");
    this.baseURI = opts.baseURI || '/';
    this.prefilter(opts.prefilters);
    this.initialized = true;
  },

  prefilter(filters) {
    if (filters instanceof Array && filters.length) {
      $.ajaxPrefilter((opts, oriOpts, xhr) => {
        filters.forEach((func) => {
          func(opts, oriOpts, xhr);
        });
      });
    }
  },

  do(url, opts) {
    if (!this.initialized) {
      throw "Attempting to use `req` without initialization.";
    }
    const
      target_url = join(this.baseURI, url),
      ajax = $.ajax(target_url, opts);
    if (opts.failPayload) {
      ajax.fail((xhr, status, error) => {
        const errorMsg = xhr.responseJSON && xhr.responseJSON.error;
        this.dispatcher.dispatch({
          type: opts.failAction || this.failAction,
          failMsg: errorMsg || opts.failMsg || error,
          data: opts.failPayload
        });
      });
    }
    return ajax;
  },

  get(url, opts) {
    opts.method = 'GET';
    return this.do(url, opts);
  },

  post(url, opts) {
    opts.method = 'POST';
    return this.do(url, opts);
  },

  put(url, opts) {
    opts.method = 'PUT';
    return this.do(url, opts);
  },

  patch(url, opts) {
    opts.method = 'PATCH';
    return this.do(url, opts);
  },

  delete(url, opts) {
    opts.method = 'DELETE';
    return this.do(url, opts);
  }
};

export default req;
