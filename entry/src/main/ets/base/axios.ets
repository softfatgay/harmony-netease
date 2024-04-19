import axios from '@ohos/axios'
axios.defaults.headers.post['Content-Type'] = 'application/json';
export const _____ = axios.create({
  baseURL: 'https://some-domain.com/api/',
  timeout: 1000,
  headers: {'X-Custom-Header': 'foobar'}
});

