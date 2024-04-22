@Builder function Loading(size: number = 80) {
  LoadingProgress().color(Color.Blue).size({ width: size, height: size })
}
export { Loading }