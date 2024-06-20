<template>
  <view>
    <view class="statusbar"></view>
    <view class="topblock">
      <view class="profile" @click="toEP">
        <view class="avatar">
          <image :src="avatar" class="avatarPic" mode="aspectFill" />
        </view>
        <view class="nicknamebox">
          <view class="nickname">{{nickname}}</view>
          <view class="desc">身份认证</view>
        </view>
      </view>
      <view class="favorData">
        <view class="data-item" @tap="toHAB(0)">
          <view class="count">{{favorcount}}</view>
          <view class="desc">收藏</view>
        </view>
        <view class="data-item" @tap="toHAB(1)">
          <view class="count">{{browsecount}}</view>
          <view class="desc">浏览</view>
        </view>
        <view class="data-item">
          <view class="count">0</view>
          <view class="desc">代金券</view>
        </view>
        <view class="data-item">
          <view class="count">0</view>
          <view class="desc">积分</view>
        </view>
      </view>
    </view>
    <view class="content">
      <view class="orders">
        <view class="title">我的订单</view>
        <view class="icongroup">
          <view class="iconwrapper" @click="toOrderList(1)">
            <view>
              <image class="iconPic wallet" src="../../../static/image/icon/wallet.png" mode="aspectFit"></image>
            </view>
            <view class="desc marginTopre">待支付</view>
          </view>
          <view class="iconwrapper" @click="toOrderList(2)">
            <view>
              <image class="iconPic" src="../../../static/image/icon/processing.png"></image>
            </view>
            <view class="desc">进行中</view>
          </view>
          <view class="iconwrapper" @click="toCommentList">
            <view>
              <image class="iconPic comment" src="../../../static/image/icon/comment.png" mode="aspectFit"></image>
            </view>
            <view class="desc marginTopre">待点评</view>
          </view>
          <view class="iconwrapper" @click="toOrderList(0)">
            <view>
              <image class="iconPic " src="../../../static/image/icon/order.png"></image>
            </view>
            <view class="desc">全部</view>
          </view>
        </view>
      </view>
      <view class="sep"></view>
      <view class="fun">
        <view class="con" @click="toAddpeople">
          <view>
            <image class="pic" src="../../../static/image/icon/group.png" mode="apsectFit" />
          </view>
          <view class="desc">常用入住人</view>
        </view>
      </view>
      <view class="logout btnsty" @click="logout">退出登录</view>
      <view class="switchTolandlord btnsty" @click="toLandlord">切换到房东版</view>
    </view>
  </view>
</template>

<script>
import API from '../../../static/data/API.js';
export default {
  data() {
    return {
      avatar: '',
      nickname: '',
      favorcount: 0,
      browsecount: 0,
      isfirst: true
    }
  },
  methods: {
    toHAB(index) {
      uni.$emit("sendIndexToFavor",index)
      uni.switchTab({
        url: `/pages/Components/Favor/Favor`,
        success:res=>{
          console.log(res);
        }
      })
    },
    toLandlord() {
      uni.navigateTo({
        url: '/pages/landlordProfile/landlordProfile'
      })
    },
    toAddpeople() {
      uni.navigateTo({
        url: '/pages/addContract/addContract'
      })
    },
    toEP() {
      uni.navigateTo({
        url: '/pages/editprofile/editprofile'
      })
    },
    toCommentList() {
      uni.navigateTo({
        url: `/pages/commentList_user/commentList_user?uname=${this.nickname}`
      })
    },
    toOrderList(index) {
      uni.navigateTo({
        url: `/pages/orderList_user/orderList_user?page=${index}`
      })
    },
    logout() {
      uni.removeStorageSync('token')
      uni.removeStorageSync('phoneNumber')
      uni.removeStorageSync('userId')
      uni.removeStorageSync('landlordid')
      uni.redirectTo({
        url: '/pages/login/login'
      })
    }
  },
  onLoad() {
    uni.request({
      url: `${API.BASE_URL}/getProfileData`, //仅为示例，并非真实接口地址。
      data: {
        userid: uni.getStorageSync('userId')
        // userid: 7
      },
      success: res => {
        console.log(res);
        this.avatar = res.data.data.user.avatarpic
        this.nickname = res.data.data.user.username
        this.favorcount = res.data.data.favorcount
        this.browsecount = res.data.data.browsecount
        if (res.data.data.user.role != 'landlord') {
          uni.setStorageSync('isLandlord', false)
          uni.removeStorageSync('landlordid')
        } else {
          uni.setStorageSync('isLandlord', true)
          uni.setStorageSync('landlordid', res.data.data.user.landlordid)
        }
      }
    })
  },
  onShow() {
    if (!this.isfirst) {
      uni.request({
        url: `${API.BASE_URL}/getProfileData`, //仅为示例，并非真实接口地址。
        data: {
          userid: uni.getStorageSync('userId')
        },
        success: res => {
          this.avatar = res.data.data.user.avatarpic
          this.nickname = res.data.data.user.username
          this.favorcount = res.data.data.favorcount
          this.browsecount = res.data.data.browsecount
        }
      })
    }
    this.isfirst = false
  },
  mounted() {
    // 设置状态栏文字颜色为白色，背景颜色为黑色
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

.topblock {
  background: linear-gradient(to left top, #303030, #797979);
  width: 100vw;
  height: 450rpx;
  position: relative;

  .profile {
    position: absolute;
    left: 30rpx;
    top: 100rpx;
    width: 600rpx;
    display: flex;
    justify-content: space-between;
    .avatar {
      width: 135rpx;
      height: 135rpx;
      border-radius: 778rpx;
      overflow: hidden;
      text-align: center;
      background-color: #fff;
      .avatarPic {
        width: 135rpx;
        height: 135rpx;
      }
    }
    .nicknamebox {
      font-size: 45rpx;
      color: white;
      font-weight: 900;
      margin-left: 20rpx;
      margin-top: 20rpx;
      display: flex;
      flex-direction: column;
      flex: 1;
      .nickname {
        width: 400rpx;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }
      .desc {
        font-size: 22rpx;
        margin-top: 4rpx;
      }
    }
  }

  .favorData {
    display: flex;
    position: absolute;
    bottom: 80rpx;
    width: 100vw;
    .data-item {
      text-align: center;
      width: 25vw;
      color: #fff;
      font-weight: 900;
      .desc {
        font-size: 24rpx;
        margin-top: 8rpx;
        color: rgba(255, 255, 255, 0.829);
      }
    }
  }
}
.content {
  position: relative;
  width: 100vw;
  height: 600rpx;
  background-color: rgb(255, 255, 255);
  &::before {
    content: '';
    position: absolute; /* 相对于父元素定位 */
    left: 0;
    top: -46rpx;
    height: 50rpx;
    width: 100vw;
    border-radius: 999px 999px 0 0;
    background: rgb(255, 255, 255);
  }
  .orders {
    padding: 0 28rpx;
    font-weight: 900;
    color: #212121;
    .icongroup {
      display: flex;
      justify-content: space-between;
      width: 100%;
      margin-top: 35rpx;
      .iconwrapper {
        width: 23%;
        height: auto;
        text-align: center;
        align-content: center;
        .iconPic {
          width: 55rpx;
          height: 55rpx;
        }
        .wallet {
          width: 80rpx;
          height: 80rpx;
        }
        .comment {
          width: 70rpx;
          height: 70rpx;
        }
        .desc {
          font-size: 24rpx;
          color: #212121;
        }
        .marginTopre {
          position: relative;
          top: -10rpx;
        }
      }
    }
  }
  .sep {
    margin-top: 20rpx;
    width: 100vw;
    height: 30rpx;
    background: #f6f6f6;
  }
  .fun {
    padding: 0 28rpx;
  }
  .con {
    font-weight: bold;
    color: #212121;
    text-align: center;
    width: 22%;
    margin-top: 40rpx;
    .pic {
      width: 55rpx;
      height: 55rpx;
    }
    .desc {
      font-size: 23rpx;
    }
  }
  .btnsty {
    width: 500rpx;
    margin: 40rpx auto;
    text-align: center;
    border: 1px solid #fe7204;
    background-color: #fff;
    padding: 15rpx 0;
    border-radius: 999px;
    color: #fe7204;
  }
  .logout {
    margin-top: 280rpx !important;
  }
}
</style>
