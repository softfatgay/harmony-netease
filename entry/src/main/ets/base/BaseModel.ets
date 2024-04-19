export class ResponseResult {
  code: string;
  data: string | Object | ArrayBuffer;

  constructor() {
    this.code = '';
    this.data = '';
  }
}

export interface ResponseData<T = any> {
  data: T
  code: any
  errorMsg: String
  error: String
  message: String
}