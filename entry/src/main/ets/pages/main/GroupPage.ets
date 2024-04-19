@Entry
@Component
export struct GroupPage {
  build() {
    Text('分类')
  }
}

@Styles function relativeCenter() {
  .alignRules(
    {
      middle: { anchor: '__container__', align: HorizontalAlign.Center },
      center: { anchor: '__container__', align: VerticalAlign.Center },
    }
  )
}
