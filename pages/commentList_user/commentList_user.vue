<template>
  <view>
    <view class="statusbar"></view>
    <view class="topbar">
      <view class="left" @click="naback">
        <image class="topbar-icon leftIco" src="../../static/image/icon/back_balck.png" mode="aspectFit" />
      </view>
      <view class="housename">待评价</view>
      <view class="right">

      </view>
    </view>

    <scroll-view scroll-y class="commentList" :class="{'whiteBg':info.length==0}">
      <view class="commentItem" v-if="info.length!=0" v-for="(item,index) in info" :key="index">
        <view class="item">
          民宿
        </view>
        <view class="picwrp">
          <view class="left">
            <view class="housename">
              {{item.housename}}
            </view>
            <view class="checktime">
              {{item.st.year}}-{{item.st.month}}-{{item.st.date}}&nbsp;至<br>{{item.et.year}}-{{item.et.month}}-{{item.et.date}}
            </view>
          </view>

          <image class="pic" :src="item.cover" mode="aspectFill" />
        </view>
        <view class="price">￥{{item.tprice}}</view>
        <view class="btngroup">
          <view class="placeholder"></view>
          <view class="mybtn" @click="tocomm(item)">去评价</view>
          <view class="mybtn" @click="bookagain(item)">再次预订</view>
        </view>
      </view>
      <view class="empty" v-if="info.length==0">
        <image src="../../static/image/empty_bg.png" mode="" /><br>
        暂无相关订单
      </view>
      <view class="mbb"></view>
    </scroll-view>
  </view>
</template>

<script>
import API from '../../static/data/API.js';
export default {
  data() {
    return {
      info: [],
      uname: ''
    }
  },
  methods: {
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
        arr: ['日', '一', '二', '三', '四', '五', '六'],
        timestamp: dateObj
      }
    },
    naback() {
      uni.navigateBack({
        delta: 1
      })
    },
    bookagain(item) {
      uni.navigateTo({
        url: `/pages/hotelDetail/hotelDetail?houseid=${item.hid}`
      })
    },
    tocomm(item) {
      uni.navigateTo({
        url: `/pages/comment_detail/comment_detail?uname=${this.uname}&lid=${item.lid}&hid=${item.hid}&oid=${item.oid}`
      })
    },
    queryCl() {
      uni.request({
        url: `${API.BASE_URL}/queryComments`, //仅为示例，并非真实接口地址。
        data: {
          userid: uni.getStorageSync('userId')
        },
        success: res => {
          console.log(res.data)
          if (res.data.data.comments.length != 0) {
            const orgList = res.data.data.comments
            orgList.forEach(element => {
              const obj = {}
              obj.housename = element.hov.housename
              obj.hid = element.hov.houseid
              obj.cover = element.hov.coverurl
              obj.st = this.getTime(new Date(element.order.starttime))
              obj.et = this.getTime(new Date(element.order.endtime))
              obj.lid = element.hov.landlordid
              obj.uname = this.uname
              obj.tprice = element.order.totalprice
              this.info.unshift(obj)
              obj.oid = element.order.orderid
            })
            console.log(this.info)
          }
        }
      })
    }
  },
  onLoad(option) {
    this.uname = option.uname
  },

  onShow() {
    this.info = []
    this.queryCl()
  }
}
</script>

<style lang="less">
.statusbar {
  width: 100vw;
  height: var(--status-bar-height);
  background-color: rgba(255, 255, 255, 0);
  position: fixed;
  top: 0;
  left: 0;
  z-index: 10;
}
.topbar {
  width: 100vw;
  background-color: rgba(255, 255, 255, 0);
  height: 80rpx;
  position: fixed;
  top: var(--status-bar-height);
  left: 0;
  z-index: 10;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx 20rpx;
  box-sizing: border-box;
  border-bottom: 1px solid rgb(236, 236, 236);
  .topbar-icon {
    vertical-align: bottom;
    width: 30rpx;
    height: 30rpx;
    margin-bottom: 5rpx;
  }
  font-weight: 900;
  .left {
    text-align: center;
    width: 60rpx;
    height: 40rpx;
  }

  .right {
    width: 60rpx;
    height: 40rpx;
    font-size: 26rpx;
    color: #fd720763;
    left: 40rpx;
  }
  .actived {
    color: #fd7207;
  }
}
.commentList {
  position: fixed;
  top: var(--status-bar-height);
  transform: translateY(80rpx);
  width: 100vw;
  height: 1550rpx;
  background-color: #f8f8f8;

  box-sizing: border-box;
  padding: 10rpx 24rpx;
  .mbb {
    width: 100%;
    height: 350rpx;
  }
  .commentItem {
    background-color: #fff;
    box-sizing: border-box;
    padding: 28rpx;
    border-radius: 14rpx;
    overflow: hidden;
    font-weight: 900;
    margin-bottom: 16rpx;
    .item {
      font-size: 26rpx;
    }
    .picwrp {
      margin-top: 10rpx;
      display: flex;
      width: 100%;
      justify-content: space-between;
      .left {
        width: 65%;
      }
      .housename {
        font-size: 34rpx;

        margin-left: 20rpx;
        display: -webkit-box;
        -webkit-box-orient: vertical;
        overflow: hidden;
        text-overflow: ellipsis;
        -webkit-line-clamp: 2; /* 指定显示的行数 */
      }
      .checktime {
        font-size: 26rpx;
        color: #555555;
        margin-left: 20rpx;
        margin-top: 10rpx;
      }
      .pic {
        width: 30%;
        height: 150rpx;
        border-radius: 16rpx;
      }
    }
    .price {
      margin-top: 10rpx;
      text-align: right;
      font-size: 28rpx;
    }
    .btngroup {
      display: flex;
      justify-content: space-between;
      margin-top: 15rpx;
      .placeholder {
        width: 55%;
      }
      .mybtn {
        border: 1px solid rgba(128, 128, 128, 0.178);
        padding: 6rpx 12rpx;
        font-size: 26rpx;
        border-radius: 10rpx;
      }
    }
  }
}
.empty {
  text-align: center;
  font-weight: 900;
  color: #747474;
}
.whiteBg {
  background-color: #fff;
}
</style>
