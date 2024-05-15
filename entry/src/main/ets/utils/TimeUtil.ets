/**
 * 时间戳转时间 YYYY-YY-DD HH-MM-ss  格式
 * @params timestamp: 13位时间戳 | new Date() | Date()
 *console.log(dateFormat(1714528800000, 'YY-MM-DD HH:mm:ss'))
 * @params format => YY：年，M：月，D：日，H：时，m：分钟，s：秒，SSS：毫秒
 */
export function dateFormat(timestamp: number | string | Date, format = 'YYYY-MM-DD HH:mm:ss'): string {
  var date = new Date(timestamp)

  function fixedTwo(value: number): string {
    return value < 10 ? '0' + value : String(value)
  }

  var showTime = format
  if (showTime.includes('SSS')) {
    const S = date.getMilliseconds()
    showTime = showTime.replace('SSS', '0'.repeat(3 - String(S).length) + S)
  }
  if (showTime.includes('YY')) {
    const Y = date.getFullYear()
    showTime = showTime.includes('YYYY') ? showTime.replace('YYYY', String(Y)) : showTime.replace('YY', String(Y)
      .slice(2, 4))
  }
  if (showTime.includes('M')) {
    const M = date.getMonth() + 1
    showTime = showTime.includes('MM') ? showTime.replace('MM', fixedTwo(M)) : showTime.replace('M', String(M))
  }
  if (showTime.includes('D')) {
    const D = date.getDate()
    showTime = showTime.includes('DD') ? showTime.replace('DD', fixedTwo(D)) : showTime.replace('D', String(D))
  }
  if (showTime.includes('H')) {
    const H = date.getHours()
    showTime = showTime.includes('HH') ? showTime.replace('HH', fixedTwo(H)) : showTime.replace('H', String(H))
  }
  if (showTime.includes('m')) {
    var m = date.getMinutes()
    showTime = showTime.includes('mm') ? showTime.replace('mm', fixedTwo(m)) : showTime.replace('m', String(m))
  }
  if (showTime.includes('s')) {
    var s = date.getSeconds()
    showTime = showTime.includes('ss') ? showTime.replace('ss', fixedTwo(s)) : showTime.replace('s', String(s))
  }
  return showTime
}

/**
 * 日期 时间 转13位时间戳
 */
export function timeTransition(time: string) {
  var timestamp = Date.parse(`${new Date(time)}`)
  return timestamp
}