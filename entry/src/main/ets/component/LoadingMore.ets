@Builder function LoadingMore(hasMore: boolean = true) {
  if (hasMore) LoadingProgress().color(Color.Blue).size({ width: 40, height: 40 })
  else Text('没有更多了')
}

export { LoadingMore }