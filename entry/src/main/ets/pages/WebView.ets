import webview from '@ohos.web.webview';
import router from '@ohos.router';
import HashMap from '@ohos.util.HashMap';

@Entry
@Component
struct WebView {
  private controller: webview.WebviewController = new webview.WebviewController()
  @State url: string = ''

  aboutToAppear() {
    let schemeUrl = router.getParams()['schemeUrl'] as string
    this.url = schemeUrl
  }

  build() {
    Scroll() {
      Web({ src: this.url, controller: this.controller })
        .javaScriptAccess(true)
        .zoomAccess(true)
        .fileAccess(true)
        .imageAccess(true)
        .enabled(true)
    }
  }
}