import router from '@ohos.router'

export class pageIndex {
  static readonly webview = "pages/WebView"
  static readonly itemPage = "pages/KingKongListPage"
  static readonly hotPage = "pages/HotPage"
  static readonly detailPage = "pages/detail/DetailPage"
}

export function goWebView(url: string) {
  router.pushUrl(
    { url: pageIndex.webview, params: { "schemeUrl": url } }
  )
}