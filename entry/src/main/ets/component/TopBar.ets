import router from '@ohos.router'
import { textBlack } from '../base/color'

@Component
export struct TopBar {
  @Prop title: string;

  build() {
    RelativeContainer() {
      Image($r('app.media.back'))
        .onClick(e => {
          router.back()
        })
        .height(46)
        .padding(8)
        .id('image')
        .relativeStartCenter()
      Text(`${this.title}`).fontSize(18).fontColor(textBlack).id('tv').relativeCenter()
    }
    .border({ width: { bottom: 1 }, color: { bottom: 0xFFF2F4F9 } })
    .height(46)
    .width('100%')
    .backgroundColor(Color.White)
  }
}

@Styles
function relativeCenter() {
  .alignRules(
    {
      middle: { anchor: '__container__', align: HorizontalAlign.Center },
      center: { anchor: '__container__', align: VerticalAlign.Center },
    }
  )
}

@Styles
function relativeStartCenter() {
  .alignRules(
    {
      center: { anchor: '__container__', align: VerticalAlign.Center },
      left: { anchor: '__container__', align: HorizontalAlign.Start }
    }
  )
}