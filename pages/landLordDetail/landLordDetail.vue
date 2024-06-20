<template>
  <view>
    <view class="statusbar"></view>

    <scroll-view scroll-y="true" class="container" @scrolltolower="getMoreHouse">
      <view class="topbar">
        <view class="left" @click="nvback">
          <image class="topbar-icon leftIco" src="../../static/image/icon/back_balck.png" mode="aspectFit" />
        </view>
        房东主页
        <view class="right">
          <image class="topbar-icon rightIco" src="../../static/image/icon/message_white.png" mode="aspectFit" />
          <!-- <image class="topbar-icon rightIco" src="../../static/image/icon/message_black.png" mode="aspectFit" /> -->
        </view>
      </view>
      <!-- 房东信息框 -->
      <view class="landLord" v-if="landlordbrief!=undefined">
        <view class="content" v-if="landlordbrief!=undefined">
          <view class="contentWrapper">
            <view class="left">
              <image class="lavatar" :src="landlordbrief.avatar" mode="aspectFill" />
            </view>
            <view class="right">
              <view class="nickname">{{landlordbrief.nickname}}</view>
              <view class="text">实名认证</view>
            </view>
          </view>
        </view>
      </view>
      <!-- 房东简介 -->
      <view class="intro" v-if="landlordInfo!=undefined">
        <view class="introCtnt">
          <view class="introTitle">{{landlordInfo.introtitle}}</view>
          <view class="introContent">{{landlordInfo.introcont}}</view>
        </view>
      </view>

      <view class="houseList">
        <view class="listTitle">在线房源</view>

        <view class="Listcontent" v-if="houseInfo.length!=0">
          <view class="contentWrapper">
            <view class="hotelItem" v-for="(item,index) in houseInfo" :key="index">
              <view class="picWrapper">
                <image class="pic" :src="item.overview.coverurl" mode="aspectFill" @click="nvtodt(item.overview.houseid)" />
                <view class="likewrap" @click="likeHotel(item)">
                  <image class="like" src="../../static/image/icon/like.png" v-if="!item.islike" />
                  <image class="like" src="../../static/image/icon/like-active.png" v-if="item.islike" />
                </view>

                <div class="hotelDesc">
                  <image class="icon" src="../../static/image/icon/location.png" mode="" />
                  <view class="desc">
                    {{item.overview.roomcount}}居 | {{item.locationInfo.city}}·{{item.locationInfo.county}}
                  </view>
                </div>
              </view>

              <view class="textWrapp" @click="nvtodt(item.overview.houseid)">
                <view class="hotelName">{{item.overview.housename}}</view>
                <text class="rmb">￥</text>
                <text class="currentPrice">{{item.overview.discountprice}}</text>
                <del class="orgPrice">￥{{item.overview.originalprice}}</del>
              </view>

            </view>
            <view class="hotelItem1" style=" width:20px;height:200rpx;background:transparent"></view>
          </view>
        </view>
      </view>

    </scroll-view>

  </view>
</template>

<script>
import API from '../../static/data/API.js';
export default {
  data() {
    return {
      houseInfo: [],
      overview: undefined,
      avatars: undefined,
      pagecount: 1,
      landlordbrief: undefined,
      landlordInfo: undefined,
      landlordid: null
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
    getMoreHouse() {
      this.pagecount++
      uni.request({
        url: `${API.BASE_URL}/getHouseInfoBylandlord`, //仅为示例，并非真实接口地址。
        data: {
          landlordid: this.landlordid,
          userid: uni.getStorageSync('userId'),
          page: this.pagecount
        },
        success: res => {
          let resouseData = res.data.data.houseInfo

          resouseData.forEach(element => {
            let isExist = this.houseInfo.findIndex(item => item.overview.houseid == element.overview.houseid)
            console.log(isExist)
            if (isExist == -1) {
              this.houseInfo.push(element)
            }
          })
        }
      })
    },
    nvtodt(houseid) {
      console.log(houseid)
      uni.navigateTo({
        url: `/pages/hotelDetail/hotelDetail?houseid=${houseid}`
      })
    },
    likeHotel(item) {
      item.islike = !item.islike
      uni.request({
        url: `${API.BASE_URL}/favorHouse`,
        data: {
          houseid: item.overview.houseid,
          userid: uni.getStorageSync('userId')
        }
      })
    }
  },
  onLoad(option) {
    this.landlordid = option.landlordid
    uni.request({
      url: `${API.BASE_URL}/getHouseInfoBylandlord`, //仅为示例，并非真实接口地址。
      data: {
        landlordid: option.landlordid,
        userid: uni.getStorageSync('userId'),
        page: this.pagecount
      },
      success: res => {
        console.log(res.data)
        const resouseData = res.data.data.houseInfo
        this.houseInfo = resouseData
        this.landlordInfo = res.data.data.landlordInfo
        this.landlordbrief = res.data.data.landlordbrief
      }
    })
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
.container {
  width: 100vw;

  .landLord {
    margin-top: 15rpx;
    width: 100%;
    .content {
      width: 100%;
      border: 1px solid #f4f4f5;
      border-radius: 16rpx;
      padding: 0 20rpx;
      .contentWrapper {
        margin: 30rpx 24rpx;
        display: flex;
        .left {
          width: 100rpx;
          height: 100rpx;
          // background-color: rgb(221, 221, 221);
          overflow: hidden;
          border-radius: 1111px;
          .lavatar {
            width: 100rpx;
            height: 100rpx;
          }
        }
        .right {
          flex: 1;
          margin-left: 40rpx;
          font-weight: bold;
          .nickname {
            font-size: 34rpx;
          }
          .text {
            font-size: 24rpx;
            color: #6a6b6d;
          }
        }
      }
    }
  }

  .intro {
    padding: 0 20rpx;

    .introHeader {
      font-size: 34rpx;
      font-weight: 900;
    }
    .introCtnt {
      background: linear-gradient(to left, #fdb44b, #ff731e);
      border: 1px solid #f4f4f5;
      margin-top: 10rpx;
      border-radius: 10rpx;
      padding: 20rpx 10rpx;

      .introTitle {
        font-size: 28rpx;
        font-weight: bold;
        white-space: wrap;
        color: rgb(255, 255, 255);
      }
      .introContent {
        font-size: 28rpx;
        color: #ffffffa9;
        font-weight: bold;
        margin-top: 10rpx;
        display: -webkit-box;
        -webkit-box-orient: vertical;
        overflow: hidden;
        text-overflow: ellipsis;
        -webkit-line-clamp: 2; /* 指定显示的行数 */
        line-clamp: 2;
        font-size: 26rpx;
        overflow: hidden;
      }
    }
  }

  .houseList {
    padding: 0rpx 20rpx;
    margin-top: 20rpx;
    height: 80vh;
    .listTitle {
      font-size: 38rpx;
      font-weight: 900;
      margin-bottom: -10rpx;
    }

    .Listcontent {
      width: 92vw;
      margin: 0rpx auto;
      .recomendDesc {
        display: flex;
        justify-content: space-between;
        font-weight: bold;
        font-size: 34rpx;
        position: relative;
        &::after {
          content: '';
          position: absolute; /* 相对于父元素定位 */
          left: 0;
          bottom: -20rpx;
          width: 70rpx;
          height: 10rpx;

          border-radius: 1111px;
          background: linear-gradient(to left, rgba(255, 0, 0, 0), #ff7417); /* 设置渐变背景 */
        }
      }

      .contentWrapper {
        margin-top: 44rpx;

        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        .hotelItem {
          box-shadow: rgba(75, 75, 75, 0.08) 0px 2.45097px 9.80386px 0px;
          border-radius: 12rpx;
          width: 48%;
          background-color: rgb(255, 255, 255);
          margin-top: 16rpx;
          overflow: hidden;
          .picWrapper {
            width: 100%;
            height: 440rpx;
            overflow: hidden;
            position: relative;
            .pic {
              filter: brightness(90%);
              width: 100%;
              height: 100%;
            }

            .hotelDesc {
              position: absolute;
              bottom: 0;
              width: 100%;
              display: flex;
              padding: 10rpx;
              color: #fff;
              font-weight: bold;
              background: linear-gradient(to top, rgba(17, 17, 17, 0.329), rgba(0, 0, 0, 0));
              .icon {
                width: 25rpx;
                height: 25rpx;
              }
              .desc {
                width: 86%;
                font-size: 20rpx;
                overflow: hidden;
                white-space: nowrap;
                text-overflow: ellipsis;
              }
            }

            .likewrap {
              position: absolute;
              top: 15rpx;
              right: 15rpx;
              .like {
                width: 45rpx;
                height: 45rpx;
              }
            }
          }

          .textWrapp {
            padding: 20rpx 16rpx;
            font-weight: bold;
            .hotelName {
              display: -webkit-box;
              -webkit-box-orient: vertical;
              overflow: hidden;
              text-overflow: ellipsis;
              -webkit-line-clamp: 2; /* 指定显示的行数 */
              line-clamp: 2;
              font-size: 26rpx;
              overflow: hidden;
            }

            .rmb {
              color: #ff7014;
              font-size: 24rpx;
            }
            .currentPrice {
              margin-top: 16rpx;
              margin-left: -6rpx;
              color: #ff7014;
              font-size: 36rpx;
            }
            .orgPrice {
              font-size: 20rpx;
              color: #919191;
            }
          }
        }
      }
    }
  }
}
</style>
