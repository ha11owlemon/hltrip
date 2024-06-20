<template>
  <view>
    <view class="statusbar"></view>
    <view class="topbar">
      <view class="left" @click="nvback">
        <image class="topbar-icon leftIco" src="../../static/image/icon/back_balck.png" mode="aspectFit" />
      </view>
      房源相册
      <view class="right">
        <image class="topbar-icon rightIco" src="../../static/image/icon/message_white.png" mode="aspectFit" />
        <!-- <image class="topbar-icon rightIco" src="../../static/image/icon/message_black.png" mode="aspectFit" /> -->
      </view>
    </view>

    <view class="swTop" v-if="pic.length!=0">
      <view v-for="(item,index) in pic" :key="index" class="topItem" @click="changeIndex(index)" :class="{'itemAct':current==index}">{{item.group}}</view>
    </view>
    <view class="swContent">
      <view class="contentview" v-if="pic.length!=0">
        <image class="pic" :src="item" mode="scaleToFill" v-for="(item,i) in pic[current].picList" :key="i" @click="preview(item)" />
      </view>
      <q-previewImage v-if="pic.length!=0" ref="previewImage" :urls="pic[current].picList"></q-previewImage>
      <view class="facbottom"></view>
    </view>
  </view>
</template>

<script>

export default {
  data() {
    return {
      current: 0,
      pic: []
    }
  },
		onBackPress() {
		    try {
      this.$nextTick(() => {
        plus.navigator.setStatusBarStyle('light')
      })
    } catch (error) {
      console.log(err)
    }
  },
  methods: {
    changeIndex(i) {
      this.current = i
    },
    nvback() {
      try {
        this.$nextTick(() => {
          plus.navigator.setStatusBarStyle('light')
        })
      } catch (error) {
        console.log(err)
      }
      uni.navigateBack({
        delta: 1
      })
    },
    preview(url) {
      this.$refs.previewImage.open(url)
    }
  },
  onLoad() {
    const livdingRoom = {
      group: '卧室',
      picList: []
    }
    const lobby = {
      group: '客厅',
      picList: []
    }
    const bashroom = {
      group: '卫生间',
      picList: []
    }
    const kitchen = {
      group: '厨房',
      picList: []
    }
    const other = {
      group: '其他',
      picList: []
    }
    uni.$on(
      'sendPicList',
      function (data) {
        data.forEach(element => {
          if (element.imagetype == '卧室') {
            livdingRoom.picList.push(element.url)
          } else if (element.imagetype == '客厅') {
            lobby.picList.push(element.url)
          } else if (element.imagetype == '卫生间') {
            bashroom.picList.push(element.url)
          } else if (element.imagetype == '厨房') {
            kitchen.picList.push(element.url)
          } else if (element.imagetype == '其他') {
            other.picList.push(element.url)
          }
        })
        this.pic.push(livdingRoom)
        this.pic.push(lobby)
        this.pic.push(bashroom)
        this.pic.push(kitchen)
        this.pic.push(other)
      }.bind(this)
    )
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
  margin-top: var(--status-bar-height);
  display: flex;
  justify-content: space-between;
  align-items: center;
  .topbar-icon {
    align-items: center;
    vertical-align: bottom;
    width: 40rpx;
    height: 40rpx;
  }

  .leftIco {
    margin-left: 40rpx;
  }

  .rightIco {
    margin-right: 40rpx;
  }
}

.itemAct {
  color: #fd6f10;
  position: relative;
  &::before {
    content: '';
    position: absolute; /* 相对于父元素定位 */
    left: 50%;
    transform: translateX(-50%);
    top: 50rpx;
    height: 3rpx;
    width: 50rpx;
    border-radius: 999px 999px 0 0;
    background: #fd6f10;
  }
}
.swTop {
  display: flex;
  width: 500rpx;
  margin: auto;
  margin-top: 30rpx;
  .topItem {
    height: 50rpx;
    line-height: 50rpx;
    font-size: 28rpx;
    font-weight: bold;
    margin: 0 14rpx;
  }

  .itemAct {
    color: #fd6f10;
    position: relative;
    &::before {
      content: '';
      position: absolute; /* 相对于父元素定位 */
      left: 50%;
      transform: translateX(-50%);
      top: 50rpx;
      height: 3rpx;
      width: 50rpx;
      border-radius: 999px 999px 0 0;
      background: #fd6f10;
    }
  }
}
.swContent {
  margin-top: 20rpx;
  width: 100vw;
  height: 84vh;
  overflow-y: auto;

  .contentview {
    width: 90%;
    margin: auto;
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    .pic {
      width: 48%;
      height: 220rpx;
      background-color: #fff;
      border-radius: 20rpx;
      margin-top: 20rpx;
    }
  }

  .facbottom {
    height: 200rpx;
  }
}
</style>
