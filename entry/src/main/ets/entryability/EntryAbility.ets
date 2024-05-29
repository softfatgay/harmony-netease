import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import axios from '@ohos/axios';
import { cookie, globalCookie, User } from '../base/User'
import { StorageUtils } from '../utils/StorageUtils';
import web_webview from '@ohos.web.webview'
import { baseUrl } from '../base/Api';

export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    this.init()
  }

  init() {
    User.cookie(globalCookie)
    StorageUtils.put('cookie', globalCookie)
    web_webview.WebviewController.initializeWebEngine()
    axios.interceptors.request.use(function (config) {
      config.headers['cookie'] = cookie
      console.log('----------request----------',config.url)
      console.log(JSON.stringify(config))
      return config;
    }, function (error) {
      // 对请求错误做些什么
      return Promise.reject(error);
    });

    axios.interceptors.response.use(function (res) {
      //  接收响应后做些什么
      console.log('----------response----------',res.config.url)
      console.log(JSON.stringify(res.data))
      return res;
    }, function (err) {
      //打印错误
      console.log(err)
    })
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
