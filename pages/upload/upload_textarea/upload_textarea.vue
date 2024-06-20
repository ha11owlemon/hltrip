<template>
  <view>
    <view class="statusbar"></view>
    <view class="topbar">
      <view class="left" @click="cancle">
        返回
      </view>
      添加介绍
      <view class="right">
        <view class="nextBtn" :class="{'btnAct':canNext}" @click="confirm">确定</view>
      </view>
    </view>
    <view class="content">
      <view class="housename tbmargin60">
        <view class="title">标题</view>
        <textarea auto-height="true" class="tarea1" @input="hanldeInput" v-model="title" placeholder="请输入介绍标题(例如:周边详情,房源特色等)" />
      </view>
      <view class="housename tbmargin60">
        <view class="title">内容</view>
        <textarea class="tarea" maxlength="120" @input="hanldeInput" v-model="content" placeholder="请输入内容..." />
        <view class="count">{{currentCursor}}/120</view>
      </view>

    </view>

  </view>
</template>

<script>
export default {
  data() {
    return {
      title: '',
      content: '',
      currentCursor: 0,
      houseInfo: {
        features: []
      }
    }
  },
  methods: {
    hanldeInput(e) {
      this.currentCursor = e.detail.cursor
    },
    confirm() {
      if (this.canNext) {
        const obj = {
          featureType: this.title,
          featureContent: this.content
        }
        this.houseInfo.features.push(obj)
        uni.setStorageSync('houseInfo', this.houseInfo)
        uni.navigateBack({
          delta: 1
        })
      }
    },
    cancle() {
      uni.navigateBack()
    }
  },
  computed: {
    canNext() {
      if (this.title != '' && this.content != '') {
        return true
      } else {
        return false
      }
    }
  },
  onLoad() {
		const info = uni.getStorageInfoSync()
    const infoExist = info.keys.includes('houseInfo')
    if (infoExist) {
      this.houseInfo = uni.getStorageSync('houseInfo')
    }
  },

}
</script>

<style lang="less">
.statusbar {
  width: 100vw;
  height: var(--status-bar-height);
  background-color: rgba(255, 255, 255, 0);
}
.topbar {
  font-weight: 900;
  width: 100vw;
  background-color: rgba(255, 255, 255, 0);
  height: 80rpx;
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
  padding: 30rpx 40rpx 30rpx;
  width: 100vw;
  height: 1000rpx;
  .title {
    font-weight: 900;
    color: #585858;
  }
  .textinput {
    border: 1px solid rgb(233, 233, 233);
    margin-top: 10rpx;
    height: 60rpx;
    border-radius: 10rpx;
    padding: 8rpx 12rpx;
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
  .tarea {
    border: 1px solid rgb(233, 233, 233);
    margin-top: 10rpx;
    height: 300rpx;
    width: 95%;
    border-radius: 10rpx;
    padding: 8rpx 12rpx;
    font-weight: 900;
    color: #585858;
    font-size: 28rpx;
  }
  .tarea1 {
    border: 1px solid rgb(233, 233, 233);
    margin-top: 10rpx;
    width: 94%;
    border-radius: 10rpx;
    padding: 18rpx 16rpx;
    font-size: 28rpx;
    font-weight: 900;
    color: #585858;
  }
  .count {
    text-align: right;
    margin-top: 10rpx;
    margin-right: 20rpx;
    font-size: 28rpx;
    color: #bebebe;
  }
}
</style>
