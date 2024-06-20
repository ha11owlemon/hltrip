<template>
  <view>
    <view class="statusbar"></view>
    <view class="topbar">
      <view class="left" @click="back">
        上一步
      </view>
      房源介绍
      <view class="right">
        <view class="nextBtn" :class="{'btnAct':canNext}" @click="next">下一步</view>
      </view>
    </view>

    <scroll-view scroll-y="true" class="content" scroll-with-animation="true">
      <view class="addBtn" v-if="houseInfo.features.length<3" @click="addFeature">
        <image class="icon" src="../../../static/image/icon/add.png" mode="aspectFit" />
        <text class="addtext">添加房源介绍</text>
      </view>

      <view class="featureitem" v-for="(item,index) in houseInfo.features" :key="index">
        <view class="left">
          <view class="ftitle">{{item.featureType}}</view>
          <view class="fcontent">{{item.featureContent}}</view>
        </view>
        <view class="right" @click="deletePop(index)">
          <image class="ico" src="../../../static/image/icon/clear.png" mode="aspectFit" />
        </view>
      </view>
			
    </scroll-view>

    <uni-popup ref="alertDialog" type="dialog">
      <uni-popup-dialog type="error" cancelText="关闭" confirmText="确定" title="通知" content="确定删除吗" @confirm="dialogConfirm"></uni-popup-dialog>
    </uni-popup>
  </view>
</template>

<script>
export default {
  data() {
    return {
      houseInfo: {
        features: []
      },
      currentIndex: 0
    }
  },
  methods: {
    next() {
      if (this.canNext) {
        uni.setStorageSync('houseInfo', this.houseInfo)
        // 跳转到下一页
				uni.navigateTo({
          url: '/pages/upload/upload_policy/upload_policy'
        })
      }
    },
    deletePop(index) {
      this.currentIndex = index
      this.$refs.alertDialog.open('info')
    },
    addFeature() {
      uni.navigateTo({
        url: '/pages/upload/upload_textarea/upload_textarea'
      })
    },
    dialogConfirm() {
      this.houseInfo.features.splice(this.currentIndex, 1)
      uni.setStorageSync('houseInfo', this.houseInfo)
    },
    back() {
      uni.navigateBack({
        delta: 1
      })
    }
  },
  computed: {
    canNext() {
      if (this.houseInfo.features.length <= 3 && this.houseInfo.features.length > 0) {
        return true
      } else {
        return false
      }
    }
  },
  onLoad() {
    // uni.removeStorageSync('houseInfo');
  },
  onShow() {
    const info = uni.getStorageInfoSync()
    const infoExist = info.keys.includes('houseInfo')
    if (infoExist) {
      this.houseInfo = uni.getStorageSync('houseInfo')
    }
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
  position: fixed;
  top: var(--status-bar-height);
  display: flex;
  justify-content: space-between;
  align-items: center;

  .left,
  .right {
    width: 200rpx;
    display: flex;
    justify-content: space-around;
    align-content: center;
    font-size: 28rpx;
    color: #fd6f10;
    .nextBtn {
      background-color: #ffac75;
      color: #fff;
      padding: 10rpx 20rpx;
      border-radius: 888rpx;
      font-size: 25rpx;
    }
    .btnAct {
      background-color: #fd6f10 !important;
    }
  }
}
.content {
  box-sizing: border-box;
  position: fixed;
  top: var(--status-bar-height);
  transform: translateY(80rpx);
  padding: 30rpx 40rpx 30rpx;
  width: 100vw;
  height: 1500rpx;
  .title {
    font-weight: 900;
    color: #585858;
  }
  .tbmargin60 {
    margin-top: 60rpx;
  }
  .tbmargin30 {
    margin-top: 30rpx;
  }
  .limitWidth {
    width: 200rpx !important;
  }
  .tips {
    margin-top: 100rpx;
    width: 100%;
    text-align: center;
    font-size: 22rpx;
    color: #bebebe;
    font-weight: bold;
  }
  .addBtn {
    padding: 25rpx 20rpx;
    margin-top: 10rpx;
    background-color: #fd6f102a;
    display: flex;
    align-content: center;
    justify-content: center;
    border-radius: 10rpx;
    .icon {
      width: 36rpx;
      height: 36rpx;
    }
    .addtext {
      font-weight: bold;
      margin-left: 10rpx;
      color: #1b1b1b;
      line-height: 36rpx;
    }
  }
  .featureitem {
    padding: 30rpx 25rpx;
    border-radius: 14rpx;
    display: flex;
    background-color: rgb(250, 250, 250);
    margin-top: 25rpx;
    .left {
      width: 90%;
      .ftitle {
        font-weight: 900;
        color: #1b1b1b;
      }
      .fcontent {
        font-size: 26rpx;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        width: 60%;
        color: #585858;
        margin-top: 5rpx;
      }
    }
    .right {
      flex: 1;
      display: flex;
      justify-content: center;
      align-content: center;
      width: 40rpx;
      height: auto;

      .ico {
        margin-top: 50%;
        transform: translateY(-50%);
        width: 40rpx;
        height: 40rpx;
      }
    }
  }
}
</style>
