import axios from '@ohos/axios'
import { CHECK_LOGIN, LOGIN_PAGE_URL, SHOPPING_CART } from '../../base/Api'
import { ResponseData } from '../../base/BaseModel'
import { PageState } from '../../base/PageState'
import { PageLoading } from '../../component/PageLoading'
import { LoginPage } from '../LoginPage'
import { csrf_token, timestampParams, User } from '../../base/User'
import { ShoppingCartModel } from '../../model/cart/ShoppingCartModel'
import { CarItem } from '../../model/cart/CarItem'
import { PostageVO } from '../../model/cart/PostageVO'
import { CartItemListItem } from '../../model/cart/CartItemListItem'

@Entry
@Component
export struct CartPage {
  @State _isLogin: boolean = false
  @State _pageState: PageState = PageState.None
  @State _cartModel: ShoppingCartModel = null
  /// 有效的购物车组列表
  @State _cartGroupList: Array<CarItem> = []
  /// 无效的购物车组列表
  @State _invalidCartGroupList: Array<CarItem> = []
  @State _postageVO: PostageVO = null

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
          this._getData()
        }
      }
      this._pageState = PageState.Success
    }).catch(err => {
      console.log(err)
      this._pageState = PageState.Error
    })
  }

  _getData() {
    axios.get<ResponseData<ShoppingCartModel>>(SHOPPING_CART, {
      params: { 'csrf_token': csrf_token }
    }).then(res => {
      let data = res.data.data
      this._cartGroupList = data.cartGroupList ?? []
      this._invalidCartGroupList = data.invalidCartGroupList ?? []
      this._postageVO = data.postageVO
      console.log('------cart', JSON.stringify(data.postageVO))
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
        this.cartItems(this._cartGroupList)
      }.height('100%')

      if (this._pageState == PageState.Loading) PageLoading()
    }.height('100%')
  }

  @Builder
  cartItems(list: Array<CarItem>) {
    Scroll() {
      Column() {
        ForEach(list, (item: CarItem) => {
          ForEach(item.cartItemList, (itemItem: CartItemListItem) => {
            Image(itemItem.pic).height(100)
          })
        })
      }
    }
  }
}