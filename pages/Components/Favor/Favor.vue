<template>
  <view>
    <view class="statusbar"></view>
    <view class="toggleBar">
      <view class="cardwrapper">
        <view class="favor carditem" :class="{'actived':currentCard==0}" @click="toggle(0)">我的收藏</view>
        <view class="history carditem" :class="{'actived':currentCard==1}" @click="toggle(1)">浏览记录</view>
      </view>

    </view>

    <scroll-view v-if="!showEmpty" scroll-y="true" class="content" @scrolltolower="getMoreHouse">
      <view class="favorCard" v-if="currentCard==0">
        <view class="content_item" v-for="(item,index) in houseInfo">
          <view class="item_left">
            <view class="imgWrapper">
              <image class="cover" :src="item.overview.coverurl" mode="aspectFill" />
            </view>

            <view class="icongroup" @click="likehouse(item)">
              <image class="like" src="../../../static/image/icon/like.png" v-if="!item.islike" />
              <image class="like" src="../../../static/image/icon/like-active.png" v-if="item.islike" />
            </view>
          </view>

          <view class="item_right">
            <view class="housename">{{item.overview.housename}}</view>
            <view class="facilities">
              {{item.overview.roomcount}}室厅·{{item.overview.bathroomcount}}卫·{{item.overview.bedcount}}张床·宜住{{item.overview.maxguests}}人
            </view>
            <view class="cityname">{{item.locationInfo.city}}</view>
            <view class="rtAndComment">
              <text class="rate">{{item.overview.rating.toFixed(1)}}</text>
              <text class="desc">分</text>
              <text class="seprator">·</text>
              <text class="comment">{{item.overview.commentcount}}点评</text>
            </view>
            <view class="btnToDt" @click="tohdt(item.overview.houseid)">查看详情</view>
          </view>
        </view>
      </view>
      <view class="historyCard" v-if="currentCard==1">
        <view class="content_item" v-for="(item,index) in houseInfo_history">
          <view class="item_left">
            <view class="imgWrapper">
              <image class="cover" :src="item.overview.coverurl" mode="aspectFill" />
            </view>

            <view class="icongroup" @click="likehouse(item)">
              <image class="like" src="../../../static/image/icon/like.png" v-if="!item.islike" />
              <image class="like" src="../../../static/image/icon/like-active.png" v-if="item.islike" />
            </view>
          </view>

          <view class="item_right">
            <view class="housename">{{item.overview.housename}}</view>
            <view class="facilities">
              {{item.overview.roomcount}}室厅·{{item.overview.bathroomcount}}卫·{{item.overview.bedcount}}张床·宜住{{item.overview.maxguests}}人
            </view>
            <view class="cityname">{{item.locationInfo.city}}</view>
            <view class="rtAndComment">
              <text class="rate">{{item.overview.rating.toFixed(1)}}</text>
              <text class="desc">分</text>
              <text class="seprator">·</text>
              <text class="comment">{{item.overview.commentcount}}点评</text>
            </view>
            <view class="btnToDt" @click="tohdt(item.overview.houseid)">查看详情</view>
          </view>
        </view>
      </view>

      <view class="nomore" v-if="showNoMore">-没有更多了-</view>
    </scroll-view>

    <view class="empty" v-if="showEmpty">
      <image src="../../../static/image/empty_bg.png" mode="aspectFit" />
      <view class="desc">暂时没有内容</view>
    </view>
  </view>
</template>

<script>
import API from '../../../static/data/API.js';
export default {
  data() {
    return {
      currentCard: 0,
      favorPage: 1,
      houseInfo: [],
      maxPage: 0,
      showNoMore: false,
      isFirstload: true,
      houseInfo_history: [],
      houseids: [],
      firstHistory: true,
      maxHistory: 0,
      historyPage: 1,
      showEmpty: false
    }
  },
  methods: {
    toggle(index) {
      this.currentCard = index
      this.showNoMore = false
    },
    requestFavor() {
      uni.request({
        url: `${API.BASE_URL}/getFavorList`,
        data: {
          userid: uni.getStorageSync('userId'),
          page: this.favorPage
        },
        success: res => {
          const sdata = res.data.data
          console.log(res.data)
          if (sdata.total == 0) {
            // 展示空状态
            this.showEmpty = true
          } else {
            this.showEmpty = false
            this.maxPage = Math.ceil(sdata.total / 10)

            if (this.houseInfo.length == 0) {
              this.houseInfo = sdata.houseInfo
            } else {
              this.houseInfo = [...this.houseInfo, ...sdata.houseInfo]
            }
            this.favorPage++
          }
        }
      })
    },
    sendReqWhenindexChange() {
      if (this.currentCard == 1) {
        this.getAllHistoryId()
        this.historyPage = 1
      } else {
      }
    },
    getMoreHouse() {
      if (this.currentCard == 0) {
        if (this.favorPage <= this.maxPage) {
          // 可以发请求
          this.requestFavor()
        } else {
          // 显示没有更多了
          this.showNoMore = true
        }
      } else {
        if (this.historyPage <= this.maxHistory) {
          // 可以发请求
          this.getMoreHistory()
        } else {
          // 显示没有更多了
          this.showNoMore = true
        }
      }
    },
    likehouse(item) {
      item.islike = !item.islike
      let hid = item.overview.houseid
      const obj = { hid: hid, islike: !item.islike }
      uni.$emit('changeid', obj)
      uni.request({
        url: `${API.BASE_URL}/favorHouse`,
        data: {
          houseid: item.overview.houseid,
          userid: uni.getStorageSync('userId')
        }
      })
    },
    flushFavor() {
      uni.request({
        url: `${API.BASE_URL}/getFavorList`,
        data: {
          userid: uni.getStorageSync('userId'),
          page: 1
        },
        success: res => {
          console.log(res);
          const sdata = res.data.data
          if (sdata.total == 0) {
            // 展示空状态
            this.showEmpty = true
            return false
          } else {
            this.showEmpty = false
            this.maxPage = Math.ceil(sdata.total / 10)
            this.houseInfo = sdata.houseInfo
            this.favorPage = 2
          }
        }
      })
    },
    tohdt(houseid) {
      uni.navigateTo({
        url: `/pages/hotelDetail/hotelDetail?houseid=${houseid}`
      })
    },
    getAllHistoryId() {
      console.log('gethouseids')
      uni.request({
        url: `${API.BASE_URL}/getAllHistoryId`,
        data: {
          userid: uni.getStorageSync('userId')
        },
        success: res => {
          if (res.data.requestStatus == '203') {
            this.showEmpty = true
            return false
          }
          this.showEmpty = false
          this.houseids = this.chunkArray(res.data.data.houseids, 10)

          this.maxHistory = houseids.length
        }
      })
    },
    chunkArray(array, chunkSize) {
      let result = []
      for (let i = 0; i < array.length; i += chunkSize) {
        let chunk = array.slice(i, i + chunkSize)
        result.push(chunk)
      }
      return result
    },
    initHistory() {
      console.log('inithistory')
      uni.request({
        url: `${API.BASE_URL}/getHistroyHouse`,
        data: {
          houseids: this.houseids[this.historyPage - 1],
          userid: uni.getStorageSync('userId')
        },
        success: res => {
          console.log(this.historyPage)
          this.houseInfo_history = res.data.data.houseInfo

          this.historyPage = this.historyPage + 1
          this.maxHistory = this.houseids.length
        }
      })
    },
    getMoreHistory() {
      uni.request({
        url: `${API.BASE_URL}/getHistroyHouse`,
        data: {
          houseids: this.houseids[this.historyPage - 1],
          userid: uni.getStorageSync('userId')
        },
        success: res => {
          this.houseInfo_history = [...this.houseInfo_history, ...res.data.data.houseInfo]
          this.historyPage = this.historyPage + 1
        }
      })
    }
  },
  onLoad() {
    this.requestFavor()
  },
  onShow() {
    uni.$on("sendIndexToFavor",(data)=>{
      this.currentCard=data
      console.log(2);
    })
    if (!this.isFirstload) {
      this.flushFavor()
    }
    this.isFirstload = false
    console.log('favor show')
  },
  mounted() {
    // 监听经纬度数据的变化，一旦发生变化，立即执行回调函数
    this.$watch('currentCard', this.sendReqWhenindexChange)
    this.$watch('houseids', this.initHistory)
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
.toggleBar {
  width: 100vw;
  height: 70rpx;
  position: fixed;

  background-color: #fff;
  z-index: 999;
  top: var(--status-bar-height);
  transform: translateY(15rpx);
  display: flex;
  justify-content: space-around;
  .cardwrapper {
    display: flex;
    border-radius: 16rpx;
    border: 1px solid #dfdfdf;
    overflow: hidden;
    .carditem {
      width: 150rpx;
      height: 100%;
      text-align: center;
      line-height: 70rpx;
      font-size: 28rpx;
      font-weight: 900;
      color: #656565;
      overflow: hidden;
    }
    .actived {
      background: linear-gradient(to right top, #fdb44b, #ff731e);
      color: #fff;
    }
  }
}

.content {
  position: absolute;
  height: 1390rpx;
  top: 150rpx;
  width: 100vw;
  .content_item {
    width: 95vw;
    margin: 23rpx auto;
    display: flex;
    box-shadow: rgba(75, 75, 75, 0.08) 0px 2.45097px 9.80386px 0px;
    padding: 12rpx 0;
    overflow: hidden;
    border-radius: 16rpx;
    .item_left {
      height: 300rpx;
      width: 240rpx;
      background-color: rgb(236, 236, 236);
      border-radius: 16rpx;
      position: relative;
      overflow: hidden;
      .cover {
        height: 300rpx;
        width: 240rpx;
      }
      .icongroup {
        position: absolute;
        top: 14rpx;
        left: 10rpx;
        .like {
          width: 40rpx;
          height: 40rpx;
        }
      }
    }
    .item_right {
      flex: 1;
      margin-left: 34rpx;
      position: relative;
      .housename {
        font-weight: 900;
        display: -webkit-box;
        -webkit-box-orient: vertical;
        overflow: hidden;
        text-overflow: ellipsis;
        -webkit-line-clamp: 2; /* 指定显示的行数 */
        line-clamp: 2;
        font-size: 32rpx;
        overflow: hidden;
        margin-top: 20rpx;
      }
      .facilities {
        font-weight: 900;
        font-size: 26rpx;
        margin-top: 10rpx;
      }
      .cityname {
        font-weight: 900;
        font-size: 30rpx;
        color: #747474;
        margin-top: 10rpx;
      }
      .rtAndComment {
        margin-top: 10rpx;
        font-weight: 900;
        .rate {
        }
        .desc {
          margin-left: 4rpx;
          font-size: 24rpx;
        }
        .seprator {
          margin-left: 10rpx;
          margin-right: 10rpx;
          font-weight: normal;
        }
        .comment {
          font-size: 24rpx;
          color: #747474;
        }
      }
      .btnToDt {
        color: #ffffff;
        font-weight: 900;
        font-size: 26rpx;
        width: 150rpx;
        height: 50rpx;
        text-align: center;
        line-height: 50rpx;
        border-radius: 1000px;
        position: absolute;
        right: 20rpx;
        bottom: 20rpx;
        margin-right: 0;
        background: linear-gradient(to right top, #fdb44b, #ff731e);
      }
    }
  }
  .nomore {
    margin-top: 20rpx;
    margin-bottom: 30rpx;
    color: #b1b1b1;
    text-align: center;
    font-weight: bold;
    font-size: 26rpx;
  }
}
.empty {
  text-align: center;

  margin-top: 300rpx;
  .desc {
    font-weight: 900;
    color: #747474;
  }
}
</style>
