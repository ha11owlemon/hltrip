<template>
  <view>
    <view class="statusbar"></view>
    <view class="topbar">
      <view class="left" @click="back">
        上一步
      </view>
      入住政策
      <view class="right">
        <view class="nextBtn" :class="{'btnAct':canNext}" @click="complete">上传</view>
      </view>
    </view>

    <scroll-view scroll-y="true" class="content" scroll-with-animation="true">
      <view class="housename tbmargin60">
        <view class="title">是否允许加客</view>
        <radio-group @change="handleRadioChange" class="radiogroup tbmargin30">
          <label class="radio">
            <radio :value="false" color="#fd6f10" checked="true" style="transform:scale(0.7)" />不允许
          </label>
          <label class="radio">
            <radio :value="true" color="#fd6f10" style="transform:scale(0.7)" />允许
          </label>
        </radio-group>
        <input v-if="canAddGuest" type="text" class="textinput" v-model="houseInfo.policies.allowAddGuests" placeholder="请输入价格(加一人加多少钱)" />
      </view>

      <view class="housename tbmargin60">
        <view class="title">是否需要押金</view>
        <radio-group @change="handleRadioChange1" class="radiogroup tbmargin30">
          <label class="radio">
            <radio :value="false" color="#fd6f10" checked="true" style="transform:scale(0.7)" />不需要
          </label>
          <label class="radio">
            <radio :value="true" color="#fd6f10" style="transform:scale(0.7)" />需要
          </label>
        </radio-group>
        <input v-if="needdeposit" type="text" class="textinput" v-model="houseInfo.policies.deposit" placeholder="请输入押金价格" />
      </view>

      <view class="housename tbmargin60">
        <view class="title">免费取消</view>
        <view class="data_picker tbmargin30 widthp30">
          <view class="picker_title">
            下单后
          </view>
          <view class="pickerwrapper ">
            <picker @change="selectCancle" :value="index" :range="cancleArr">
              <view class="pickertext">{{cancleArr[index]}}</view>
            </picker>

          </view>
          <view class="desc">可以免费取消</view>
        </view>
      </view>
      <view class="housename tbmargin60">
        <view class="title">入住须知</view>
        <checkbox-group @change="handlentk" class="checkgroup tbmargin30">
          <label class="checkitem" v-for="item in ntkArr">
            <checkbox :value="item" :checked="false" color="#fd6f10" style="transform:scale(0.7)" />
            <text>{{item.text}}</text>
          </label>

        </checkbox-group>
      </view>
    </scroll-view>
    <view class="text" v-if="showLoading">
      <image class="ico" src="../../../static/image/icon/loading.gif" mode="" />
    </view>
    <uni-popup ref="alertDialog" type="dialog">
      <uni-popup-dialog type="error" cancelText="关闭" @close="dialogConfirm" confirmText="确定" title="通知" content="上传成功" @confirm="dialogConfirm"></uni-popup-dialog>
    </uni-popup>
  </view>
</template>

<script>
import API from '../../../static/data/API.js'
export default {
  data() {
    return {
      houseInfo: {
        policies: {
          cancelPolicy: '30',
          allowAddGuests: '0.0',
          deposit: '0.0',
          needToKnow: '000000000'
        }
      },
      cancleArr: ['30分钟内', '1天内', '2天内', '3天内'],
      array: [0, 1, 2, 3],
      canAddGuest: false,
      needdeposit: false,
      index: 0,
      ntkArr: [
        { index: 0, text: '接待婴儿' },
        { index: 1, text: '接待儿童' },
        { index: 2, text: '接待老人' },
        { index: 3, text: '接待外宾' },
        { index: 4, text: '带宠物' },
        { index: 5, text: '吸烟' },
        { index: 6, text: '做饭' },
        { index: 7, text: '聚会' },
        { index: 8, text: '商业拍摄' }
      ],
      selectArr: [],
      showLoading: false
    }
  },
  methods: {
    dialogConfirm() {
      uni.navigateBack({
        delta: 5
      })
    },
    complete() {
      if (this.canNext) {
        // 跳转到下一页
        const zeroArray = Array(9).fill(0)
        this.selectArr.forEach(element => {
          zeroArray[element.index] = 1
        })
        this.houseInfo.policies.needToKnow = zeroArray.join('')
        const info = uni.getStorageSync('houseInfo')
        info.policies = JSON.parse(JSON.stringify(this.houseInfo.policies))
        info.houseOverview.coverurl = info.houseImg[0].urls[0]
        this.showLoading = true
        uni.request({
          url: `${API.BASE_URL}/uploadHouse`, //仅为示例，并非真实接口地址。
          data: info,
          method: 'POST',
          success: res => {
            console.log(res.data)
            if (res.data.requestStatus == '200') {
              uni.removeStorageSync('houseInfo')
              this.showLoading = false
              this.$refs.alertDialog.open('info')
              console.log('success')
              uni.$emit("uploadHouseSuccess",null)
            } else {
              this.showLoading = false
              uni.removeStorageSync('houseInfo')
              uni.navigateBack({
                delta: 5
              })
              console.log('err')
            }
          },
          fail: err => {
            this.showLoading = false
            uni.removeStorageSync('houseInfo')
            uni.navigateBack({
              delta: 4
            })
            console.log('err')
          }
        })
        console.log(info)
      }
    },
    handleRadioChange(e) {
      this.canAddGuest = e.detail.value
      if (e.detail.value == false) {
        this.houseInfo.policies.allowAddGuests = '0.0'
      }
    },
    handleRadioChange1(e) {
      this.needdeposit = e.detail.value
      if (e.detail.value == false) {
        this.houseInfo.policies.deposit = '0.0'
      }
    },
    selectCancle(e) {
      this.index = e.detail.value
      if (e.detail.value != 0) {
        this.houseInfo.policies.cancelPolicy = e.detail.value.toString()
      } else {
        this.houseInfo.policies.cancelPolicy = '30'
      }
    },
    back() {
      uni.navigateBack({
        delta: 1
      })
    }
  },
  computed: {
    canNext() {
      return true
    }
  },
  onLoad() {}
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
  height: 1200rpx;

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
  .pickers {
    display: flex;
    flex-wrap: nowrap;
    width: 100%;
    justify-content: space-between;
    i {
      width: 100rpx;
    }
  }
  .data_picker {
    display: flex;
    border: 1px solid #f7f7f7;
    padding: 14rpx 10rpx;
    background-color: rgb(252, 252, 252);
    border-radius: 10rpx;
    font-weight: 900;
    font-size: 26rpx;
    color: #585858;
    .picker_title {
      min-width: 110rpx;
      text-align: center;
    }
    .pickertext {
      min-width: 80rpx;
      margin-left: 10rpx;
    }
    .desc {
      margin-left: 25rpx;
    }
  }
  .limitWidth {
    width: 200rpx !important;
  }
  .radio {
    font-size: 24rpx;
    font-weight: bold;
    color: #585858;
  }
  .tips {
    margin-top: 100rpx;
    width: 100%;
    text-align: center;
    font-size: 22rpx;
    color: #bebebe;
    font-weight: bold;
  }
  .pricewrapper {
    display: flex;
    overflow: hidden;
    .title {
      line-height: 96rpx;
    }
  }
  .location-view {
    display: flex;
    align-items: center;
    justify-content: space-between;
    width: 100%;
    padding: 10px;
    box-sizing: border-box;
    background-color: rgb(250, 250, 250);
    margin-top: 20rpx;
    border-radius: 10rpx;
  }
  .icon {
    width: 20px;
    height: 20px;
  }
  .location-text {
    flex-grow: 1;
    margin-left: 10px;
    font-size: 14px;
    color: #333;
    font-weight: 900;
  }
  .checkgroup {
    flex: 1;
    font-size: 26rpx;
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    font-weight: bold;
    color: #585858;
    i {
      width: 33%;
    }
    .checkitem {
      width: 33%;
      margin-bottom: 10rpx;
    }
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
