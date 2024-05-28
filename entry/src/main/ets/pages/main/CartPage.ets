import axios from '@ohos/axios'
import { CART_TRADE, CHECK_LOGIN, LOGIN_PAGE_URL, SHOPPING_CART } from '../../base/Api'
import { ResponseData } from '../../base/BaseModel'
import { PageState } from '../../base/PageState'
import { PageLoading } from '../../component/PageLoading'
import { LoginPage } from '../LoginPage'
import { commonHeaders, csrf_token, timestampParams, User } from '../../base/User'
import { ShoppingCartModel } from '../../model/cart/ShoppingCartModel'
import { CarItem } from '../../model/cart/CarItem'
import { PostageVO } from '../../model/cart/PostageVO'
import { BottomTips, CartItemListItem, SpecListItem } from '../../model/cart/CartItemListItem'
import { CartModel } from '../../model/cart/CartModel'
import { CartGlobalGroup } from '../../model/cart/CartGlobalGroup'
import { CartItemGroup } from '../../model/cart/CartItemGroup'
import {
  appWhite,
  backgroundColor,
  backRed,
  textBlack,
  textGray,
  textLightGray,
  textLightRed,
  textRed,
  textWhite
} from '../../base/color'

@Entry
@Component
export struct CartPage {
  @State _isLogin: boolean = false
  @State _pageState: PageState = PageState.None
  @State _cartModel: CartModel = null
  //全场换购
  @State _globalList: Array<CartGlobalGroup> = []
  // 有效商品
  @State _ItemList: Array<CartItemGroup> = []
  /// 失效商品
  @State _invalidList: Array<CartItemListItem> = []

  aboutToAppear() {
    if (csrf_token == '') {
      this._isLogin = false
    } else {

    }
    this._checkLogin()
  }

  _checkLogin() {
    this._pageState = PageState.Loading
    axios.get<ResponseData>(CHECK_LOGIN, {
      params: timestampParams
    }).then(res => {
      console.log('==============islogin', JSON.stringify(res.data))
      let isLogin = res.data.data
      if (isLogin == null) {
        this._isLogin = false
      } else {
        this._isLogin = isLogin
        if (isLogin) {
          this._getCart()
        }
      }
      this._pageState = PageState.Success
    }).catch(err => {
      console.log(err)
      this._pageState = PageState.Error
    })
  }

  _getCart() {
    axios.get<ResponseData<CartModel>>(CART_TRADE, {
      params: timestampParams
    }).then(res => {
      let data = res.data.data
      this._globalList = data.cartGlobalGroupList
      this._ItemList = data.cartItemGroupList
      this._invalidList = data.invalidItemList
      this._cartModel = data
      this._pageState = PageState.Success
    }
    ).catch(err => {
      console.log(err)
    })
  }

  build() {
    if (this._pageState == PageState.Loading) PageLoading()
    else Stack() {
      if (this._isLogin) this.content()
      else LoginPage({
        onPageEnd: () => {

        },
        onPageBegin: () => {

        }
      })
    }
  }

  @Builder
  content() {
    Stack() {
      if (this._cartModel != null)
      Column() {
        this.cartItems()
      }.height('100%')

      if (this._pageState == PageState.Loading) PageLoading()
    }.height('100%').backgroundColor(0xFFF4F4F4)
  }

  @Builder
  cartItems() {
    Scroll() {
      Column() {
        this.cartGlobalGroupList(this._globalList)
        this.itemsList(this._ItemList)
      }
    }
  }

  @Builder
  itemsList(list: Array<CartItemGroup>) {
    Column() {
      ForEach(list, (groupItem: CartItemGroup) => {
        Column() {
          Row() {
            Checkbox() {

            }
            .width(16)
            .height(16)
            .selectedColor(backRed)
            .select(groupItem.checked ?? true)
            .onChange((checked) => {

            })

            Text(groupItem.groupTitle)
              .fontSize(16)
              .fontWeight(600)
              .fontColor(textBlack)
              .layoutWeight(1)
            Text(groupItem.groupTip)
              .fontSize(12)
              .fontColor(textGray)
          }

          ForEach(groupItem.promotionGroupList, (promotionGroup: CartGlobalGroup) => {
            Column() {
              if (promotionGroup.promTitle != null)
              Row() {
                Text(promotionGroup.promTitle)
                  .fontSize(10)
                  .fontColor(textWhite)
                  .padding({ left: 4, top: 2, right: 4, bottom: 2 })
                  .backgroundColor(backRed)
                  .borderRadius(8)
                Text(promotionGroup.promTip)
                  .fontSize(12)
                  .fontColor(textBlack)
                  .layoutWeight(1)
                if (promotionGroup.promotionTip != null)
                  Text(`${promotionGroup.promotionTip}>`)
                    .fontSize(12)
                    .fontColor(textRed)
              }.padding({ top: 12, bottom: 4 })

              ForEach(promotionGroup.cartItemList, (item: CartItemListItem) => {
                Column() {
                  Row() {
                    Image(item.pic)
                      .size({ height: 90, width: 90 })
                      .backgroundColor(0xfff4f4f4)
                      .borderRadius(8)
                    Column() {
                      Row() {
                        Text(`${item.prefix ?? ''}`)
                          .fontSize(14)
                          .fontColor(textLightRed)
                          .margin({ right: 4 })
                        Text(`${item.itemName ?? ''}`)
                          .fontSize(14)
                          .fontColor(textBlack)
                          .layoutWeight(1)
                          .maxLines(1)
                          .textOverflow({ overflow: TextOverflow.Ellipsis })
                      }

                      Text() {
                        Span(this.getSpecListText(item.specList)).layoutWeight(1)
                        Span('>')
                      }
                      .fontSize(12)
                      .fontColor(0xff7f7f7f)
                      .backgroundColor(0xfff4f4f4)
                      .padding({ left: 6, right: 6, top: 3, bottom: 3 })
                      .margin({ top: 4 })
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .borderRadius(8)

                      Row() {
                        Text('¥').fontSize(10).fontColor(textRed).fontWeight(600)
                        Text(`${item.actualPrice ?? ''}`)
                          .fontSize(16)
                          .fontColor(textRed)
                          .fontWeight(600)
                          .layoutWeight(1)

                        Counter() {
                          Text(item.cnt + '').fontSize(14).fontColor(textBlack).fontWeight(600)
                        }.onInc(() => {
                            //
                        }).onDec(() => {

                        })
                      }.margin({ top: 6 })
                    }
                    .padding({ left: 10 })
                    .layoutWeight(1)
                    .align(Alignment.Start)
                    .alignItems(HorizontalAlign.Start)
                  }
                  .width('100%')
                  .alignItems(VerticalAlign.Top)
                  .align(Alignment.Start)

                  if (item.bottomTips != null && item.bottomTips.length > 0)
                  Row() {
                    Image($r('app.media.info_tips')).size({ width: 10, height: 10 })
                    Text(this.getBottomTipsTv(item.bottomTips)).fontSize(10)
                      .fontColor(textLightGray)
                  }.margin({ top: 6 })
                }
                .alignItems(HorizontalAlign.Start)
                .padding({ top: 12, bottom: 12 })
                .width('100%')
              })
            }
          })
        }
        .cartViewStyle()
      })
    }.padding({ left: 12, right: 12 })
  }

  @Builder
  cartGlobalGroupList(globalList: Array<CartGlobalGroup>) {
    Column() {
      ForEach(globalList, (item: CartGlobalGroup) => {
        Column() {
          Row() {
            Text(item.promTitle)
              .fontSize(16)
              .fontWeight(600)
              .fontColor(textBlack)
              .layoutWeight(1)
            Text(item.promTip)
              .fontSize(12)
              .fontColor(textGray)
            Text(`${item.promotionTip}>`)
              .fontSize(12)
              .fontColor(textRed)
              .margin({ left: 4 })
          }

          Scroll() {
            Row() {
              ForEach(item.addBuyPreview.addBuyPreviewItemList ?? [], (item: CartItemListItem) => {
                Row() {
                  Image(item.pic ?? '').size({ width: 72, height: 72 }).backgroundColor(0xfff4f4f4).borderRadius(8)
                  Column() {
                    Text(item.itemName)
                      .fontSize(12)
                      .fontColor(textBlack)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                    Text(this.getSpecListText(item.specList)).fontSize(10).fontColor(textGray)
                    Row() {
                      Text(item.prefix ?? '').fontSize(10).fontColor(textRed)
                      Text('¥').fontSize(8).fontColor(textRed).fontWeight(600)
                      Text(`${item.actualPrice ?? ''}`).fontSize(16).fontColor(textRed).fontWeight(600)
                      if (item.showRetailPrice != null)
                        Text(item.showRetailPrice ?? '')
                          .fontSize(10)
                          .fontColor(textGray)
                          .decoration({ type: TextDecorationType.LineThrough })
                    }.margin({ top: 4 })
                  }
                  .margin({ left: 8 })
                  .alignItems(HorizontalAlign.Start)
                  .width(160)
                }
                .backgroundColor(0xFFFAFAFA)
                .borderRadius(8)
                .margin({ right: 10 })
              })
              if (item.addBuyPreview.hasMore == true)
                Text(`${item.addBuyPreview.tip ?? ''}>`)
                  .fontSize(14)
                  .fontColor(textRed)
                  .textAlign(TextAlign.Center)
                  .size({ height: 72, width: 82 })
                  .backgroundColor(0xFFFAFAFA)
                  .borderRadius(8)
            }
          }
          .scrollable(ScrollDirection.Horizontal)
          .margin({ top: 16 })
        }
        .cartViewStyle()
      })
    }.margin({ top: 20, left: 12, right: 12 })
  }

  getSpecListText(specList: Array<SpecListItem>): string {
    var tv = ''
    specList.forEach(e => {
      tv += e.specValue
    })
    return tv
  }

  getBottomTipsTv(bottomTips: Array<BottomTips>): string {
    var tv = ''
    bottomTips.forEach(e => {
      tv += e.value
    })
    return tv
  }
}


@Styles
function cartViewStyle() {
  .width('100%')
  .margin({ left: 12, right: 12, top: 12 })
  .padding(12)
  .backgroundColor(appWhite)
  .borderRadius(8)
}
