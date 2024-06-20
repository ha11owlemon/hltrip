<template>
  <view>
    <div class="topbar"></div>
    <view class="title-wrapper">
      <view class="sidebar"></view>
      <view class="title">找回密码</view>
    </view>

    <view class="phoneNumber">
      <view class="phoneNumber-wrapper">
        <view class="prefix">+86</view>
        <input type="number" class="phoneNumber-input" placeholder="请输入手机号" v-model="phoneNumber" maxlength="11">
      </view>
      <view class="phoneNumber-wrapper code">
        <input type="password" class="phoneNumber-input" placeholder="请输入新密码" v-model="password">
      </view>
      <view class="phoneNumber-wrapper code">
        <input type="tel" class="phoneNumber-input" placeholder="请输入验证码" v-model="code" maxlength="6">
        <view class="timelimit"  :class="{'textColor':isPhone}">
          <text v-if="codeIsSended">{{codeText}}s</text>
          <text v-else @click="registerCode">获取验证码</text>
        </view>
      </view>
    </view>

    <view class="getCodeBtn" :class="{'btnActive':isRegAct}" @click="register">
      修改密码
    </view>


    <!-- 提示信息弹窗 -->
      <!-- 提示信息弹窗 -->
      <uni-popup ref="message" type="message">
        <uni-popup-message :type="msgType" :message="messageText" :duration="2000"></uni-popup-message>
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
      code: '',
      text: '',
      messageText: '',
      codeIsSended: false,
      codeText: 60,
			msgType:""
    }
  },
  methods: {
    register() {
      if (!this.isRegAct) {
        return false
      }
      uni.request({
        url: `${API.BASE_URL}/resetPwd`, //仅为示例，并非真实接口地址。
        data: {
          phoneNumber: this.phoneNumber,
          newPwd: this.password,
          code: this.code
        },
        method: 'POST',
        success: res => {
					console.log(res.data);
						if(res.data.requestStatus=="200"){
							this.messageText=res.data.dataDesc
							this.msgType="success"
							this.$refs.message.open()
              setTimeout(()=>{
                uni.navigateTo({
                   url: `/pages/loginByPwd/loginByPwd?phoneNumber=${this.phoneNumber}&password=${this.password}`
                });
              },1000)
						}else{
							this.messageText=res.data.dataDesc
							this.msgType="error"
							this.$refs.message.open()
						}
        },
        fail: err => {
          console.log(err)
        }
      })
    },
    registerCode() {
      if (this.phoneNumber.length != 11) {
        return false
      }
      this.codeIsSended = true

      const timer = setInterval(() => {
        if (this.codeText > 0) {
          this.codeText--
        } else {
          this.codeIsSended = false
          this.codeText = 60
          clearInterval(timer)
        }
      }, 1000)

      uni.request({
        url: `${API.BASE_URL}/getVerify`, //仅为示例，并非真实接口地址。
        data: {
          phoneNumber: this.phoneNumber,
          type: '找回密码'
        },
        method: 'POST',
        success: res => {}
      })
    }
  },
  computed: {
    isPhone() {
      if (this.phoneNumber != '' && this.phoneNumber.length == 11) {
        return true
      } else {
        return false
      }
    },
    isCode() {
      if (this.phoneNumber != '' && this.phoneNumber.length == 11 && this.code.length == 6) {
        return true
      } else {
        return false
      }
    },
    isRegAct() {
      if (this.phoneNumber.length == 11 && this.password != '' && this.code.length == 6) {
        return true
      } else {
        return false
      }
    }
  },
	onLoad:function(option){
		  if (option.phoneNumber != undefined) {
      this.phoneNumber = option.phoneNumber
    }
		if(option.password!=undefined){
			this.password=option.password
		}
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
  margin-top: 200rpx;
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
  margin-top: 40rpx !important;
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



</style>
