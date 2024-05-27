import HashMap from '@ohos.util.HashMap'
import { StorageUtils } from '../utils/StorageUtils';

export class User {

  static cookie(value:string){
      cookie = value
  }

  static setCookieMap(){
    cookieMap()
  }

  static get cookieMap(): HashMap<string, string> {
    var cookieMap: HashMap<string, string> = new HashMap()
    var list = cookie.split('; ')
    list.forEach(item => {
      if (item.match('=')) {
        let kvPair = item.split('=')
        let name = kvPair[0]
        let value = kvPair[1]
        cookieMap[name] = value
      }
    })
    return cookieMap
  }
}

export const globalCookie = 'yx_s_device=29e141a-723a-5ee8-264e-5ac4b04e66; yx_from=yx_wap_click_1; yx_cookie_ctime="yx_from=1716364296709"; mail_psc_fingerprint=ed0c7f5c2dc4bc633d15eb184897427e; yx_aui=7aead0e8-0604-44f1-87a6-e14f440f86b8; yx_from=yx_wap_click_1; yx_but_id=876d10f05b034c64a34d642f99e978679c899a8bc449a1d6_v1_nl; yx_s_tid=tid_web_4aff61e81ae64fa8ac530eb1a59883d8_423f89d20_1; _bl_uid=jvle0wdChswiehzwCjywqbgyyd85; YX_SUPPORT_WEBP=1; yx_stat_ypmList=; yx_aielx_pop_time=1716789960585; yx_stat_seesionId=7aead0e8-0604-44f1-87a6-e14f440f86b81716789960743; yx_stat_seqList=v_971f98c213|v_ab8d274397;-1;v_73d009578a;-1;v_971f98c213;-1; NTES_P_UTID=lXvdfVpD5KgIYLUPFgcjLwq6wEju1Up8|1716789989; NTES_SESS=FwyU6OzzgbpLv2CSWHagPUXiLVMQfm2Gfn.y8EmTtZ3915ST1ltocJjTL4iuDFZqPLh9vt1qfobCFr2B5l1R7dqon64Mfo3qRUdeAEbtW7Q0vxWTmgPj_a76m8lkemgV0zUs2p_uWGGBPvkRjfIXm5epTzP3wyIcb2D1g._SUGL5fYWMWz1yKP6QgKWmeKQz4SnYnVZSicX4VxGJY_pzgQjWV; S_INFO=1716789989|0|3&80##|wan_tuan; P_INFO=wan_tuan@163.com|1716789989|0|yanxuan_web|00&15|UK&1715739819&yanxuan_web#UK&null#10#0#0|176088&0|mail163|wan_tuan@163.com; yx_new_sid=28327067_1716789989278_R0K16t; yx_curusername=wan_tuan@163.com; yx_userid=28327067; yx_username=wan_tuan@163.com; yx_csrf=2e58282277b9fb5fbf99c09bf50b84e8'

export let cookie = ''

export const csrf_token = cookieMap()['csrf_token']

export const timestampParams = {
  "csrf_token": cookieMap()['csrf_token'],
  "__timestamp": `${Date.now().toLocaleString()}`
}

export const commonHeaders = {
  'cookie': cookie
}

export function cookieMap(): HashMap<string, string> {
  var cookieMap: HashMap<string, string> = new HashMap()
  var list = cookie.split('; ')
  list.forEach(item => {
    if (item.match('=')) {
      let kvPair = item.split('=')
      let name = kvPair[0]
      let value = kvPair[1]
      cookieMap[name] = value
    }
  })
  return cookieMap
}

