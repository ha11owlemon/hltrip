<template>
  <view>
    <view class="statusbar"></view>
    <view class="topbar">
      <view class="left" @click="nvback">
        <image class="topbar-icon leftIco" src="../../static/image/icon/back_balck.png" mode="aspectFit" />
      </view>
      全部评论
      <view class="right">
        <image class="topbar-icon rightIco" src="../../static/image/icon/message_white.png" mode="aspectFit" />
        <!-- <image class="topbar-icon rightIco" src="../../static/image/icon/message_black.png" mode="aspectFit" /> -->
      </view>
    </view>
    <scroll-view class="scrollWrapper" scroll-y="true" @scrolltolower="getNewData">
      <view class="topwrapper">
        <view class="top" v-if="firstComment!=undefined">
          <view class="rate">
            <text class="finalRate">{{firstComment.commentContent.rating}}</text>
            <image class="ratePic" :src="ratePic" mode="aspectFit" />
            <text class="totalCommentCount">{{`(共${this.total}条)`}}</text>
          </view>
          <view class="rateDetail">
            <view class="rateDetail-item" v-for="(item, index) in firstComment.commentContent.rateDetail" :key="index">
              <text class="desc">{{item.desc}}</text>
              <text class="sRate">{{item.rating}}</text>
            </view>
          </view>
        </view>
      </view>

      <view class="nbottom" v-if="comments.length!=0" v-for="(item,i) in comments" :key="i">
        <view class="avatar">
          <view class="avatar-left">
            <image class="avatarPic" :src="item.avatars.userAvatars" mode="aspectFill" />
          </view>
          <view class="avatar-right">
            <view class="nickname">{{item.commentContent.username}}</view>
            <view class="tar">
              <view class="time">{{item.commentContent.commenttime.year}}年{{item.commentContent.commenttime.month}}月{{item.commentContent.commenttime.date}}日评论</view>
              <view class="userrate">{{item.commentContent.rating}}</view>
            </view>
          </view>
        </view>

        <view class="commentContent">
          {{item.commentContent.commentcontent}}
        </view>
        <view class="picWrapper" v-if="item.commentImages!=undefined">
          <image v-for="(picObj, index) in item.commentImages" :key="index" class="comPic" @click="handlePreview(item,index)" :src="picObj.url" mode="scaleToFill" />
          <i></i><i></i><i></i>
        </view>

        <view class="reply" v-if="item.commentContent.landlordreply!=undefined">
          <view class="replyTitle">房东回复</view>
          <view class="replyContent">{{item.commentContent.landlordreply}}</view>
        </view>
      </view>
      <q-previewImage ref="previewImage" :urls="previewList"></q-previewImage>
    </scroll-view>

  </view>
</template>

<script>
import API from '../../static/data/API.js';
export default {
  data() {
    return {
      firstComment: undefined,
      comments: [],
      ratePic: '',
      total: 0,
      page: 1,
      previewList: [],
      houseid:null

    }
  },
  onBackPress() {
    try {
      this.$nextTick(() => {
        plus.navigator.setStatusBarStyle('light')
      })
    } catch (error) {
      console.log(err)
    }
  },
  methods: {
    nvback() {
      try {
        this.$nextTick(() => {
          plus.navigator.setStatusBarStyle('light')
        })
      } catch (error) {
        console.log(err)
      }
      uni.navigateBack({
        delta: 1
      })
    },
    handleRatePic() {
      let rate = this.firstComment.commentContent.rating
      if (rate <= 0.5) {
        this.ratePic = `../../static/image/rating${0.5}.png`
      } else if (rate <= 1.0) {
        this.ratePic = `../../static/image/rating${1.0}.png`
      } else if (rate <= 1.5) {
        this.ratePic = `../../static/image/rating${1.5}.png`
      } else if (rate <= 2.0) {
        this.ratePic = `../../static/image/rating${2.0}.png`
      } else if (rate <= 2.5) {
        this.ratePic = `../../static/image/rating${2.5}.png`
      } else if (rate <= 3.0) {
        this.ratePic = `../../static/image/rating${3.0}.png`
      } else if (rate <= 3.5) {
        this.ratePic = `../../static/image/rating${3.5}.png`
      } else if (rate <= 4.0) {
        this.ratePic = `../../static/image/rating${4.0}.png`
      } else if (rate <= 4.5) {
        this.ratePic = `../../static/image/rating${4.5}.png`
      } else if (rate <= 5.0) {
        this.ratePic = `../../static/image/rating${5.0}.png`
      }
    },
    handleComBrf(data) {
      try {
        let arr = []
        arr.push({
          desc: '整洁卫生',
          rating: data.cleanliness.toFixed(1)
        })
        arr.push({
          desc: '描述相符',
          rating: data.accuracy.toFixed(1)
        })

        arr.push({
          desc: '交通位置',
          rating: data.locationtransport.toFixed(1)
        })
        arr.push({
          desc: '安全程度',
          rating: data.safety.toFixed(1)
        })
        arr.push({
          desc: '性价比',
          rating: data.valueformmoney.toFixed(1)
        })
        delete data.cleanliness
        delete data.accuracy
        delete data.locationtransport
        delete data.safety
        delete data.valueformmoney
        data.rating = data.rating.toFixed(1)
        data.rateDetail = arr

        data.commenttime = this.getTime(new Date(data.commenttime))
      } catch (error) {
        console.log(data)
        console.log(error)
      }

      return data
    },
    getTime(dateObj) {
      const year = dateObj.getFullYear()
      const month = dateObj.getMonth() + 1
      const date = dateObj.getDate()
      const day = dateObj.getDay()
      return {
        year,
        month: month.toString().padStart(2, '0'),
        date: date.toString().padStart(2, '0'),
        day,
        arr: ['日', '一', '二', '三', '四', '五', '六']
      }
    },
    handlePreview(item, index) {
      console.log(item)
      this.previewList = []
      item.commentImages.forEach(element => {
        this.previewList.push(element.url)
      })
      this.$refs.previewImage.open(this.previewList[index])
    },
    getComment(houseid) {
      uni.request({
        url: `${API.BASE_URL}/getAllCommentByHouseid`, //仅为示例，并非真实接口地址。
        data: {
          houseid: houseid,
          page: this.page
        },
        success: res => {
          console.log(res.data);
          this.comments = res.data.data.comments
          this.firstComment = JSON.parse(JSON.stringify(this.comments[0]))
          this.handleRatePic()
          this.handleComBrf(this.firstComment.commentContent)

          for (let i = 0; i < this.comments.length; i++) {
            let element = this.comments[i]
            element = this.handleComBrf(element.commentContent)
          }
        }
      })
    },
    getNewData() {
      this.page++
      uni.request({
        url: `${API.BASE_URL}/getAllCommentByHouseid`, //仅为示例，并非真实接口地址。
        data: {
          houseid: this.houseid,
          page: this.page
        },
        success: res => {
          let arr = res.data.data.comments
          for (let i = 0; i < arr.length; i++) {
            console.log(i)
            let element = arr[i]
            element = this.handleComBrf(element.commentContent)
          }
          arr.forEach(element => {
            let existingData = this.comments.find(item => item.id === element.id)
            if (!existingData) {
              this.comments.push(element)
              
            } 
          })
        }
      })
    }
  },
  onLoad(option) {
    this.total = option.total
    const id = option.houseid
    console.log( option.houseid);
    this.houseid=id
    this.getComment(id)
  }
}
</script>

<style lang="less">
.statusbar {
  width: 100vw;
  height: var(--status-bar-height);
  background-color: rgb(255, 255, 255);
  position: fixed;
  top: 0;
  left: 0;
  z-index: 10;
}
.topbar {
  font-weight: 900;
  width: 100vw;
  background-color: rgba(255, 255, 255, 0);
  height: 80rpx;
  margin-top: var(--status-bar-height);
  display: flex;
  justify-content: space-between;
  align-items: center;
  .topbar-icon {
    align-items: center;
    vertical-align: bottom;
    width: 40rpx;
    height: 40rpx;
  }

  .leftIco {
    margin-left: 40rpx;
  }

  .rightIco {
    margin-right: 40rpx;
  }
}
.topwrapper {
  width: 90vw;
  border-radius: 14rpx;
  overflow: hidden;
  margin: 40rpx auto;
  .top {
    width: 100%;
    height: 180rpx;
    background-color: #edf4fe;
    box-sizing: border-box;
    padding: 20rpx 30rpx;
    vertical-align: bottom;
    .rate {
      .finalRate {
        color: #1eb5be;
        font-weight: bold;
        font-size: 54rpx;
      }
      .ratePic {
        width: 120rpx;
        height: 30rpx;
        margin-bottom: -4rpx;
        margin-left: 8rpx;
      }
      .totalCommentCount {
        font-weight: bold;
        font-size: 22rpx;
        margin-left: 10rpx;
      }
    }

    .rateDetail {
      width: 89%;
      display: flex;
      flex-wrap: wrap;
      font-size: 22rpx;
      font-weight: bold;
      .rateDetail-item {
        height: 34rpx;
        line-height: 34rpx;
        width: 33%;
        .sRate {
          margin-left: 10rpx;
        }
      }
    }
  }
}

.nbottom {
  padding: 20rpx;
  border-bottom: 1px solid #edf4fe;
  width: 90vw;
  margin: 60rpx auto;
  .avatar {
    display: flex;
    width: 100%;
    margin-top: 15rpx;

    .avatar-left {
      width: 100rpx;
      height: 100rpx;
      background-color: rgb(204, 204, 204);
      border-radius: 9999px;
      overflow: hidden;
      .avatarPic {
        width: 100rpx;
        height: 100rpx;
      }
    }
    .avatar-right {
      flex: 1;
      margin-left: 20rpx;
      .nickname {
        font-weight: bold;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }
      .tar {
        display: flex;
        font-size: 24rpx;
        font-weight: bold;
        .time {
          color: #6a6b6d;
        }
        .userrate {
          color: #fff;
          background-color: #ff7417;
          padding: 0 10rpx;
          margin-left: 30rpx;
          border-radius: 5rpx;
          position: relative;
          &::after {
            content: '';
            position: absolute; /* 相对于父元素定位 */
            left: -8rpx;
            top: 50%;
            transform: translateY(-50%);
            width: 0;
            height: 0;
            border-top: 10rpx solid transparent; /* 上边框设置为透明 */
            border-right: 10rpx solid #ff7417; /* 右边框设置为实色 */
            border-bottom: 10rpx solid transparent; /* 下边框设置为透明 */
          }
        }
      }
    }
  }
  .commentContent {
    font-weight: bold;
    font-size: 28rpx;
    margin-top: 20rpx;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    overflow: hidden;
    text-overflow: ellipsis;
    -webkit-line-clamp: 2; /* 指定显示的行数 */
  }
  .picWrapper {
    display: flex;
    flex-wrap: wrap;
    margin-top: 20rpx;
    margin-bottom: 20rpx;
    justify-content: space-between;
    i {
      width: 120rpx;
    }
    .comPic {
      width: 120rpx;
      height: 120rpx;
      border-radius: 16rpx;
      margin-top: 10rpx;
    }
  }
  .reply {
    .replyTitle {
      margin-top: 40rpx;
      font-weight: 900;
      font-size: 30rpx;
    }
    .replyContent {
      margin-top: 10rpx;
      color: #6a6b6d;
      font-weight: bold;
      font-size: 28rpx;
    }
  }
}
.scrollWrapper {
  height: 90vh;
}
</style>
