import webview from '@ohos.web.webview'
import { LOGIN_PAGE_URL } from '../base/Api'

@Entry
@Component
export struct LoginPage {
  private controller: webview.WebviewController = new webview.WebviewController()
  onPageEnd: () => void = () => {
  }
  onPageBegin: () => void = () => {
  }

  build() {
    Column() {
      Web({ src: LOGIN_PAGE_URL, controller: this.controller })
        .javaScriptAccess(true)
        .multiWindowAccess(true)
        .zoomAccess(true)
        .fileAccess(true)
        .imageAccess(true)
        .enabled(true)
        .onPageBegin(e => {
          this.onPageBegin()
        })
        .onPageEnd(e => {
          this.onPageEnd()
        })
        .onUrlLoadIntercept((e) => {

          return false
        })
    }
  }

  @Builder
  noLogin() {

  }
}