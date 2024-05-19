import router from '@ohos.router'
import axios from '@ohos/axios';
import { COMMENT_LIST, COMMENT_PRAISE, COMMENT_TAGS, GOOD_DETAIL } from '../../base/Api';
import { ResponseData } from '../../base/BaseModel';
import { textBlack, textGray, textRed } from '../../base/color';
import { PageState } from '../../base/PageState';
import { TopBar } from '../../component/TopBar';
import { CommentItem } from '../../model/detail/CommentItem';
import { CommondPageModel } from '../../model/detail/CommondPageModel';
import { Praise } from '../../model/detail/Praise';

@Entry
@Component
struct CommentsPage {
  @State _id: string = ''
  @State _tag: string = '全部';
  @State _checkedItem: string = '全部';
  @State _page: number = 1;
  @State _showTagsNum: number = 6;
  @State _commentTags: Array<CommentItem> = [];
  @State _praise: Praise = new Praise();
  @State _pageState: PageState = PageState.None
  @State _commondPageModel: CommondPageModel = null

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
      this._commentTags = res.data.data
    }
    ).catch(err => {
      console.log(err)
    })
  }

  _getCommentList() {
    axios.get<ResponseData<CommondPageModel>>(COMMENT_LIST, {
      params: {
        'itemId': this._id,
        'page': this._page,
        'tag': this._tag,
      }
    }).then(res => {
      this._commondPageModel = res.data.data
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
      this.praise()
      this.commentsTage()
    }.alignItems(HorizontalAlign.Start)
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
    .padding(12)
  }

  @Builder
  commentsTage() {
    Flex({ wrap: FlexWrap.Wrap }) {
      ForEach(this._commentTags, (item: CommentItem) => {
        Text(`${item.name}(${item.strCount})`)
          .fontSize(14)
          .fontColor(this._checkedItem == item.name ? textRed : textBlack)
          .border({ color: this._checkedItem == item.name ? textRed : textBlack, width: 1 })
          .padding({ left: 4, right: 4, top: 2, bottom: 2 })
          .margin({ right: 16, top: 16 })
          .borderRadius(2)
      })
    }.padding({ left: 12, right: 12 })
  }
}