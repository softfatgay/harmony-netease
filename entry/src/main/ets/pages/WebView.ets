import web_view from '@ohos.web.webview';
import router from '@ohos.router';
import { TopBar } from '../component/TopBar';
import uri from '@ohos.uri';
import { queryURLParameter } from '../utils/UrlUtil';
import { pageIndex } from '../utils/Routers';
import { cookie } from '../base/User';
import url from '@ohos.url';
import { baseUrl } from '../base/Api';

@Entry
@Component
struct WebView {
  private controller: web_view.WebviewController = new web_view.WebviewController()
  @State url: string = ''
  @State _title: string = ''
  responseweb: WebResourceResponse = new WebResourceResponse()

  aboutToAppear() {
    let schemeUrl = router.getParams()['schemeUrl'] as string
    this.url = schemeUrl
    web_view.WebCookieManager.setCookie(baseUrl,'document.cookie ='+cookie)

  }

  build() {
    Column() {
      TopBar({ title: this._title })
      Web({ src: this.url, controller: this.controller })
        .domStorageAccess(true)
        .javaScriptAccess(true)
        .multiWindowAccess(true)
        .fileAccess(true)
        .imageAccess(true)
        .onPageBegin(e => {
          this.excJS()
        })
        .onPageEnd(e => {
          this._title = this.controller.getTitle()
        })
        .onUrlLoadIntercept((e) => {
          console.log('==============loadurl', e.data.toString())
          let url: string = e.data as string
          if (url.includes('item/detail')) {
            this.goDetail(url)
            return true
          }
          // this.controller.loadUrl(url, [{ headerKey: 'Cookie', headerValue: cookie }])
          return false
        })
    }
  }

  goDetail(url: string) {
    if (url.includes('item/detail')) {
      let params = queryURLParameter(url)
      let id = params['id']
      router.pushUrl({ url: pageIndex.detailPage, params: {
        'id': id
      } })
    }
  }

  excJS() {
  }
}