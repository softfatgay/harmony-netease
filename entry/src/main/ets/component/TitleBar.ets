import router from '@ohos.router'
import { textBlack } from '../base/color'

@Builder export function TitleBar(title: string) {
  RelativeContainer() {
    Image($r('app.media.back'))
      .onClick(e => {
        router.back()
      })
      .height(46)
      .padding(8)
      .id('image')
      .relativeStartCenter()
    Text(title).fontSize(18).fontColor(textBlack).id('tv').relativeCenter()
  }.height(46).width('100%')
}


@Styles function relativeCenter() {
  .alignRules(
    {
      middle: { anchor: '__container__', align: HorizontalAlign.Center },
      center: { anchor: '__container__', align: VerticalAlign.Center },
    }
  )
}

@Styles function relativeStartCenter() {
  .alignRules(
    {
      center: { anchor: '__container__', align: VerticalAlign.Center },
      left: { anchor: '__container__', align: HorizontalAlign.Start }
    }
  )
}