import { textBlack, textGray, textWhite } from '../base/color';
import { dftAvatarIcon } from '../base/Url';
import { ResultItem } from '../model/ResultItem';
import { dateFormat } from '../utils/TimeUtil';

@Builder
export function CommentItem(item: ResultItem) {
  Column() {
    Row() {
      Image(item.frontUserAvatar ?? dftAvatarIcon).size({ width: 30, height: 30 }).borderRadius(15)
      Text(item.frontUserName ?? '').fontSize(14).fontColor(textBlack).margin({ left: 8 })
      Text() {
        Span('V').fontColor(textWhite).fontSize(14).fontWeight(600).fontStyle(FontStyle.Italic)
        Span(`${item.memberLevel}`).fontColor(textWhite).fontSize(8)
      }
      .letterSpacing(-2)
      .backgroundColor(0xFFB19C6D)
      .borderRadius(2)
      .padding({ left: 2, right: 2 })
      .margin({ left: 5 })

      Rating({ rating: item.star == null ? 0.0 : item.star, indicator: false })
        .height(14)
        .aspectRatio(5)
        .margin({ left: 10 })
    }.alignItems(VerticalAlign.Center)

    Text(`${dateFormat(item.createTime??'')}   ${item.skuInfo[0]??''}`)
      .fontSize(12)
      .fontColor(textGray)
      .textAlign(TextAlign.Start)
      .margin({ top: 6 })
    Text(item.content)
      .fontSize(14)
      .fontColor(textBlack)
      .textAlign(TextAlign.Start)
      .margin({ top: 6 })
    GridRow({ columns: 4, gutter: 8 }) {
      ForEach(item.picList ?? [], (item: string) => {
        GridCol() {
          Image(item).borderRadius(4)
        }.width('100%').aspectRatio(1)
      })
    }.margin({ top: 16 })
  }
  .width('100%')
  .padding({ left: 12, right: 12, top: 16, bottom: 16 })
  .alignItems(HorizontalAlign.Start)
}