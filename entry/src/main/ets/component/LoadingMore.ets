import { Loading } from './Loading'

@Builder function LoadingMore(hasMore: boolean = true) {
  if (hasMore) Loading(40)
  else Text('没有更多了')
}

export { LoadingMore }