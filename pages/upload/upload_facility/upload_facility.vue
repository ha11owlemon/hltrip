<template>
  <view>
    <view class="statusbar"></view>
    <view class="topbar">
      <view class="left" @click="back">
        上一步
      </view>
      设施信息
      <view class="right">
        <view class="nextBtn" :class="{'btnAct':canNext}" @click="next">下一步</view>
      </view>
    </view>

    <scroll-view scroll-y="true" class="content" scroll-with-animation="true">

      <view class="fac_item tbmargin60">
        <view class="title">服务</view>
        <checkbox-group @change="srv1" class="checkgroup">
          <label class="checkitem" v-for="item in serviceArr">
            <checkbox :value="item" :checked="false" color="#fd6f10" style="transform:scale(0.7)" />
            <text>{{item.text}}</text>
          </label>

        </checkbox-group>
      </view>
      <view class="fac_item tbmargin30">
        <view class="title">基础</view>
        <checkbox-group @change="bsc1" class="checkgroup">
          <label class="checkitem" v-for="item in basicArr">
            <checkbox :value="item" :checked="false" color="#fd6f10" style="transform:scale(0.7)" />
            <text>{{item.text}}</text>
          </label>

        </checkbox-group>
      </view>
      <view class="fac_item tbmargin30">
        <view class="title">卫浴</view>
        <checkbox-group @change="br1" class="checkgroup">
          <label class="checkitem" v-for="item in bathroomArr">
            <checkbox :value="item" :checked="false" color="#fd6f10" style="transform:scale(0.7)" />
            <text>{{item.text}}</text>
          </label>
          <i></i>
        </checkbox-group>
      </view>
      <view class="fac_item tbmargin30">
        <view class="title">厨房</view>
        <checkbox-group @change="ktc1" class="checkgroup">
          <label class="checkitem" v-for="item in kitchenArr">
            <checkbox :value="item" :checked="false" color="#fd6f10" style="transform:scale(0.7)" />
            <text>{{item.text}}</text>
          </label>
          <i></i>
        </checkbox-group>
      </view>
      <view class="fac_item tbmargin30">
        <view class="title">周边</view>
        <checkbox-group @change="srd1" class="checkgroup">
          <label class="checkitem" v-for="item in surroundArr">
            <checkbox :value="item" :checked="false" color="#fd6f10" style="transform:scale(0.7)" />
            <text>{{item.text}}</text>
          </label>
          <i></i>
        </checkbox-group>
      </view>
      <view class="fac_item tbmargin30">
        <view class="title">安全</view>
        <checkbox-group @change="sfty1" class="checkgroup">
          <label class="checkitem" v-for="item in safetyArr">
            <checkbox :value="item" :checked="false" color="#fd6f10" style="transform:scale(0.7)" />
            <text>{{item.text}}</text>
          </label>
          <i></i>
        </checkbox-group>
      </view>
      <view class="fac_item tbmargin30">
        <view class="title">娱乐</view>
        <checkbox-group @change="ettm1" class="checkgroup">
          <label class="checkitem" v-for="item in entertainmentArr">
            <checkbox :value="item" :checked="false" color="#fd6f10" style="transform:scale(0.7)" />
            <text>{{item.text}}</text>
          </label>
          <i></i>
        </checkbox-group>
      </view>
      <view class="fac_item tbmargin30">
        <view class="title">休闲</view>
        <checkbox-group @change="ls1" class="checkgroup">
          <label class="checkitem" v-for="item in leisureArr">
            <checkbox :value="item" :checked="false" color="#fd6f10" style="transform:scale(0.7)" />
            <text>{{item.text}}</text>
          </label>
          <i></i>
        </checkbox-group>
      </view>

      <view class="fac_item tbmargin30">
        <view class="title">儿童</view>
        <checkbox-group @change="chld1" class="checkgroup">
          <label class="checkitem" v-for="item in childrenArr">
            <checkbox :value="item" :checked="false" color="#fd6f10" style="transform:scale(0.7)" />
            <text>{{item.text}}</text>
          </label>
          <i></i>
        </checkbox-group>
      </view>
    </scroll-view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      houseInfo: {
				facilities:{}
			},
      serviceArr: [
        { index: 0, text: '免费停车位' },
        { index: 1, text: '付费停车位' },
        { index: 2, text: '行李寄存' },
        { index: 3, text: '前台接待' },
        { index: 4, text: '管家式服务' },
        { index: 5, text: '团建会议' }
      ],
      basicArr: [
        { index: 0, text: '无线网络' },
        { index: 1, text: '电梯' },
        { index: 2, text: '落地窗' },
        { index: 3, text: '空调' },
        { index: 4, text: '暖气' },
        { index: 5, text: '晾衣架' },
        { index: 6, text: '电热水壶' },
        { index: 7, text: '沙发' },
        { index: 8, text: '电视' },
        { index: 9, text: '冰箱' },
        { index: 10, text: '洗衣机' },
        { index: 11, text: '空气净化器' },
        { index: 12, text: '加湿器' },
        { index: 13, text: '烘干机' },
        { index: 14, text: '净水器' },
        { index: 15, text: '免费瓶装水' }
      ],
      bathroomArr: [
        { index: 0, text: '热水' },
        { index: 1, text: '独立卫浴' },
        { index: 2, text: '电吹风' },
        { index: 3, text: '洗浴用品' },
        { index: 4, text: '牙具' },
        { index: 5, text: '浴巾' },
        { index: 6, text: '毛巾' },
        { index: 7, text: '干湿分离' }
      ],
      kitchenArr: [
        { index: 0, text: '微波炉' },
        { index: 1, text: '餐具' },
        { index: 2, text: '刀具菜板' },
        { index: 3, text: '烹饪锅具' },
        { index: 4, text: '电磁炉' },
        { index: 5, text: '燃气灶' },
        { index: 6, text: '洗涤用品' },
        { index: 7, text: '饮水机' },
        { index: 8, text: '餐桌' }
      ],
      surroundArr: [
        { index: 0, text: '超市' },
        { index: 1, text: '便利店' },
        { index: 2, text: '餐厅' },
        { index: 3, text: '药店' },
        { index: 4, text: '公园' },
        { index: 5, text: '儿童乐园' },
        { index: 6, text: '充电桩' }
      ],
      safetyArr: [
        { index: 0, text: '急救包' },
        { index: 1, text: '智能门锁' },
        { index: 2, text: '门禁卡' },
        { index: 3, text: '可视对讲' },
        { index: 4, text: '保安' },
        { index: 5, text: '火灾警报器' },
        { index: 6, text: '灭火器' }
      ],
      entertainmentArr: [
        { index: 0, text: '投影设备' },
        { index: 1, text: '读书品茶' }
      ],
      leisureArr: [
        { index: 0, text: '落地窗' },
        { index: 1, text: '玻璃房' }
      ],
      childrenArr: [
        { index: 0, text: '儿童餐椅' },
        { index: 1, text: '防护设备' },
        { index: 2, text: '桌角防护' }
      ],
      srv: [],
      bsc: [],
      br: [],
      ktc: [],
      srd: [],
      sfty: [],
      ettm: [],
      ls: [],
      chld: []
    }
  },
  methods: {
    next() {
      if (this.canNext) {
        this.houseInfo.facilities.service = this.handleArr(6, this.srv)
        this.houseInfo.facilities.basic = this.handleArr(16, this.bsc)
        this.houseInfo.facilities.bathroom = this.handleArr(8, this.br)
        this.houseInfo.facilities.kitchen = this.handleArr(9, this.ktc)
        this.houseInfo.facilities.surrounding = this.handleArr(7, this.srd)
        this.houseInfo.facilities.safety = this.handleArr(7, this.sfty)
        this.houseInfo.facilities.entertainment = this.handleArr(2, this.ettm)
        this.houseInfo.facilities.leisure = this.handleArr(2, this.ls)
        this.houseInfo.facilities.children = this.handleArr(3, this.chld)
				const info=uni.getStorageSync('houseInfo')
				info.facilities=this.houseInfo.facilities
        uni.setStorageSync('houseInfo', info)
        // 跳转到下一页
				uni.navigateTo({
					 url: '/pages/upload/upload_feature/upload_feature'})
     }
    },
    handleArr(length, arr) {
      const zeroArray = Array(length).fill(0)
      arr.forEach(element => {
        zeroArray[element.index] = 1
      })

      return zeroArray.join('')
    },
    srv1(e) {

      this.srv = e.detail.value
    },
    bsc1(e) {
      this.bsc = e.detail.value
    },
    br1(e) {
      this.br = e.detail.value
    },
    ktc1(e) {
      this.ktc = e.detail.value
    },
    srd1(e) {
      this.srd = e.detail.value
    },
    sfty1(e) {
      this.sfty = e.detail.value
    },
    ettm1(e) {
      this.ettm = e.detail.value
    },
    ls1(e) {
      this.ls = e.detail.value
    },
    chld1(e) {
      this.chld = e.detail.value
    },
		back(){
			uni.navigateBack({
				 delta: 1
			});
		}
  },
  computed: {
    canNext() {
      return true
    }
  },
  
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
  .limitWidth {
    width: 200rpx !important;
  }
  .fac_item {
    display: flex;
    background-color: rgb(252, 252, 252);
    border-radius: 10rpx;
    padding: 20rpx 8rpx;
    .title {
      text-align: center;
      width: 80rpx;
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
}
</style>
