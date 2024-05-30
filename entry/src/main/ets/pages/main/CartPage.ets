import axios from '@ohos/axios'
import { CART_DELETE, CART_TRADE, CHECK_LOGIN, LOGIN_PAGE_URL, SHOPPING_CART } from '../../base/Api'
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
import router from '@ohos.router'
import { pageIndex } from '../../utils/Routers'
import { GlobalInfoVO } from '../../model/cart/GlobalInfoVO'

@Entry
@Component
export struct CartPage {
  @State _isLogin: boolean = false
  @State _pageState: PageState = PageState.None
  @State _cartModel: CartModel = null
  //全场换购
  @State _globalList: Array<CartGlobalGroup> = []
  // 有效商品
  @State _itemList: Array<CartItemGroup> = []
  /// 失效商品
  @State _invalidList: Array<CartItemListItem> = []
  // 价格信息
  @State _globalInfo: GlobalInfoVO = null

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
      this.setData(res.data.data)
    }
    ).catch(err => {
      console.log(err)
    })
  }

  setData(data: CartModel) {
    this._pageState = PageState.Success
    this._cartModel = new CartModel()
    this._cartModel = data
    this._globalList = this._cartModel.cartGlobalGroupList
    this._itemList = this._cartModel.cartItemGroupList
    this._invalidList = this._cartModel.invalidItemList
    this._globalInfo = this._cartModel.globalInfoVO
  }

  _deleteCart(id: string) {
    this._pageState = PageState.Loading
    let deleteArr: Array<string> = []
    deleteArr.push(id)
    axios.post<ResponseData<CartModel>>(CART_DELETE, JSON.stringify({ "deletedCartIds": [id] })).then(res => {
      this.setData(res.data.data)
    }
    ).catch(err => {
      PageState.Error
      console.log(err)
    })
  }

  build() {
    Stack() {
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
        this.priceView()
      }.height('100%')

      if (this._pageState == PageState.Loading) PageLoading()
    }.height('100%').backgroundColor(0xFFF4F4F4)
  }

  @Builder
  priceView() {
    Row() {
      Checkbox() {

      }
      .width(16)
      .height(16)
      .selectedColor(backRed)
      .select(this._globalInfo.allChecked)
      .onChange((checked) => {

      })

      Text('全选').fontColor(0xFF7F7F7F).fontSize(14).margin({ left: 10 })
      Column() {
        Text(this._globalInfo.showActualPrice).fontSize(14).fontColor(textRed).fontWeight(600)
        Row() {
          Text(this._globalInfo.showActivityPrice).fontSize(12).fontColor(textGray)
          Image($r('app.media.arrow_up')).size({ width: 12 }).margin({ left: 3 })
        }.margin({ top: 4 })
      }
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.End)
      .layoutWeight(1)
      .margin({ left: 8, right: 8 })

      Button(`结算(${this._globalInfo.selectedCount})`, { type: ButtonType.Capsule, stateEffect: true })
        .backgroundColor(this._globalInfo.selectedCount > 0 ? textRed : textLightGray)
        .enabled(this._globalInfo.selectedCount > 0)
        .fontSize(14)
        .width(120)
    }
    .height(60)
    .width('100%')
    .padding({ left: 12, right: 12 })
    .backgroundColor(0xFAFAFA)
  }

  @Builder
  cartItems() {
    Scroll() {
      Column() {
        this.cartGlobalGroupList(this._globalList)
        this.itemsList(this._itemList)
        this.invalidList(this._invalidList)
      }
    }.layoutWeight(1)
  }

  @Builder
  invalidList(list: Array<CartItemListItem>) {
    Column() {
      Text('失效商品')
        .fontSize(16)
        .fontWeight(600)
        .fontColor(textBlack)
        .padding({ left: 12, right: 12 })

      List() {
        ForEach(list, (item: CartItemListItem) => {
          ListItem() {
            Column() {
              Row() {
                Stack() {
                  Image(item.pic)
                    .size({ height: 90, width: 90 })
                    .backgroundColor(0xfff4f4f4)
                    .borderRadius(8)
                    .opacity(0.5)
                  if (item.leftTag != null && item.leftTag.type == 1)
                    Text(item.leftTag.name ?? '')
                      .size({ height: 70, width: 70 })
                      .backgroundColor(0x99333333)
                      .borderRadius(45)
                      .fontColor(textWhite)
                      .textAlign(TextAlign.Center)
                }.alignContent(Alignment.Center)

                Column() {
                  Row() {
                    Text(`${item.prefix ?? ''}`)
                      .fontSize(14)
                      .fontColor(textLightRed)
                      .margin({ right: 4 })
                      .opacity(0.5)
                    Text(`${item.itemName ?? ''}`)
                      .fontSize(14)
                      .fontColor(textBlack)
                      .layoutWeight(1)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .opacity(0.5)
                  }

                  Text(this.getSpecListText(item.specList))
                    .fontSize(12)
                    .fontColor(0xff7f7f7f)
                    .backgroundColor(0xfff4f4f4)
                    .padding({ left: 6, right: 6, top: 3, bottom: 3 })
                    .margin({ top: 4 })
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .borderRadius(8)
                    .opacity(0.5)

                  Row() {
                    Text('¥').fontSize(14).fontColor(textLightGray).fontWeight(600).opacity(0.5)
                    Text(`${item.actualPrice ?? ''}`)
                      .fontSize(18)
                      .fontColor(textLightGray)
                      .fontWeight(800)
                      .layoutWeight(1)
                      .opacity(0.5)
                    Text('x' + item.cnt)
                      .fontSize(12)
                      .fontColor(textLightGray)
                      .fontWeight(800)
                      .opacity(0.5)
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
            .padding(12)
            .width('100%')
            .onClick(e => {
              this.goDetail(item.itemId)
            })
          }.swipeAction({ end: this.itemSwip.bind(this, item) })
        })
      }

    }
    .alignItems(HorizontalAlign.Start)
    .margin(12)
    .padding(12)
    .backgroundColor(appWhite)
    .borderRadius(8)
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
          }.padding({ left: 12, right: 12 })

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
              }.padding({ top: 12, left: 12, right: 12, bottom: 4 })

              List() {
                ForEach(promotionGroup.cartItemList, (item: CartItemListItem, index: number) => {
                  ListItem() {
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

                          this.timerText(item)

                          Row() {
                            Text('¥').fontSize(14).fontColor(textRed).fontWeight(800)
                            Text(`${item.actualPrice ?? ''}`)
                              .fontSize(18)
                              .fontColor(textRed)
                              .fontWeight(800)
                              .layoutWeight(1)

                            Counter() {
                              Text(item.cnt + '').fontSize(14).fontColor(textBlack).fontWeight(600)
                            }.onInc(() => {
                              //
                            }).onDec(() => {

                            })
                          }.margin({ top: 4 })
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
                    .padding(12)
                    .width('100%')
                    .onClick(e => {
                      this.goDetail(item.itemId)
                    })
                  }.swipeAction({ end: this.itemSwip.bind(this, item) })
                })
              }
            }
          })
        }
        .cartViewStyle()
      })
    }.padding({ left: 12, right: 12 })
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      if (isVisible) {
        this.onPageShow()
      }
    })
  }

  @Builder
  itemSwip(item: CartItemListItem) {
    Text('删除')
      .height('100%')
      .fontColor(textWhite)
      .textAlign(TextAlign.Center)
      .width(80)
      .backgroundColor(backRed)
      .onClick(e => {
        this._deleteCart(item.id + '')
      })
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
                .onClick(e => {
                  this.goDetail(item.itemId)
                })
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

  @Builder
  timerText(item: CartItemListItem) {
    if (item.remainTime > 0)
    Row() {
      Text('距优惠结束 ').fontSize(12).fontColor(0xfa1e32)
      TextTimer({
        isCountDown: true,
        count: item.remainTime ?? 0,
        controller: this.getTimerController()
      })
        .fontSize(12)
        .fontWeight(700)
        .fontColor(0xfa1e32)
        .format('HH:mm:ss')
    }
    .margin({ top: 4 })
    .backgroundColor(0xFFF8F2F3)
    .padding({ left: 6, right: 6, top: 3, bottom: 3 })
    .borderRadius(20)
  }

  _timerControllers: Array<TextTimerController> = []

  getTimerController(): TextTimerController {
    let controller = new TextTimerController()
    this._timerControllers.push(controller)
    console.log('============length', this._timerControllers.length)
    return controller
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

  goDetail(id: number) {
    router.pushUrl({ url: pageIndex.detailPage,
      params: { 'id': `${id}` }
    })
  }

  onPageShow() {
    console.log('============onPageShow', this._timerControllers.length)
    this._timerControllers.forEach(controller => {
      controller.start()
    })
  }
}

@Styles
function cartViewStyle() {
  .width('100%')
  .margin({ left: 12, right: 12, top: 12 })
  .padding({ top: 12, bottom: 12 })
  .backgroundColor(appWhite)
  .borderRadius(8)
}
