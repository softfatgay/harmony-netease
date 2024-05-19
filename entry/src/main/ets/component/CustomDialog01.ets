import { appWhite, lineColor, textBlack } from '../base/color'

@CustomDialog
export struct CustomDialog01 {
  @BuilderParam content?: () => void
  @Prop title: string = ''
  controller: CustomDialogController

  build() {
    Column() {
      Stack() {
        Text(this.title).width('100%').fontSize(16).fontColor(textBlack).textAlign(TextAlign.Center)
        Image($r('app.media.close')).size({ width: 18, height: 18 }).onClick(e => {
          this.controller.close()
        })
      }
      .padding(16)
      .alignContent(Alignment.End)
      .border({width:{bottom:0.5},color:{bottom:lineColor}})

      if (this.content !== undefined) this.content()
    }
    .width('100%')
    .backgroundColor(appWhite)
    .borderRadius({ topLeft: 12, topRight: 12 })
  }
}