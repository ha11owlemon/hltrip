<template>
  <view>
    <view class="statusbar"></view>
    <view class="topbar">
      <view class="left" @click="cancle">
        返回
      </view>
      房东介绍
      <view class="right">
        <view class="nextBtn" :class="{'btnAct':canNext}" @click="confirm">确定</view>
      </view>
    </view>
    <view class="content" v-if="isLandlord">
      <view class="housename tbmargin60">
        <view class="title">标题</view>
        <textarea auto-height="true" class="tarea1" @input="hanldeInput" v-model="title" placeholder="请输入介绍标题(例如:周边详情,房源特色等)" />
      </view>
      <view class="housename tbmargin60">
        <view class="title">内容</view>
        <textarea class="tarea" maxlength="50" @input="hanldeInput" v-model="content" placeholder="请输入内容..." />
        <view class="count">{{currentCursor}}/50</view>
      </view>

    </view>
    <view class="text" v-if="!isLandlord">
      请先完成房东认证
    </view>
    <view class="text" v-if="showLoading">
      <image class="ico" src="../../static/image/icon/loading.gif" mode="" />
    </view>
    <uni-popup ref="alertDialog" type="dialog">
      <uni-popup-dialog type="error" cancelText="关闭" @close="dialogConfirm" confirmText="确定" title="通知" content="编辑成功" @confirm="dialogConfirm"></uni-popup-dialog>
    </uni-popup>
  </view>
</template>

<script>
import API from '../../static/data/API.js';
export default {
  data() {
    return {
      title: '',
      content: '',
      currentCursor: 0,
      isLandlord: false,
      showLoading: false
    }
  },
  methods: {
    dialogConfirm() {
      uni.navigateBack()
    },
    hanldeInput(e) {
      this.currentCursor = e.detail.cursor
    },
    confirm() {
      if (this.canNext) {
        uni.request({
          url: `${API.BASE_URL}/addIntro`, //仅为示例，并非真实接口地址。
          data: {
            landlordid: 82,
            title: this.title,
            content: this.content
          },
          method: 'POST',
          success: res => {
            console.log(res.data)
            this.showLoading = false
            this.$refs.alertDialog.open('info')
          },
          fail: err => {
            console.log(err)
          }
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
    this.isLandlord = uni.getStorageSync('isLandlord')
    if (this.isLandlord) {
      uni.request({
        url: `${API.BASE_URL}/queryIntro`, //仅为示例，并非真实接口地址。
        data: {
          landlordid: uni.getStorageSync('landlordid')
        },
        success: res => {
          console.log(res.data)
          if (res.data.data.intro != null) {
            this.title = res.data.data.intro.introtitle
            this.content = res.data.data.intro.introcont
          }
        },
        fail: err => {
          console.log(err)
        }
      })
    }
  }
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
.text {
  line-height: 100vh;
  height: 100vh;
  width: 100vw;
  text-align: center;
  font-size: 30rpx;
  color: #2c2c2c;
  font-weight: 900;
  .ico {
    width: 60rpx;
    height: 60rpx;
  }
}
</style>
