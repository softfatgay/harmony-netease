import webview from '@ohos.web.webview';
import router from '@ohos.router';
import { TopBar } from '../component/TopBar';

@Entry
@Component
struct WebView {
  private controller: webview.WebviewController = new webview.WebviewController()
  @State url: string = ''
  @State _title: string = ''

  aboutToAppear() {
    let schemeUrl = router.getParams()['schemeUrl'] as string
    this.url = schemeUrl
  }

  build() {
    Column() {
      TopBar({ title: this._title })
      Web({ src: this.url, controller: this.controller })
        .javaScriptAccess(true)
        .multiWindowAccess(true)
        .zoomAccess(true)
        .fileAccess(true)
        .imageAccess(true)
        .enabled(true)
        .onPageBegin(e => {
          this.excJS()
        })
        .onPageEnd(e => {
          this._title = this.controller.getTitle()
        })
        .onUrlLoadIntercept((e) => {
          console.log('==============loadurl',e.data.toString())
          return false
        })
    }
  }
  excJS(){
  }
}