<template>
  <view>
    <view class="statusbar"></view>
    <view class="topblock">
      <view class="profile" @click="toEp" v-if="iLd!=null">
        <view class="avatar" >
          <image :src="avatar" class="avatarPic" mode="aspectFill" />
        </view>
        <view class="nicknamebox">
          <view class="nickname" >{{nickname}}</view>
          <view class="desc">身份<text v-if="!iLd">未</text>认证</view>
        </view>
      </view>
      <view class="favorData">
        <view class="data-item" @click="toWithDrawal">
          <view class="count ">￥{{balance}}</view>
          <view class="desc">余额</view>
        </view>
        <view class="data-item " @click="toWithDrawal">
          <view class="count">￥{{nocompleteMonry}}</view>
          <view class="desc">未到账</view>
        </view>
        <view class="data-item" @click="toManage">
          <view class="count">{{publiced}}</view>
          <view class="desc">已发布</view>
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
            <view class="iconcont">
              <image class="iconPic wallet" src="../../static/image/icon/wallet.png" mode="aspectFit"></image>
            </view>
            <view class="desc">待支付</view>
          </view>
          <view class="iconwrapper" @click="toOrderList(2)">
            <view class="iconcont">
              <image class="iconPic" src="../../static/image/icon/processing.png"></image>
            </view>
            <view class="desc">进行中</view>
          </view>
          <view class="iconwrapper" @click="toReply">
            <view class="iconcont">
              <image class="iconPic comment" src="../../static/image/icon/comment.png" mode="aspectFit"></image>
            </view>
            <view class="desc">待回复</view>
          </view>
          <view class="iconwrapper" @click="toOrderList(0)">
            <view class="iconcont">
              <image class="iconPic " src="../../static/image/icon/order.png"></image>
            </view>
            <view class="desc">全部</view>
          </view>
        </view>
      </view>
      <view class="sep"></view>
      <view class="fun">
        <view class="fun-item" @click="toVerify">
          <view class="icowrapper">
            <image class="ico" src="../../static/image/icon/verify.png" mode="" />
          </view>
          <view class="desc">房东认证</view>
        </view>
        <view class="fun-item" @click="toUploadHouse">
          <view class="icowrapper">
            <image class="ico" src="../../static/image/icon/uploadHouse.png" mode="" />
          </view>
          <view class="desc">发布房源</view>
        </view>
        <view class="fun-item" @click="toManage">
          <view class="icowrapper">
            <image class="ico" src="../../static/image/icon/manageHouse.png" mode="" />
          </view>
          <view class="desc">房源管理</view>
        </view>
        <view class="fun-item" @click="toIntro">
          <view class="icowrapper">
            <image class="ico" src="../../static/image/icon/lprofile.png" mode="" />
          </view>
          <view class="desc">房东主页</view>
        </view>
        <view class="fun-item" @click="toWithDrawal">
          <view class="icowrapper">
            <image class="ico" src="../../static/image/icon/balance.png" mode="" />
          </view>
          <view class="desc">余额提现</view>
        </view>
      </view>
      <view class="switchTolandlord btnsty" @click="toUser">切换到用户版</view>
    </view>

    <uni-popup ref="message" type="message">
        <uni-popup-message type="warn" message="请先认证" :duration="2000"></uni-popup-message>
      </uni-popup>
  </view>
</template>

<script>
import API from '../../static/data/API.js';
export default {
  data() {
    return {
      avatar: '',
      nickname: '',
      balance: 0,
      isfirst: true,
      nocompleteMonry: 0,
      iLd: null,
      publiced:0
    }
  },
  methods: {
    toUploadHouse() {
      uni.navigateTo({
        url: `/pages/upload/upload_overview/upload_overview?nickname=${this.nickname}`
      })
    },
    toVerify() {
      uni.navigateTo({
        url: '/pages/verifyLandlord/verifyLandlord'
      })
    },
    toIntro() {
      uni.navigateTo({
        url: '/pages/landlordIntro/landlordIntro'
      })
    },
    toUser() {
      uni.switchTab({
        url: '/pages/Components/profile/profile'
      })
    },
    isLandlordReq() {
      uni.request({
        url: `${API.BASE_URL}/hasLandlord`,
        data: {
          userid: uni.getStorageSync('userId')
        },
        success: res => {
          uni.setStorageSync('isLandlord', res.data)
          this.isLandlord = res.data
        }
      })
    },
    getLandlordProfile() {
      uni.request({
        url: `${API.BASE_URL}/getLandlordProfileData`, //仅为示例，并非真实接口地址。
        data: {
          landlordid: uni.getStorageSync('landlordid')
        },
        success: res => {
          console.log(res.data)
          this.avatar = res.data.data.avatar
          this.nickname = res.data.data.landlordProfile.nickname
          this.balance = res.data.data.landlordProfile.balance
          this.nocompleteMonry=res.data.data.noarrived
          this.publiced=res.data.data.hcount
        }
      })
    },
    toManage() {
      uni.navigateTo({
        url: '/pages/houseManage/houseManage'
      })
    },
    toEp() {
      if (!this.iLd) {
        this.$refs.message.open()
      } else {
        uni.navigateTo({
          url: '/pages/editLprofile/editLprofile'
        })
      }
    },
    toReply(){
      uni.navigateTo({
         url: `/pages/landCommentList/landCommentList`
      });
    },
        toOrderList(index){
      uni.navigateTo({
        url:`/pages/orderList_landlord/orderList_landlord?page=${index}`
      })
    },
    toWithDrawal(){
      uni.navigateTo({
        url:"/pages/withdrawal/withdrawal"
      })
    }
  },
  onLoad() {
    const isLandlord = uni.getStorageSync('isLandlord')
    this.iLd = JSON.parse(isLandlord) 
    if (!isLandlord) {
      uni.request({
        url: `${API.BASE_URL}/getProfileData`, //仅为示例，并非真实接口地址。
        data: {
          userid: uni.getStorageSync('userId')
        },
        success: res => {
          this.avatar = res.data.data.user.avatarpic
          this.nickname = res.data.data.user.username
        }
      })
    } else {

      this.getLandlordProfile()
    }
  },
  onShow() {
    uni.$on("uploadHouseSuccess",()=>{
      this.publiced+=1
    })
    uni.$on("deleteHouseSuccess",()=>{
      this.publiced-=1
    })
    if (!this.isfirst) {
      if (!this.isLandlord) {
        this.isLandlordReq()
      } else {
        console.log(111);
        this.getLandlordProfile()
      }
      // this.isLandlordReq()
    }
    this.isfirst = false
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
  background: linear-gradient(to left top, #ff8e0b, #fe7515);
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
      background-color: #fff;
      text-align: center;

      .avatarPic {
        width: 120rpx;
        height: 120rpx;
        margin-top: 50%;
        border-radius: 1111px;
        transform: translateY(-50%);
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
      .count{
        width: 100%;
        text-overflow: ellipsis;
        overflow: hidden;
        white-space: nowrap;
      }
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
        justify-content: center;
        text-align: center;
        align-content: center;
        .iconcont {
          width: 55rpx;
          height: 55rpx;
          margin-left: 50%;
          transform: translateX(-50%);
          text-align: center;

          overflow: hidden;
        }
        .iconPic {
          margin-top: 50%;
          transform: translateY(-50%);
          width: 45rpx;
          height: 45rpx;
        }
        .wallet {
          width: 60rpx;
          height: 60rpx;
        }
        .comment {
          width: 56rpx;
          height: 56rpx;
        }
        .desc {
          font-size: 24rpx;
          color: #212121;
        }
      }
    }
  }
  .sep {
    margin-top: 30rpx;
    width: 100vw;
    height: 30rpx;
    background: #f6f6f6;
  }
  .fun {
    padding: 28rpx 28rpx;
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    .fun-item {
      width: 24%;
      text-align: center;
      margin-bottom: 34rpx;
      .icowrapper {
        margin: auto;
        width: 45rpx;
        height: 45rpx;
        .ico {
          width: 45rpx;
          height: 45rpx;
        }
      }
      .desc {
        font-weight: bold;
        color: #212121;
        margin-top: 14rpx;
        font-size: 24rpx;
      }
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
