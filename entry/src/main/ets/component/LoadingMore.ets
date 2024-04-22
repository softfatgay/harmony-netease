import { Loading } from './Loading'

@Builder function LoadingMore(hasMore: boolean = true) {
  if (this.haseMore)
    Loading(40)
  else Text('没有更多了')
}

export { LoadingMore }