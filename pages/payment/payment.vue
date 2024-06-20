<template>
  <view >

  </view>
</template>

<script>
import API from '../../static/data/API.js';
export default {
  data() {
    return {
      orderStr: '',
      orderNum: '',
      isFirst: true
    }
  },
  methods: {
    topay() {
      let info = ''
      info = this.orderStr
      let orderNum = this.orderNum
      uni.getProvider({
        service: 'payment',
        success: function (res) {
          console.log(res.provider)
          if (~res.provider.indexOf('alipay')) {
            uni.requestPayment({
              provider: 'alipay', //固定值为"alipay"
              orderInfo: info, //此处为服务器返回的订单信息字符串
              success: function (res) {
                console.log('支付成功')
                uni.request({
                  url: `${API.BASE_URL}/checkPayStatus`,
                  data: {
                    orderNum: orderNum
                  },
                  success: res => {
                    console.log(res);
                    if (res.data.requestStatus == '200') {
                    
                      console.log(orderNum);
                      uni.removeStorageSync('orderStr')
                      uni.redirectTo({
                        url: `/pages/orderpay/orderpay?num=${orderNum}`
                      })
                    }
                     else {
                      uni.redirectTo({
                        url: `/pages/orderpay/orderpay?num=${orderNum}`
                      })
                    }
                  }
                })
              },
              fail: function (err) {
                uni.redirectTo({
    
                  url: `/pages/orderpay/orderpay?num=${orderNum}`
                })
                console.log('支付失败:' + JSON.stringify(err))
              }
            })
          }
        }
      })
    }
  },
  onLoad(option) {
    try {
      var EnvUtils = plus.android.importClass('com.alipay.sdk.app.EnvUtils')
      EnvUtils.setEnv(EnvUtils.EnvEnum.SANDBOX)
    } catch (error) {}

    this.orderStr = uni.getStorageSync('orderStr')
    this.orderNum = option.num
    this.topay()
  },
  onShow() {
    console.log("payment onshow");
    if(!this.isFirst){
      console.log("back1111");
      uni.navigateBack({
         delta: 1
      });
    }
    this.isFirst=false
  }
}
</script>

<style lang="less">
.pcrt {
  width: 100vw;
  height: 100vh;
  .loadingPic {
    width: 40rpx;
    height: 40rpx;
    margin: auto;
  }
}
</style>
