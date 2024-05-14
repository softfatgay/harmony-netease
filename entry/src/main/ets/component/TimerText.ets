@Component
struct TimerText {
  @Prop time: number
  @State _timer: number = 0

  aboutToAppear() {
    this._timer = this.time
  }

  build() {
    Text(`${this._timer}`)
  }

  timersStart() {
    let _interval = setInterval(() => {
      this._timer -= 1
      if (this._timer <= 0) {
        clearInterval(_interval)
      }
    }, 1000)
  }

  aboutToDisappear() {
    clearInterval()
  }
}