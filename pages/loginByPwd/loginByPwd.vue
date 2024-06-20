<template>
  <view>
    <div class="topbar"></div>
    <view class="title-wrapper">
      <view class="sidebar"></view>
      <view class="title">登录</view>
    </view>

    <view class="phoneNumber">
      <view class="phoneNumber-wrapper">
        <input type="number" class="phoneNumber-input" placeholder="请输入手机号" v-model="phoneNumber" maxlength="11">
      </view>
      <view class="phoneNumber-wrapper code">
        <input type="password" class="phoneNumber-input" placeholder="请输入密码" v-model="password">
      </view>
    </view>
    <view class="switchLoginMethod">
      <text class="left" @click="toLogin">用验证码登录</text>
      <text @click="toFPwd">忘记密码?</text>
    </view>
    <view class="getCodeBtn" :class="{'btnActive':isCode}" @click="login">
      登录
    </view>

    <!-- 提示信息弹窗 -->
    <!-- 提示窗示例 -->
    <uni-popup ref="alertDialog" type="dialog">
      <uni-popup-dialog type="info" cancelText="关闭" confirmText="确定" title="提示" content="该账号未注册，将为您跳转到注册页面" @confirm="dialogConfirm">
      </uni-popup-dialog>
    </uni-popup>

    <uni-popup ref="message" type="message">
      <uni-popup-message :type="msgType" :message="messageText" :duration="duration"></uni-popup-message>
    </uni-popup>
  </view>
</template>

<script>
import API from '../../static/data/API.js';
export default {
  data() {
    return {
      phoneNumber: '',
      password: '',
      messageText: '',
      codeIsSended: false,
      codeText: 60,
      msgType: '',
      duration: 2000
    }
  },
  methods: {
    login() {
      if (!this.isCode) {
        return false
      }
      uni.request({
        url: `${API.BASE_URL}/loginByPwd`, //仅为示例，并非真实接口地址。
        data: {
          phoneNumber: this.phoneNumber,
          password: this.password
        },
        method: 'POST',
        success: res => {
          console.log(res.data)
					const {data}=res.data
          if (res.data.requestStatus == '200') {
            this.msgType = 'success'
            this.messageText = '登录成功'
            this.$refs.message.open()
						uni.setStorageSync('phoneNumber', data.phoneNumber)
						uni.setStorageSync('userId', data.userId)
						uni.setStorageSync('token', data.token)
						setTimeout(()=>{
							uni.switchTab({
								 url: '/pages/Components/home/home',
							});
						},1000)
          } else if (res.data.requestStatus == '304') {
            this.messageText = res.data.dataDesc + ',为您跳转到注册'
            this.msgType = 'error'
            this.$refs.message.open()
            setTimeout(() => {
              uni.navigateTo({
                url: `/pages/register/register?phoneNumber=${this.phoneNumber}&password=${this.password}`
              })
            }, 1300)
          } else {
            console.log(res.data)

            this.messageText = res.data.dataDesc
            this.msgType = 'error'
            this.$refs.message.open()
          }
        },
        fail: err => {
          this.msgType = "登录超时"
            this.$refs.message.open()
          console.log(err)
        }
      })
    },
    dialogConfirm() {
      uni.navigateTo({
        url: `/pages/register/register?phoneNumber=${this.phoneNumber}`
      })
    },
    toLogin() {
      uni.redirectTo({
        url: '/pages/login/login'
      })
    },
    toFPwd() {
      uni.navigateTo({
        url: '/pages/resetPwd/resetPwd'
      })
    }
  },
  computed: {
    isCode() {
      if (this.phoneNumber.length == 11 && this.password.length >= 8) {
        return true
      } else {
        return false
      }
    }
  },
  onLoad: function (option) {
    //option为object类型，会序列化上个页面传递的参数
    if (option.phoneNumber != undefined ) {
      this.phoneNumber = option.phoneNumber
    }
		if (option.password != undefined ) {
      this.password = option.password
    }
    // console.log(option.phoneNumber); //打印出上个页面传递的参数。
    // console.log(option.code); //打印出上个页面传递的参数。
  }
}
</script>

<style lang="less">
.topbar {
  width: 100%;
  height: var(--status-bar-height);
  background-color: #fff;
}
.title-wrapper {
  width: 100%;
  margin-top: 250rpx;
  padding: 0 50rpx;
  display: flex;
  height: 80rpx;
  .sidebar {
    height: 100%;
    width: 15rpx;
    background-color: #ff7014;
  }
  .title {
    line-height: 80rpx;
    font-weight: bold;
    font-size: 60rpx;
    margin-left: 30rpx;
  }
}
.phoneNumber {
  padding: 0 50rpx;

  .phoneNumber-wrapper {
    display: flex;
    height: 100rpx;
    border-bottom: 1px solid #e2e2e2;
    margin-top: 90rpx;
    font-weight: bold;
    color: #919191;
    font-size: 45rpx;
    .prefix {
      height: 100%;
      width: 120rpx;
      text-align: center;
      line-height: 100rpx;
      color: #000;
    }
    .phoneNumber-input {
      height: 100%;
      flex: 1;
      padding: 0 20rpx;
      font-size: 45rpx;
      caret-color: #808080;
    }
  }
}
.getCodeBtn {
  text-align: center;
  font-size: 40rpx;
  font-weight: bold;
  height: 100rpx;
  line-height: 100rpx;
  background-color: rgb(212, 212, 212);
  width: 80%;
  margin: 50rpx auto;
  color: #808080;
  border-radius: 10rpx;
}

.btnActive {
  background-color: #ff7014;
  color: #fff;
}

.code {
  margin-top: 20rpx !important;
  .timelimit {
    height: 100%;
    line-height: 100rpx;
    font-size: 30rpx;
  }
}
.textColor {
  height: 100%;
  line-height: 100rpx;
  font-size: 30rpx;
  color: #ff7014;
}
.uni-popup-dialog {
  .uni-dialog-button-text {
    color: #ff7014;
  }
  .uni-button-color {
    color: #ff7014;
  }
}
.switchLoginMethod {
  display: flex;
  width: 82%;
  margin: 20rpx auto;
  justify-content: space-between;
  color: #808080;
}
</style>

