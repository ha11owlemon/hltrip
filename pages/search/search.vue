<template>
  <view>
    <view class="topbar"></view>
    <view class="city-container">
      <view class="searchHeader">
        <view class="left">
          <image style="width: 40rpx; height: 40rpx;" class="searchIcon" src="../../static/image/icon/search.png" mode="aspectFit" />
          <input v-model="searchText" class="searchInput" type="text" placeholder="城市/区域/位置" confirm-type="search" @input="hanldeInput">
          <image @click="cleanText" style="width: 32rpx; height: 32rpx;margin-right:14rpx;margin-top:24rpx" class="searchIcon" src="../../static/image/icon/fail.png" mode="aspectFit" />
        </view>
        <view class="right" @click="nvBack">取消</view>
      </view>

      <view class="cities" v-if="!searchText">
        <view class=location hover-class="locationHover" hover-stay-time="900" @click="getMylocation">
          <view class="title">当前位置</view>
          <view class=address>
            <image class="icon" src="../../static/image/icon/location2.png" mode="aspectFit" />
            {{street}}
          </view>
        </view>

        <view class="history" v-if="historyList.length!=0" id="history">
          <view class="titleWrapper">
            <view class="title">历史记录</view>
            <view class="clear" @click="clearHistory">清空</view>
          </view>
          <view class="historyList">
            <view class="historyListItem " v-for="(item,index) in historyList" hover-class="locationHover" hover-stay-time="900" @click="sendData(item)">
              <text v-if="item.cityName" class="textOverflow">{{item.cityName}}</text>
              <text v-if="item.name" class="textOverflow">{{item.name}}</text>
            </view>
          </view>
        </view>

        <view class="hotCities">
          <view class="title">景点</view>
          <view class="hotCitiesList">
            <view class="hotCityItem" v-for="(item,index) in viewpoint" hover-class="locationHover" hover-stay-time="900" @click="sendData(item)">{{item.name}}</view>
          </view>
        </view>

        <view class="hotCities">
          <view class="title">商圈</view>
          <view class="hotCitiesList">
            <view class="hotCityItem" v-for="(item,index) in businessDistrict" hover-class="locationHover" hover-stay-time="900" @click="sendData(item)">{{item.name}}</view>
          </view>
        </view>

        <view class="scrollBottom"></view>
      </view>

      <view class="searchTip-container" v-if="searchText">
        <view v-if="isTips" class="noRecord">暂无记录</view>
        <view class="tips-list">
          <view class="tip-item" v-for="(item,index) in tips" :key="index" @click="sendData(item)">
            <view class="tipName" v-html="highLight(item.name)"></view>
            <view class="district">{{item.district}}</view>

          </view>
        </view>
        <view class="scrollBottom"></view>
      </view>
    </view>

    <image class="loading" v-if="isLoading" src="../../static/image/icon/loading.gif" mode="aspectFit" />
  </view>
</template>

<script>
import data from '../../static/data/allCity.json'
import debounce from 'lodash.debounce'

export default {
  data() {
    return {
      searchText: '',
      street: '',
      historyList: [],
      hotCities: [],
      cities: [],
      letterGroup: [],
      latitude: 0,
      longitude: 0,
      tips: [],
      isLoading: false,
      isTips: false,
			viewpoint:[],
			businessDistrict:[]
    }
  },
  methods: {
    nvBack() {
      uni.navigateBack({
        delta: 2
      })
    },
    getMylocation() {
      uni.getLocation({
        type: 'gcj02',

        geocode: true,
        success: function (res) {
          console.log(res)
          this.latitude = res.latitude
          this.longitude = res.longitude
          this.location = `${this.longitude},${this.latitude}`
          uni.setStorageSync('street', res.address.street)
        }.bind(this),
        fail(err) {
          console.log('fail')
          console.log(err)
        },
        complete: function () {
          this.isLocating = false
        }.bind(this)
      })
    },
    sendData(item) {
      this.saveHistory(item)
			uni.setStorageSync("searchText",item.name)
			uni.setStorageSync("location",item.location)
      uni.navigateTo({
				 url: '/pages/searchDetail/searchDetail'
			});
    },
    saveHistory(item) {
      this.historyList = this.insertOrUpdateCity(this.historyList, item)
      uni.setStorageSync('searchHistory2', this.historyList)
    },
    clearHistory() {
      this.historyList = []
      uni.removeStorageSync('searchHistory')
    },
    insertOrUpdateCity(array, cityObject) {
      // 查找数组中是否存在相同 cityId 的元素
      const existingIndex = array.findIndex(item => item.id === cityObject.id)

      if (existingIndex !== -1) {
        // 如果已经存在相同 cityId 的元素，将其移动到数组最前面
        const existingCity = array.splice(existingIndex, 1)[0]
        array.unshift(existingCity)
      } else {
        // 如果不存在相同 cityId 的元素，直接插入到数组最前面
        array.unshift(cityObject)
      }

      // 返回更新后的数组
      return array
    },
    hanldeInput: debounce(function () {
      this.isTips = false
      const location = uni.getStorageSync('location')
      this.tips = []
      this.isLoading = true
      uni.request({
        url: 'https://restapi.amap.com/v3/assistant/inputtips', //仅为示例，并非真实接口地址。
        data: {
          key: 'ca5638622884957be4cff8d31d00b1b0',
          location: location,
          keywords: this.searchText
        },
        success: function (res) {
          let arr = res.data.tips
          if (arr.length == 0) {
            this.isTips = true
          }
          arr.forEach((element, index) => {
            if (element.id.length == 0) {
              arr.splice(index, 1)
            }
          })
          this.tips = arr
          console.log(res)
        }.bind(this),
        fail: err => {
          console.log(err)
        },
        complete: function () {
          this.isLoading = false
        }.bind(this)
      })
    }, 300),
    highLight(name) {
      const regex = new RegExp(this.searchText, 'g')
      return name.replace(regex, "<span style='color: #ff7014;'>" + this.searchText + '</span>')
    },
    cleanText() {
      this.searchText = ''
    },
		getViewpoint(){
			uni.request({
				url:"https://restapi.amap.com/v3/place/around",
				data:{
					location:uni.getStorageSync("location"),
					types:110000,
					radius:30000,
					offset:12,
					page:1,
					extensions:"all",
					sortrule:"weight",
					key:"ca5638622884957be4cff8d31d00b1b0"
				},
				success:res=>{
					console.log(res.data);
					const pois=res.data.pois
					this.viewpoint=pois
				},
				fail:err=>{
					console.log(err);
				}
			})
		},
		getBusinessDistrict(){
			uni.request({
				url:"https://restapi.amap.com/v3/place/around",
				data:{
					location:uni.getStorageSync("location"),
					types:"061000",
					radius:50000,
					offset:12,
					page:1,
					extensions:"all",
					sortrule:"weight",
					key:"ca5638622884957be4cff8d31d00b1b0"
				},
				success:res=>{
					const pois=res.data.pois
					this.businessDistrict=pois
				},
				fail:err=>{
					console.log(err);
				}
			})
		}
  },
  onLoad() {
    this.street = uni.getStorageSync('street')
    if (this.street == '') {
      this.street = '获取位置失败，请重试'
    }
    const arr = uni.getStorageSync('searchHistory2')
    if (arr.length != 0) {
      this.historyList = arr
    }
		this.getViewpoint()
		this.getBusinessDistrict()
  }
}
</script>

<style lang="less">
.topbar {
  position: fixed;
  z-index: 999;
  width: 100%;
  top: 0;
  height: var(--status-bar-height);
  background-color: rgb(255, 255, 255);
}
.city-container {
  overflow: hidden;
  .searchHeader {
    padding: 0 40rpx;
    display: flex;
    height: 80rpx;
    justify-content: space-between;
    position: fixed;
    z-index: 999;
    width: 95%;
    top: var(--status-bar-height);
    left: 50%;
    background-color: #fff;
    transform: translate(-50%);
    .left {
      flex: 1;
      display: flex;
      border-radius: 8rpx;
      background-color: #f6f7fb;
      .searchIcon {
        margin-top: 20rpx;
        margin-left: 20rpx;
      }
      .searchInput {
        height: 80rpx;
        flex: 1;
        margin-left: 20rpx;
        font-weight: 900;
        line-height: 80rpx;
      }
    }
    .right {
      font-weight: 900;
      color: rgb(34, 34, 34);
      text-align: center;
      width: 120rpx;
      line-height: 80rpx;
    }
  }

  .cities {
    box-sizing: border-box;
    margin-top: 180rpx;
    width: 100vw;
    padding: 10rpx 34rpx;
    height: 90vh;
    scroll-margin-top: 200rpx;
    overflow-y: scroll;
    position: fixed;

    .title {
      font-weight: 900;
      color: #333;
    }

    .location {
      color: rgb(87, 87, 87);
      font-weight: 900;
      .address {
        margin-top: 10rpx;
        line-height: 36rpx;
        overflow: hidden;
      }
      .icon {
        width: 36rpx;
        height: 36rpx;
        vertical-align: bottom;
      }
    }

    .history {
      margin-top: 40rpx;
      .titleWrapper {
        display: flex;
        justify-content: space-between;
        width: 100%;
        .clear {
          color: rgb(160, 160, 160);
          font-size: 30rpx;
        }
      }

      .historyList {
        margin-top: 16rpx;
        display: flex;
        flex-wrap: wrap;
        width: 100%;
        i {
          width: 20%;
          padding: 15rpx 8rpx;
        }
        .historyListItem {
          margin-left: 20rpx;
          text-align: center;
          background-color: #f6f7fb;
          border-radius: 999rpx;
          font-weight: 900;
          color: #676769;
          padding: 8rpx 18rpx;
          margin-top: 15rpx;
          font-size: 28rpx;
          overflow: hidden;
          text-overflow: ellipsis;
          .textOverflow {
            width: 100%;
            white-space: nowrap;
          }
        }
      }
    }
    .hotCities {
      margin-top: 30rpx;
      .hotCitiesList {
        margin-top: 10rpx;
        display: flex;
        flex-wrap: wrap;
        width: 100%;
        .hotCityItem {
					margin-left: 20rpx;
          text-align: center;
          background-color: #f6f7fb;
          border-radius: 122rpx;
          font-weight: 900;
          color: #676769;
          padding: 8rpx 26rpx;
          margin-top: 24rpx;
          font-size: 26rpx;
          white-space: nowrap;
          text-overflow: ellipsis;
          overflow: hidden;
        }
      }
    }

    .citiesList {
      margin-top: 40rpx;
      margin-left: 30rpx;
      .groupLetter {
        margin-top: 30rpx;
        margin-bottom: 20rpx;
      }
      .cityName {
        width: 100%;
        margin-top: 10rpx;
        height: 90rpx;
        line-height: 90rpx;
        color: #676769;
        font-weight: 900;
        border-bottom: 1px solid rgb(245, 245, 245);
      }
    }
  }
}
.scrollBottom {
  width: 100%;
  height: 100rpx;
}

.sideBar {
  position: fixed;
  right: 0;
  top: 300rpx;
  width: 10%;
  text-align: center;
  color: #676769;
  font-weight: 900;
  font-size: 24rpx;
  .letter {
    a {
      text-decoration: none;
      color: inherit;
    }
    margin: 5rpx 0;
  }
}

.textHoverOrange {
  color: #ff7014;
}

.cityHover {
  background-color: rgb(230, 230, 230);
}
.locationHover {
  color: rgb(204, 204, 204) !important;
}

.searchTip-container {
  margin-top: 180rpx;
  width: 100%;
  padding: 10rpx 34rpx;
  height: 90vh;
  scroll-margin-top: 200rpx;
  overflow-y: scroll;
  position: fixed;
  .tips-list {
    width: 100%;
    .tip-item {
      font-weight: 900;
      padding: 18rpx 10rpx;
      border-bottom: 2px solid #fafafa;
      .tipName {
        color: #333;
      }

      .district {
        color: #9c9c9c;
        font-size: 22rpx;
        margin-top: 4rpx;
      }
    }
  }
}

.loading {
  width: 50rpx;
  position: fixed;
  top: 0rpx;
  left: 50%;
  transform: translateX(-50%);
}

.noRecord {
  font-weight: 900;
  position: fixed;
  top: 170rpx;
  height: 45rpx;
  width: 100%;
  line-height: 45rpx;
  color: #ff7014;
}
</style>
