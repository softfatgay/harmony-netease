
export const queryURLParameter = (url) => {
  let regx = /([^&?=]+)=([^&?=]+)/g;
  let obj = {};

  url.replace(regx, (...args) => {
    if (obj[args[1]]) {
      obj[args[1]] = Array.isArray(obj[args[1]])
        ? obj[args[1]]
        : [obj[args[1]]];
      obj[args[1]].push(args[2]);
    } else {
      obj[args[1]] = args[2];
    }
  });

  return obj;
};