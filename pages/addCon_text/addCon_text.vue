<template>
  <view>
    <view class="statusbar"></view>
    <view class="topbar">
      <view class="left" @click="cancle">
        返回
      </view>
      添加信息
      <view class="right">
        <view class="nextBtn" :class="{'btnAct':canNext}" @click="confirm">确定</view>
      </view>
    </view>
    <view class="content">
      <view class="housename tbmargin60">
        <view class="title">姓名</view>
        <textarea auto-height="true" class="tarea1" @input="hanldeInput" v-model="realname" placeholder="请输入姓名" />
      </view>
      <view class="housename tbmargin60">
        <view class="title">身份证号</view>
        <textarea class="tarea" auto-height="true" @input="hanldeInput" v-model="cardNumber" placeholder="请输入身份证" />
      </view>

    </view>
    <uni-popup ref="message" type="message">
      <uni-popup-message :type="msgtype" :message="msgText" :duration="1000"></uni-popup-message>
    </uni-popup>
  </view>
</template>

<script>
import API from '../../static/data/API.js';
export default {
  data() {
    return {
      realname: '',
      cardNumber: '',
      msgtype: 'success',
      msgText: '删除成功'
    }
  },
  methods: {
    confirm() {
      if (this.canNext) {
        uni.request({
          url: `${API.BASE_URL}/addIDinfo`, //仅为示例，并非真实接口地址。
          data: {
            uid: uni.getStorageSync('userId'),
            name: this.realname,
            idnum: this.cardNumber
          },
          success: res => {
            console.log(res.data)
            if (res.data) {
              // success
              this.msgtype = 'success'
              this.msgText = '添加成功'
              this.$refs.message.open()
							setTimeout(()=>{
								uni.navigateBack()
							},1000)
            } else {
              // fail
							this.msgtype = 'error'
              this.msgText = '添加失败，请重试'
              this.$refs.message.open()
            }
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
      if (this.realname != '' && this.cardNumber != '') {
        return true
      } else {
        return false
      }
    }
  },
  onLoad() {}
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
    border-bottom: 1px solid rgb(233, 233, 233);
    margin-top: 12rpx;
    width: 95%;
    padding: 18rpx 16rpx;
    font-weight: 900;
    color: #585858;
    font-size: 28rpx;
  }
  .tarea1 {
    border-bottom: 1px solid rgb(233, 233, 233);
    margin-top: 10rpx;
    width: 94%;
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
