import axios from '@ohos/axios'
import { CHECK_LOGIN, LOGIN_PAGE_URL } from '../../base/Api'
import { ResponseData } from '../../base/BaseModel'
import { PageState } from '../../base/PageState'
import { csrf_token, timestampParams, User } from '../../base/User'
import { PageLoading } from '../../component/PageLoading'
import { LoginPage } from '../LoginPage'

@Entry
@Component
export struct ProfilePage {
  @State _isLogin: boolean = false
  @State _pageState: PageState = PageState.None

  aboutToAppear() {
    if (csrf_token == '') {
      this._isLogin = false
    } else {

    }
    this._getBrandInfo()
  }

  _getBrandInfo() {
    this._pageState = PageState.Loading
    axios.get<ResponseData>(CHECK_LOGIN, {
      params: timestampParams
    }).then(res => {
      let isLogin = res.data.data
      if (isLogin == null) {
        this._isLogin = false
      } else {
        this._isLogin = isLogin
      }
      this._pageState = PageState.Success
    }).catch(err => {
      console.log(err)
      this._pageState = PageState.Error
    })
  }

  build() {
    if (this._pageState == PageState.Loading) PageLoading()
    else Stack() {
      if (this._isLogin) this.loginPage()
      else LoginPage({
        onPageEnd: () => {

        },
        onPageBegin:()=>{

        }
      })
    }
  }

  @Builder
  loginPage() {

  }
}