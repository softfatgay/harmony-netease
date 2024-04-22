import { appRed, textBlack, textLightGray, textRed, textWhite } from '../base/color';
import { BannerVO } from '../pages/main/model/FinalPriceInfoVO';
import { ItemListItem } from '../pages/main/model/ItemListItem';
import { TopLogo } from '../pages/main/model/TopLogo';

@Builder function GoodItem(item: ItemListItem) {
  Column() {
    Image(item.listPicUrl).width('100%').aspectRatio(1).borderRadius(4)
    Row() {
      if (item.preLogo != null)
      Row() {
        ForEach(item.preLogo, (preLogoItem: TopLogo) => {
          Image(preLogoItem.logoUrl).height(12).borderRadius(4)
        })
      }
      Text(item.name).fontSize(12).fontColor(textBlack)
    }.alignItems(VerticalAlign.Top)
    .margin({ right: 12, top: 10 })

    Row() {
      Text(getPricePrefix(item))
        .fontColor(textRed)
        .fontSize(12)
      Text(getPrice(item))
        .fontColor(textRed)
        .fontSize(16)
      if (getCounterPrice(item) != null)
        Text('¥' + getCounterPrice(item))
          .fontColor(textLightGray)
          .fontSize(12)
          .margin({ left: 4 })
          .decoration({ type: TextDecorationType.LineThrough })
    }.width('100%')
    .alignItems(VerticalAlign.Bottom)
    .align(Alignment.Start)
    .margin({ top: 6 })

    GoodItemTag(item.finalPriceInfoVO.banner)
  }
  .width('100%')
  .alignItems(HorizontalAlign.Start)
}

@Builder function GoodItemTag(banner: BannerVO) {
  if (banner != null && banner.title != null)
  Row() {
    if (banner.title != null)
      Text(banner.title??'')
        .backgroundColor(appRed)
        .height('100%')
        .padding({ left: 10, right: 10 })
        .borderRadius(12)
        .fontSize(10)
        .fontColor(textWhite)
        .fontWeight(600)
    if (banner.content != null)
      Text(banner.content??'')
        .padding({ left: 10, right: 10 })
        .borderRadius(12)
        .fontSize(10)
        .fontColor(textRed)
        .fontWeight(600)
  }
  .margin({ top: 4 })
  .height(24)
  .width('100%')
  .align(Alignment.Start)
  .alignItems(VerticalAlign.Center)
  .backgroundColor('#ffe9eb')
  .borderRadius(12)

  if (banner != null && banner.title == null && banner.content != null)
    Text(banner.content??'')
      .backgroundColor(appRed)
      .height(24)
      .margin({top:4})
      .padding({ left: 10, right: 10 })
      .borderRadius(12)
      .fontSize(10)
      .fontColor(textWhite)
      .fontWeight(600)
}

function getPricePrefix(item: ItemListItem): string {
  let finalPrice = item.finalPriceInfoVO.priceInfo.finalPrice
  if (finalPrice == null) return '¥'
  if (finalPrice.prefix == null) '¥'
  let priceStr = (finalPrice.prefix??'') + '¥'
  return priceStr
}

function getPrice(item: ItemListItem): string {
  let priceInfo = item.finalPriceInfoVO.priceInfo
  if (priceInfo.finalPrice == null) {
    return priceInfo.basicPrice
  }
  let finalPrice = priceInfo.finalPrice
  let priceStr = finalPrice.price
  return priceStr
}

function getCounterPrice(item: ItemListItem) {
  let counterPrice = item.finalPriceInfoVO.priceInfo.counterPrice
  if (counterPrice != null)
    return counterPrice
  return null
}

export { GoodItem }