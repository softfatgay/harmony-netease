export class TabBarModel {
  index: Number = 0
  normalImg: Resource = $r('app.media.app_icon')
  selectImg: Resource = $r('app.media.app_icon')
  title: Resource = $r('app.string.app_name')
}

const tabBarList: TabBarModel[] = [
  {
    index: 0,
    normalImg: $r('app.media.ic_tab_home_normal'),
    selectImg: $r('app.media.ic_tab_home_active'),
    title: $r('app.string.home'),
  }, {
  index: 1,
  normalImg: $r('app.media.ic_tab_subject_normal'),
  selectImg: $r('app.media.ic_tab_subject_active'),
  title: $r('app.string.group'),
}, {
  index: 2,
  normalImg: $r('app.media.ic_tab_group_normal'),
  selectImg: $r('app.media.ic_tab_group_active'),
  title: $r('app.string.subject'),
}, {
  index: 3,
  normalImg: $r('app.media.ic_tab_cart_normal'),
  selectImg: $r('app.media.ic_tab_cart_active'),
  title: $r('app.string.cart'),
}, {
  index: 4,
  normalImg: $r('app.media.ic_tab_shiji_normal'),
  selectImg: $r('app.media.ic_tab_shiji_active'),
  title: $r('app.string.profile'),
}
]

export { tabBarList }