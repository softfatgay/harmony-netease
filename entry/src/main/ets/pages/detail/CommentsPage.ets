import router from '@ohos.router'
import axios from '@ohos/axios';
import List from '@ohos.util.List';
import { COMMENT_LIST, COMMENT_PRAISE, COMMENT_TAGS, GOOD_DETAIL } from '../../base/Api';
import { ResponseData } from '../../base/BaseModel';
import { lineColor, textBlack, textGray, textRed } from '../../base/color';
import { PageState } from '../../base/PageState';
import { CommentItemView } from '../../component/CommentItem';
import { LoadingMore } from '../../component/LoadingMore';
import { TopBar } from '../../component/TopBar';
import { CommentItem } from '../../model/detail/CommentItem';
import { CommondPageModel } from '../../model/detail/CommondPageModel';
import { Pagination } from '../../model/detail/Pagination';
import { Praise } from '../../model/detail/Praise';
import { ResultItem } from '../../model/ResultItem';

@Entry
@Component
struct CommentsPage {
  @State _id: string = ''
  @State _tag: string = '全部';
  @State _page: number = 1;
  @State _showTagsNum: number = 6;
  @State _commentTags: Array<CommentItem> = [];
  @State _praise: Praise = new Praise();
  @State _pageState: PageState = PageState.None
  @State _commondPageModel: CommondPageModel = null
  @State _commentsList: Array<ResultItem> = []
  @State _pagination: Pagination = new Pagination()
  private scroller: Scroller = new Scroller()
  @State _onlyCommentTags: Array<CommentItem> = [];
  @State _expand: boolean = false

  aboutToAppear() {
    this._id = router.getParams()['id'] as string
    this._getPairs()
    this._getCommentTags()
    this._getCommentList()
  }

  _getPairs() {
    axios.get<ResponseData<Praise>>(COMMENT_PRAISE, {
      params: {
        'itemId': this._id
      }
    }).then(res => {
      this._praise = res.data.data
    }
    ).catch(err => {
      console.log(err)
    })
  }

  _getCommentTags() {
    axios.get<ResponseData<Array<CommentItem>>>(COMMENT_TAGS, {
      params: {
        'itemId': this._id
      }
    }).then(res => {
      var tags: Array<CommentItem> = res.data.data
      this._commentTags = tags
      console.log('++++++++++++++++', tags.length)
      if (tags != null && tags.length > 0) {
        if (tags.length > 6) {
          console.log('++++++++++++++++', 'aaaaaaaaa')
          let newTags = tags.slice(0, 6)
          this._onlyCommentTags = newTags
          console.log('++++++++++++++++', this._onlyCommentTags.length)
        }
      }
    }
    ).catch(err => {
      console.log(err)
    })
  }

  reset() {
    this._commentsList = []
    this._page = 1
    this._getCommentList()
  }

  _getCommentList() {
    axios.get<ResponseData<CommondPageModel>>(COMMENT_LIST, {
      params: {
        'itemId': this._id,
        'page': this._page,
        'tag': this._tag,
      }
    }).then(res => {
      let data = res.data.data
      this._commondPageModel = data
      let total = this._commentsList.concat(data.result)
      this._commentsList = total
      this._pagination = data.pagination
      console.log('==========CommentsPage', 'success')
    }
    ).catch(err => {
      console.log('==========CommentsPage', 'err')
      console.log(err)
    })
  }

  build() {
    Column() {
      TopBar({ title: '评价' })
      Scroll(this.scroller) {
        Column() {
          this.praise()
          this.commentsTage()
          if (this._onlyCommentTags.length > 0)
            this.expandView()
          this.comments()
          LoadingMore(!this._pagination.lastPage)
        }
        .align(Alignment.Top)
      }
      .align(Alignment.Top)
      .layoutWeight(1)
      .onScrollEdge(event => {
        console.log('================', this._pagination.lastPage)
        if (event.valueOf() == Edge.Bottom && !this._pagination.lastPage) {
          console.log('================', 'more')
          this._page += 1
          this._getCommentList()
        }
      })
    }
    .height('100%')
    .align(Alignment.Top)
  }

  @Builder
  expandView() {
    Row() {
      Text(this._expand ? '收起' : '更多').fontSize(14).fontColor(textGray)
      Image(this._expand ? $r('app.media.arrow_up') : $r('app.media.arrow_down'))
        .size({ width: 14, height: 14 })
        .margin({ left: 4 })
    }
    .width('100%')
    .border({ width: { bottom: 0.5 }, color: lineColor })
    .padding({ bottom: 16, top: 8 })
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .onClick(e => {
      this._expand = !this._expand
    })
  }

  @Builder
  comments() {
    ForEach(this._commentsList, (item: ResultItem) => {
      CommentItemView(item)
    })
  }

  @Builder
  praise() {
    Row() {
      Text('评分').fontSize(14).fontColor(textBlack)
      if (this._praise.star > 0)
        Rating({ rating: this._praise.star, indicator: false })
          .height(14)
          .aspectRatio(5)
          .margin({ left: 10 })
      Text(this._praise.goodCmtRate ?? '').fontColor(textGray).fontSize(14).margin({ left: 10 })

    }
    .width('100%')
    .align(Alignment.Start)
    .padding(12)
  }

  @Builder
  commentsTage() {
    Flex({ wrap: FlexWrap.Wrap }) {
      ForEach(this._expand ? this._commentTags : this._onlyCommentTags, (item: CommentItem) => {
        Text(`${item.name}(${item.strCount})`)
          .fontSize(14)
          .fontColor(this._tag == item.name ? textRed : textBlack)
          .border({ color: this._tag == item.name ? textRed : textBlack, width: 1 })
          .padding({ left: 4, right: 4, top: 2, bottom: 2 })
          .margin({ right: 16, top: 16 })
          .borderRadius(2)
          .onClick(e => {
            if (this._tag != item.name) {
              this._tag = item.name
              this.reset()
            }
          })
      })
    }.padding({ left: 12, right: 12 })
  }
}