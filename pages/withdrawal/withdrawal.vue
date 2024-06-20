<template>
  <view class="graybgc">
    <view class="statusbar"></view>
    <view class="topbar">
      <view class="left" @click="nvback">
        <image class="topbar-icon leftIco" src="../../static/image/icon/back_balck.png" mode="aspectFit" />
      </view>
      <view class="housename">余额管理</view>
      <view class="right">

      </view>

    </view>
    <view class="content">
      <view class="balanceModule">
        <view class="balance bitem">
          <view class="desc">我的余额</view>
          <view class="amount">￥{{balance}}</view>

        </view>

        <view class="noarrive bitem">
          <view class="desc">未到账</view>
          <view class="amount">￥{{nocompleteMonry}}</view>

        </view>
      </view>
      <view class="withdrawal">
        <view class="wdamount">
          <view class="desc">提现金额：</view>
          <view class="ph"></view>
          <view class="right">
            <text class="rmb">￥</text>

            <input class="tipt" @input="handleInput" :placeholder="money" type="Number">
          </view>
        </view>
        <view class="wdamount">
          <view class="desc">提现账户：</view>
          <view class="ph"></view>
          <view class="right">
            <input class="tipt tipt2" @input="inputAccount" placeholder="输入收款账户" type="text">
          </view>
        </view>
        <view class="wdamount">
          <view class="desc">预计到账：</view>
          <view class="right_t">
            ￥{{actualAmount}}
          </view>
        </view>
        <view class="wdamount">
          <view class="desc">服务费：</view>
          <view class="right_t">
            ￥{{fee}}
          </view>
        </view>
        <view class="btn" :class="{'active':canNext}" @click="clickBtn">提现</view>
      </view>
    </view>
    <view class="loading" v-if="isLoading">
      <image class="loadingPic" src="../../static/image/icon/loading.gif" mode="" />
    </view>
    <uni-popup ref="message" type="message" >
      <uni-popup-message :type="msgType" :message="wdwTxt" :duration="1400"></uni-popup-message>
    </uni-popup>

    <uni-popup ref="alertDialog1" type="dialog">
      <uni-popup-dialog type="error" cancelText="关闭" confirmText="确定" title="通知" :content="tipText" @confirm="confirmCancle"></uni-popup-dialog>
    </uni-popup>
  </view>
</template>

<script>
import API from '../../static/data/API.js';
export default {
  data() {
    return {
      balance: 0,
      nocompleteMonry: 0,
      wAmount: 0,
      account: '',
      wdwTxt: '',
      msgType: '',
			isLoading:false
    }
  },
  methods: {
		nvback(){
			uni.navigateBack()
		},
    getLandlordProfile() {
      uni.request({
        url: `${API.BASE_URL}/getLandlordProfileData`, //仅为示例，并非真实接口地址。
        data: {
          landlordid: uni.getStorageSync('landlordid')
        },
        success: res => {
          console.log(res.data)
          this.balance = res.data.data.landlordProfile.balance
          this.nocompleteMonry = res.data.data.noarrived
        }
      })
    },
    inputAccount(e) {
      this.account = e.detail.value
    },
    handleInput(e) {
      console.log(e.detail)
      this.wAmount = e.detail.value
    },
    requestwd() {
			this.isLoading=true
      uni.request({
        url: `${API.BASE_URL}/withdrawal`,
        data: {
          amount: this.wAmount,
          lid: uni.getStorageSync('landlordid'),
          account: this.account
        },
        success: res => {
          if (res.data.status == 200) {
						this.isLoading=false
            this.wdwTxt = '提现成功'
            this.msgType = 'success'
            this.$refs.message.open()
            setTimeout(() => {
              uni.navigateBack({
                delta: 1
              })
            }, 1400)
          } else {
						this.isLoading=false
            this.wdwTxt = res.data.reason
            this.msgType = 'error'
            this.$refs.message.open()
          }

        },
        fail: err => {
          console.log(err)
        }
      })
    },
    confirmCancle() {
      this.requestwd()
    },
    clickBtn() {
      if (this.canNext) {
        this.$refs.alertDialog1.open()
      } else {
        this.msgType = 'warn'
        this.wdwTxt = '请输入金额或账户'
        this.$refs.message.open()
      }
    }
  },
  computed: {
    tipText() {
      return '确认要提现到账户' + this.account + '吗，本操作不可撤回'
    },
    money() {
      return '最多可提￥' + this.balance
    },
    actualAmount() {
      const mv = this.wAmount - this.wAmount * 0.01
      return mv.toFixed(2)
    },
    fee() {
      const mv = this.wAmount * 0.01
      return mv.toFixed(2)
    },
    canNext() {
      if (this.wAmount != 0 || this.wAmount != '') {
        if (this.account != '') {
          if (this.balance >= parseInt(this.wAmount)) {
            return true
          }
        }
      } else {
        return false
      }
    }
  },
  onShow() {
    this.getLandlordProfile()
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
.content {
  width: 100vw;
  height: 1550rpx;
  background-color: rgb(250, 250, 250);
  box-sizing: border-box;
  position: fixed;
  top: var(--status-bar-height);
  transform: translateY(80rpx);
  .balanceModule {
    width: 100%;
    padding: 16rpx 24rpx;
    display: flex;
    justify-content: space-between;
    box-sizing: border-box;
    .bitem {
      width: 49%;
      background-color: rgb(255, 255, 255);
      border-radius: 20rpx;
      box-sizing: border-box;
      padding: 20rpx;
      .desc {
        color: #b3b3b3;
        font-size: 26rpx;
      }
      .amount {
        font-weight: 900;
        font-size: 45rpx;
        margin-top: 15rpx;
        color: #fd7207;
        width: 95%;
        text-overflow: ellipsis;
        overflow: hidden;
        white-space: nowrap;
      }
    }
  }
  .withdrawal {
    width: 100vw;
    padding: 10rpx 24rpx;
    margin-top: 10rpx;
    box-sizing: border-box;
    .wdamount {
      width: 100%;
      background-color: #fff;
      padding: 20rpx 20rpx;
      border-radius: 10rpx;
      box-sizing: border-box;
      display: flex;
      justify-content: space-between;
      .desc {
        color: #3e3e3e;
        font-weight: 900;
        font-size: 28rpx;
        line-height: 70rpx;
      }
      .right {
        background-color: #f8f8f8;
        flex: 1;
        height: 70rpx;
        line-height: 70rpx;
        display: flex;
        padding-left: 10rpx;
        .rmb {
          font-weight: 900;
          color: #808080;
        }
        .tipt {
          font-size: 26rpx;
          width: 70%;
          height: 100%;
          font-weight: 900;
          padding: 0rpx;
          box-sizing: border-box;
          display: inline-block;
          color: #808080;
        }
        .tipt2 {
          padding: 0rpx 20rpx;
        }
      }
      .right_t {
        height: 70rpx;
        line-height: 70rpx;
        font-size: 24rpx;
        color: #fd7207;
        font-weight: 900;
      }
    }
    .btn {
      margin-top: 40rpx;
      width: 100%;
      background-color: #fd720749;
      height: 90rpx;
      text-align: center;
      border-radius: 10rpx;
      line-height: 90rpx;
      font-size: 32rpx;
      font-weight: 900;
      color: #f8f8f8;
    }
    .active {
      background-color: #fd7207;
    }
  }
}

.loading{
	width: 100vw;
	height: 100vh;
	position: fixed;
	background-color: rgba(255, 255, 255, 0.589);
	z-index: 9999;
	
	.loadingPic{
		width: 50rpx;
		height: 50rpx;
		position: absolute;
		top: 50%;
		left: 50%;
		transform: translate(-50%,-50%);

	}
}
</style>
