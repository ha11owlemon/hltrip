<template>
  <view>
    <view class="statusbar"></view>
    <view class="topbar">
      <view class="left" @click="back">
        返回
      </view>
      基本信息
      <view class="right">
        <view class="nextBtn" :class="{'btnAct':canNext}" @click="next">下一步</view>
      </view>
    </view>

    <scroll-view scroll-y="true" class="content" scroll-with-animation="true" v-if="isLandlord">
      <view class="housename tbmargin60">
        <view class="title">民宿名称</view>
        <input type="text" class="textinput" placeholder="请输入民宿名" v-model="houseInfo.houseOverview.housename" />
      </view>
      <view class="address tbmargin60">
        <view class="title">民宿地址</view>
        <input type="text" class="textinput" placeholder="请输入民宿地址" v-model="houseInfo.houseOverview.address" />
      </view>
      <view class="fac tbmargin60">
        <view class="title">房间信息</view>
        <view class="pickers">
          <view class="data_picker tbmargin30 widthp30">
            <view class="picker_title">
              卧室:
            </view>
            <view class="pickerwrapper ">
              <picker @change="croom" :value="room_index" :range="array">
                <view class="pickertext">{{houseInfo.houseOverview.roomcount}}&nbsp;间</view>
              </picker>
            </view>
          </view>
          <view class="data_picker tbmargin30 widthp30">
            <view class="picker_title">
              浴室:
            </view>
            <view class="pickerwrapper ">
              <picker @change="cbathroom" :value="bathroom_index" :range="array1">
                <view class="pickertext">{{houseInfo.houseOverview.bathroomcount}}&nbsp;间</view>
              </picker>
            </view>
          </view>
          <view class="data_picker tbmargin30 widthp30">
            <view class="picker_title">
              厨房:
            </view>
            <view class="pickerwrapper ">
              <picker @change="ckitchen" :value="kitchen_index" :range="array1">
                <view class="pickertext">{{houseInfo.houseOverview.kitchencount}}&nbsp;间</view>
              </picker>
            </view>
          </view>
        </view>

      </view>

      <view class="fac tbmargin60">
        <view class="title">床位信息</view>
        <view class="pickers">
          <view class="data_picker tbmargin30 widthp30">
            <view class="picker_title">
              床共:
            </view>
            <view class="pickerwrapper ">
              <picker @change="cbedcount" :value="bedindex" :range="array">
                <view class="pickertext">{{houseInfo.houseOverview.bedcount}}&nbsp;张</view>
              </picker>
            </view>
          </view>
        </view>
        <view class="pickers">
          <view class="data_picker tbmargin30 widthp30">
            <view class="picker_title">
              双人床:
            </view>
            <view class="pickerwrapper ">
              <picker @change="cb218" :value="bed218_index" :range="array1">
                <view class="pickertext">{{houseInfo.houseOverview.bed218}}&nbsp;张</view>
              </picker>
            </view>
          </view>
          <view class="data_picker tbmargin30 widthp30">
            <view class="picker_title">
              大床:
            </view>
            <view class="pickerwrapper ">
              <picker @change="cb215" :value="bed215_index" :range="array1">
                <view class="pickertext">{{houseInfo.houseOverview.bed215}}&nbsp;张</view>
              </picker>
            </view>
          </view>
          <view class="data_picker tbmargin30 widthp30">
            <view class="picker_title">
              单人床:
            </view>
            <view class="pickerwrapper ">
              <picker @change="cb212" :value="bed212_index" :range="array1">
                <view class="pickertext">{{houseInfo.houseOverview.bed212}}&nbsp;张</view>
              </picker>
            </view>
          </view>
        </view>
      </view>

      <view class="fac tbmargin60">
        <view class="title">房型信息</view>
        <view class="pickers">
          <view class="data_picker tbmargin30 widthp30">
            <view class="picker_title">
              房屋类型:
            </view>
            <view class="pickerwrapper ">
              <picker @change="chousetype" :value="housetype_index" :range="housetypearr">
                <view class="pickertext">{{houseInfo.houseOverview.housetype}}</view>
              </picker>
            </view>

          </view>
          <view class="data_picker tbmargin30 widthp30">
            <view class="picker_title">
              出租类型:
            </view>
            <view class="pickerwrapper ">
              <picker @change="crenttype" :value="renttype_index" :range="rentTypearr">
                <view class="pickertext">{{houseInfo.houseOverview.rentaltype}}</view>
              </picker>
            </view>

          </view>
          <i></i>
        </view>
        <view class="data_picker tbmargin30 limitWidth">
          <view class="picker_title">
            标准入住
          </view>
          <view class="pickerwrapper ">
            <picker @change="cmaxguest" :value="maxguests_index" :range="array">
              <view class="pickertext limitWidth">{{houseInfo.houseOverview.maxguests}}&nbsp;人</view>
            </picker>
          </view>

        </view>
      </view>

      <view class="price tbmargin60">
        <view class="title">价格</view>
        <view class="pricewrapper"> <text class="title">￥</text>
          <input type="number" inputmode="decimal" class="textinput" placeholder="请输入折扣价(实际价格)" v-model="houseInfo.houseOverview.discountprice" />
        </view>
        <view class="pricewrapper"> <text class="title">￥</text>
          <input type="number" inputmode="decimal" class="textinput" placeholder="请输入原价" v-model="houseInfo.houseOverview.originalprice" />
        </view>
      </view>

      <view class="location tbmargin60">
        <view class="title">获取定位</view>
        <view @tap="getLocation" class="location-view">
          <image src="../../../static/image/icon/location2.png" class="icon" />
          <text class="location-text">{{ locationText }}</text>
        </view>

      </view>
      <view class="tips">tips:上传位置需与民宿在同一位置，否则审核会不通过</view>
    </scroll-view>
    <view class="text" v-if="!isLandlord">
      请先完成房东认证
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      houseInfo: {
        houseOverview: {
          housename: '',
          address: '',
          landlordid: 0,
          bedcount: 1, //
          roomcount: 1, //
          bathroomcount: 1, //
          kitchencount: 0, //
          coverurl: '',
          discountprice: '',
          originalprice: '',
          rentaltype: '单间出租', //
          maxguests: 2,
          housetype: '普通公寓', //
          landlordnickname: '',
          bed218: 1, //
          bed215: 0, //
          bed212: 0, //
          tatami: '' //
        },
        houseImg: [
          {
            ImgGroup: '卧室',
            urls: []
          },
          {
            ImgGroup: '卫生间',
            urls: []
          },
          {
            ImgGroup: '客厅',
            urls: []
          },
          {
            ImgGroup: '厨房',
            urls: []
          },
          {
            ImgGroup: '其他',
            urls: []
          }
        ],
        houseLocation: '',
        facilities: {
          service: '',
          basic: '',
          bathroom: '',
          kitchen: '',
          surrounding: '',
          safety: '',
          entertainment: '',
          leisure: '',
          children: ''
        },
        policies: {
          cancelPolicy: '30',
          allowAddGuests: '0.0',
          deposit: '0.0',
          needToKnow: '000000000'
        },
        features: []
      },
      array: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
      array1: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
      housetypearr: ['普通公寓', '别墅/loft', '庄园', '酒店式公寓', '客栈', '复式loft'],
      rentTypearr: ['整套出租', '单间出租'],
      bathroom_index: 0,
      room_index: 0,
      kitchen_index: 0,
      bedindex: 0,
      bed218_index: 0, //
      bed215_index: 0, //
      bed212_index: 0, //
      maxguests_index: 0,
      renttype_index: 0,
      housetype_index: 0,
      locationText: '点击获取位置',
      isLandlord: false,
      nickname: ''
    }
  },
  methods: {
    croom(e) {
      this.houseInfo.houseOverview.roomcount = this.array[e.detail.value]
    },
    cbathroom(e) {
      // console.log(e.detail.value);
      this.houseInfo.houseOverview.bathroomcount = e.detail.value
    },
    ckitchen(e) {
      // console.log(e.detail.value);
      this.houseInfo.houseOverview.kitchencount = e.detail.value
    },
    cbedcount(e) {
      // console.log(e.detail.value);
      this.houseInfo.houseOverview.bedcount = this.array[e.detail.value]
    },
    cb218(e) {
      // console.log(e.detail.value);
      this.houseInfo.houseOverview.bed218 = e.detail.value
    },
    cb215(e) {
      // console.log(e.detail.value);
      this.houseInfo.houseOverview.bed215 = e.detail.value
    },
    cb212(e) {
      // console.log(e.detail.value);
      this.houseInfo.houseOverview.bed212 = e.detail.value
    },
    chousetype(e) {
      this.houseInfo.houseOverview.housetype = this.housetypearr[e.detail.value]
    },
    crenttype(e) {
      this.houseInfo.houseOverview.rentaltype = this.rentTypearr[e.detail.value]
    },
    cmaxguest(e) {
      this.houseInfo.houseOverview.maxguests = this.array[e.detail.value]
    },
    getLocation() {
      const self = this
      uni.getLocation({
        type: 'gcj02',
        geocode: true,
        success(res) {
          console.log(res)
          self.locationText = res.address.street
          self.houseInfo.houseLocation = `${res.longitude},${res.latitude}`
        },
        fail() {
          self.locationText = '获取位置失败'
        }
      })
    },
    back() {
      uni.removeStorageSync('houseInfo')
      uni.navigateBack({
        delta: 1
      })
    },
    next() {
      if (this.canNext) {
        this.houseInfo.houseOverview.landlordnickname = this.nickname
        this.houseInfo.houseOverview.landlordid = uni.getStorageSync('landlordid')
        const hinfo = uni.getStorageSync('houseInfo')
        if (hinfo == '') {
          uni.setStorageSync('houseInfo', this.houseInfo)
        }
        console.log(this.houseInfo)
        // 跳转到下一页
        uni.navigateTo({
          url: '/pages/upload/upload_image/upload_image'
        })
      }
    }
  },
  computed: {
    isAddressEmpty() {
      if (this.houseInfo.houseOverview.address == '') {
        return true
      } else {
        return false
      }
    },
    isHousenameEmpty() {
      if (this.houseInfo.houseOverview.housename == '') {
        return true
      } else {
        return false
      }
    },
    isDpEmpty() {
      if (this.houseInfo.houseOverview.discountprice == '') {
        return true
      } else {
        return false
      }
    },
    isOpEmpty() {
      if (this.houseInfo.houseOverview.originalprice == '') {
        return true
      } else {
        return false
      }
    },
    isBedcVaild() {
      const overview = this.houseInfo.houseOverview
      if (overview.bedcount == overview.bed212 + overview.bed215 + overview.bed218) {
        return true
      } else {
        return false
      }
    },
    isLocEmpty() {
      if (this.houseInfo.houseLocation == '') {
        return true
      } else {
        return false
      }
    },
    canNext() {
      if(!this.isAddressEmpty&&!this.isDpEmpty&&!this.isOpEmpty&&!this.isHousenameEmpty&&this.isBedcVaild&&!this.isLocEmpty){
        return true
      }else{
        return false
      }

    }
  },
  onLoad(option) {
    console.log('hov onload')
    uni.removeStorageSync('houseInfo')
    this.isLandlord = uni.getStorageSync('isLandlord')
    // this.houseInfo.houseOverview.landlordnickname=option.nickname
    this.nickname = option.nickname
  },
  onBackPress() {
    uni.removeStorageSync('houseInfo')
    return false
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
    background-color: rgb(248, 248, 248);
    border-radius: 10rpx;
    font-weight: 900;
    font-size: 24rpx;
    color: #585858;
    .picker_title {
      min-width: 110rpx;
      text-align: center;
    }
    .pickertext {
      min-width: 80rpx;
      margin-left: 10rpx;
    }
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
}
.text {
  line-height: 100vh;
  height: 100vh;
  width: 100vw;
  text-align: center;
  font-size: 30rpx;
  color: #2c2c2c;
  font-weight: 900;
}
</style>
