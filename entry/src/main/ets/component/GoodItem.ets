import router from '@ohos.router';
import { appRed, textBlack, textLightGray, textRed, textWhite } from '../base/color';
import { BannerVO } from '../model/home/FinalPriceInfoVO';
import { ItemListItem } from '../model/ItemListItem';
import { Logo } from '../model/Logo';
import { pageIndex } from '../utils/Routers';

@Builder
function GoodItem(item: ItemListItem) {
  Column() {
    Image(item.listPicUrl ?? '').width('100%').aspectRatio(1).borderRadius(4)
    GoodTagName(item)
    Row() {
      Text(getPricePrefix(item))
        .fontColor(textRed)
        .fontSize(12)
      Text(getPrice(item))
        .fontColor(textRed)
        .fontWeight(600)
        .fontSize(16)
      if (getCounterPrice(item) != null)
        Text('¥' + getCounterPrice(item))
          .fontColor(textLightGray)
          .fontSize(12)
          .margin({ left: 4 })
          .decoration({ type: TextDecorationType.LineThrough })
    }
    .width('100%')
    .alignItems(VerticalAlign.Bottom)
    .align(Alignment.Start)
    .margin({ top: 6 })
    .padding({ left: 6, right: 6 })

    GoodItemTag(item.finalPriceInfoVO.banner)
  }
  .width('100%')
  .backgroundColor(Color.White)
  .borderRadius(6)
  .alignItems(HorizontalAlign.Start)
  .padding({ bottom: 12 })
  .onClick(e => {
    router.pushUrl(
      {
        url: pageIndex.detailPage,
        params: {
          'id': `${item.id}`,
          'skuId': `${item.primarySkuId ?? ''}`,
        }
      }
    )
  })
}

@Builder
function GoodTagName(item: ItemListItem) {
  Row() {
    Flex({ wrap: FlexWrap.Wrap, alignItems: ItemAlign.Center }) {
      if (item.preLogo != null)
      Row() {
        ForEach(item.preLogo, (preLogoItem: Logo) => {
          Image(preLogoItem.logoUrl).height(16).borderRadius(4).margin({ right: 4 })
        })
      }
      ForEach(item.name.split(""), (item: string) => {
        Text(item).fontSize(13).fontColor(textBlack).fontWeight(600)
      })
    }.layoutWeight(1)
  }
  .width('100%')
  .alignItems(VerticalAlign.Top)
  .margin({ right: 12, top: 6 })
  .padding({ left: 6, right: 6 })
}

@Builder
function GoodItemTag(banner: BannerVO) {
  if (banner != null && banner.title != null)
  Row() {
    if (banner.title != null)
      Text(banner.title ?? '')
        .backgroundColor(appRed)
        .height('100%')
        .padding({ left: 10, right: 10 })
        .borderRadius(12)
        .fontSize(10)
        .fontColor(textWhite)
        .fontWeight(600)
    if (banner.content != null)
      Text(banner.content ?? '')
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
  .margin({ left: 6, right: 6, top: 4 })

  if (banner != null && banner.title == null && banner.content != null)
    Text(banner.content ?? '')
      .backgroundColor(appRed)
      .height(24)
      .margin({ top: 4 })
      .padding({ left: 10, right: 10 })
      .borderRadius(12)
      .fontSize(10)
      .fontColor(textWhite)
      .fontWeight(600)
      .margin({ left: 6, right: 6, top: 4 })
}

function getPricePrefix(item: ItemListItem): string {
  let finalPrice = item.finalPriceInfoVO.priceInfo.finalPrice
  if (finalPrice == null) return '¥'
  if (finalPrice.prefix == null) '¥'
  let priceStr = (finalPrice.prefix ?? '') + '¥'
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

export { GoodItem, GoodTagName }