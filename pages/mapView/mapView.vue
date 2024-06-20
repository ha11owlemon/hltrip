<template>
  <view>
    <view class="topbar">
      <view class="left" @click="nvback">
        <image class="topbar-icon leftIco" src="../../static/image/icon/back_balck.png" mode="aspectFit" />
      </view>
      周边
      <view class="right">
        <image class="topbar-icon rightIco" src="../../static/image/icon/message_white.png" mode="aspectFit" />
        <!-- <image class="topbar-icon rightIco" src="../../static/image/icon/message_black.png" mode="aspectFit" /> -->
      </view>
    </view>
    <view class="mapview" >
      <map id="map" style="width: 100vw; height: 85vh;" :latitude="latitude" :longitude="longitude" :markers="covers" scale="18">
      </map>

      <view class="ctrlWrapper">
        <view class="clcontrols" @click="toMyPos">
          <image class="ico" src="../../static/image/icon/currentLocation.png" mode="aspectFit" />

        </view>

        <view class="tlcontrols" @click="toTarget">
          <image class="ico" src="../../static/image/icon/location2.png" mode="aspectFit" />
        </view>
        <view class="tlcontrols" @click="navigate">
          <image class="ico" src="../../static/image/icon/navigator.png" mode="aspectFit" />
        </view>
      </view>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      location: '',
      latitude: 0,
      longitude: 0,
      covers: [
        {
          latitude: 0,
          longitude: 0,
          iconPath: '../../static/image/icon/3x/bubble_2.png',
        },
        {
          latitude: 0,
          longitude: 0,
          iconPath: '../../static/image/icon/2x/myPos.png'
        }
      ]
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
    toMyPos() {
			    uni.getLocation({
      type: 'gcj02', //返回可以用于uni.openLocation的经纬度
      success: function (res) {
        this.covers[1].latitude = res.latitude
        this.covers[1].longitude = res.longitude
				console.log(this);
      }.bind(this)
    })
      this.latitude = this.covers[1].latitude
      this.longitude = this.covers[1].longitude
    },
    toTarget() {
      this.latitude = this.covers[0].latitude
      this.longitude = this.covers[0].longitude
    },
		navigate(){
			uni.openLocation({
				latitude:this.covers[0].latitude,
				longitude:this.covers[0].longitude

			})
		},
		nvback(){
			    try {
      this.$nextTick(() => {
        plus.navigator.setStatusBarStyle('light')
      })
    } catch (error) {
      console.log(err)
    }
			uni.navigateBack({
				 delta: 1
			});
		}
  },
  onLoad: function (option) {
    this.location = option.location
    const locationArr = this.location.split(',')

    console.log(locationArr)
    this.covers[0].longitude = parseFloat(locationArr[0])
    this.covers[0].latitude = parseFloat(locationArr[1])
		this.longitude= parseFloat(locationArr[0])
		this.latitude=parseFloat(locationArr[1])
    uni.getLocation({
      type: 'gcj02', //返回可以用于uni.openLocation的经纬度
      success: function (res) {
        this.covers[1].latitude = res.latitude
        this.covers[1].longitude = res.longitude
				console.log(this);
      }.bind(this)
    })
    // const mapContext = uni.createMapContext("map",this)
    // mapContext.initMarkerCluster()
    // mapContext.addMarkers({
    // 	markers:[        {
    //       latitude: 26.182708,
    //       longitude: 119.28427,
    //       iconPath: '../../static/image/icon/location.png',
    //       content: '2312'
    //     },]
    // })
  }
}
</script>

<style lang="less">
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
.mapview {
  width: 100vw;
  height: 100vh;
  overflow: hidden;
}

.ctrlWrapper {
  display: flex;
  width: 70vw;
  margin: auto;
  justify-content: space-between;
  .clcontrols,
  .tlcontrols {
    text-align: center;
    width: 60rpx;
    height: 60rpx;
    border-radius: 10rpx;
    margin-top: 20rpx;
    display: flex;
    justify-content: space-around;
    align-items: center;
    display: flex;
    justify-content: left;
  }
  .ico {
    width: 45rpx;
    height: 45rpx;
  }
}
</style>
