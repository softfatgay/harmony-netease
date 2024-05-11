@Component
export struct PageLoading {
  build() {
    LoadingProgress().color(Color.Blue).size({ width: 80, height: 80 })
  }
}