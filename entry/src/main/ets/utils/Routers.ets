import router from '@ohos.router'
import { queryURLParameter } from './UrlUtil'

export class pageIndex {
  static readonly webview = "pages/WebView"
  static readonly itemPage = "pages/KingKongListPage"
  static readonly hotPage = "pages/HotPage"
  static readonly detailPage = "pages/detail/DetailPage"
  static readonly sortListPage = "pages/SortListPage"
  static readonly commentsPage = "pages/detail/CommentsPage"
  static readonly brandPage = "pages/detail/BrandPage"
}

export function goWebView(url: string) {
  if (goDetail(url)) return
  router.pushUrl(
    { url: pageIndex.webview, params: { "schemeUrl": url } }
  )
}

function goDetail(url: string): boolean {
  if (url.includes('item/detail')) {
    let params = queryURLParameter(url)
    let id = params['id']
    router.pushUrl({ url: pageIndex.detailPage, params: {
      'id': id
    } })
    return true
  }
  return false
}
