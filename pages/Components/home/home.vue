<template>
  <view>

    <view class="searchBar" :class="{ 'fixed': isFixed }">
      <view class="topbar"></view>
      <view class="fix-searchbar">
        <view class="wrapper">
          <view class="left">
            <view class="location" @click="selectCity">{{locationText}}</view>
            <view class="checkTime">
              <view class="top">
                <text class="desc">住</text>
                <text class="date">{{startTime.month}}-{{startTime.date}}</text>
              </view>
              <div class="bottom">
                <text class="desc">离</text>
                <text class="date">{{endTime.month}}-{{endTime.date}}</text>
              </div>
            </view>
            <view class="input" @click="toSearchDetail">位置/民宿/关键字</view>

            <view class="searchBtn" @click="toSearchDetail">搜索</view>
          </view>
          <view class="right" @click="backToTop">
            <image class="iconpic" src="../../../static/image/icon/upToTop.png" />
            <view class="desc">回顶部</view>
          </view>
        </view>
      </view>
    </view>
    <uni-calendar class="calendar" ref="calendar" :insert="false" :range="true" :startDate="`${currentTime.year}-${currentTime.month}-${currentTime.date}`" @confirm="confirm" :clearDate="false" />
    <scroll-view scroll-with-animation="true" scroll-y="true" class="home" @scrolltolower="getMoreHouse" @scroll="handleScroll" :scroll-into-view="toView">

      <view class="homeHeader" id="top">
        <!-- 轮播图 -->
        <swiper class="swiper" circular :autoplay="true" :interval="5000" :duration="600" :circular="true">
          <swiper-item>
            <view class="swiper-item"><img src="https://pic.tujia.com/upload/resourcespic/day_240419/thumb/202404191945009910_750_250.jpeg_.webp" mode="aspectFit" alt="" />
              <img class="filterImg" src="https://pic.tujia.com/upload/resourcespic/day_240419/thumb/202404191945009910_750_250.jpeg_.webp" alt="" />
            </view>

          </swiper-item>
        </swiper>

        <!-- 渐变遮罩层 -->
        <view class="mask"></view>

        <!-- 选择租房信息的头部 -->
        <view class="rentCondition">
          <!-- 顶部点击切换国内外的包裹容器 -->

          <view class="rentCondition-content">
            <!-- 内容 -->
            <!-- 当前位置 -->
            <view class="current-location">
              <view class="current-location-left" hover-class="texthover" hover-stay-time="900" @click="selectCity">{{locationText}}</view>
              <view class="current-location-right">
                <view class="current-location-right-wrapper" @click="getMyLocation">
                  <image v-if="!isLocating" style="width: 26px; height: 26px;" src="../../../static/image/icon/currentLocation.png" alt="" />
                  <image v-else style="width: 26px; height: 26px;" src="../../../static/image/icon/loading.gif" alt="" />
                  <view class="locationDesc">
                    <text v-if="!isLocating">我的附近</text>
                    <text v-else>定位中</text>
                  </view>
                </view>
              </view>
            </view>

            <!-- 入住时间 -->
            <view class="checkInTime">
              <view class="checkIn" @click="open">
                <view class="checkIn-Desc">周{{startTime.arr[startTime.day]}}入住</view>
                <view class="checkIn-Date" hover-class="texthover" hover-stay-time="500">{{startTime.month}}月{{startTime.date}}日</view>
              </view>
              <view class="stayTime">{{stayRange}}晚</view>
              <view class="checkOut" @click="open">
                <view class="checkIn-Desc">周{{endTime.arr[endTime.day]}}离店</view>
                <view class="checkIn-Date" hover-class="texthover" hover-stay-time="500">{{endTime.month}}月{{endTime.date}}日</view>
              </view>
              <view class="check-condition" @click="openPopup">
                <view class="checkIn-Desc">可住条件</view>
                <view class="checkIn-Date" hover-class="texthover" hover-stay-time="400"> <text v-if="conditionText==''"> 选择人/床/居</text>
                  <text v-else>{{conditionText}}</text>
                </view>
              </view>
            </view>
            <!-- 搜索酒店 -->
            <view class="searchHotel">
              <view class="placeholder" @click="toSearch">位置/民宿名/关键字</view>
              <!-- <view class="clearIcon">
							<image class="clearIcon" src="../../../static/image/icon/clear.png" mode="" />
						</view> -->
            </view>

            <!-- 推荐小tag -->
            <view class="recommendContainer">
              <scroll-view scroll-x="true" class="recommendWrapper">
                <view hover-class="recHover" hover-stay-time="600" class="recomendItem" v-for="item in recmmend" :key="item.id" @click="toSearch2(item)">{{item.name}}</view>
                <view class="occp"></view>
              </scroll-view>
              <view class="itemCover"></view>
            </view>

            <!-- 搜索按钮 -->
            <view class="searchButton" @click="toSearchDetail">开始搜索</view>
          </view>
        </view>

      </view>

      <view class="content">
        <view class="recomendDesc">
          <text>推荐</text>
          <!-- <text>筛选</text> -->
        </view>
        <view class="contentWrapper">
          <view class="hotelItem" v-if="!showEmpty" v-for="(item,index) in hotelCover" :key="index">
            <view class="picWrapper">
              <image class="pic" @click="nvtodt(item.overview.houseid)" :src="item.overview.coverurl" mode="aspectFill" />
              <view class="likewrap" @click="likeHotel(item)">
                <image class="like" src="../../../static/image/icon/like.png" v-if="!item.islike" />
                <image class="like" src="../../../static/image/icon/like-active.png" v-if="item.islike" />
              </view>

              <div class="hotelDesc">
                <image class="icon" src="../../../static/image/icon/location.png" mode="" />
                <view class="desc">
                  {{item.overview.roomcount}}居 | {{item.locationInfo.city}}·{{item.locationInfo.county}}
                </view>
              </div>
            </view>

            <view class="textWrapp" @click="nvtodt(item.overview.houseid)">
              <view class="hotelName">{{item.overview.housename}}</view>
              <text class="rmb">￥</text>
              <text class="currentPrice">{{item.overview.discountprice}}</text>
              <del class="orgPrice">￥{{item.overview.originalprice}}</del>
            </view>

          </view>

        </view>
        <view class="nomore" v-if="showNoMore">-没有更多了-</view>

        <view class="marginblock"></view>
      </view>
      <view class="empty" v-if="showEmpty">
        <image src="../../../static/image/empty_bg.png" mode="aspectFit" />
        <view class="desc">暂时没有内容</view>
      </view>
      <view class="popup-wrapper">
        <!-- 普通弹窗 -->
        <uni-popup ref="popup" background-color="#fff">
          <view class="popup-content">
            <view class="title">
              入住条件
            </view>

            <view class="peopleCount-wrapper">
              <view class="title">宜居人数</view>
              <view class="peopleCount">
                <view class="pCount">
                  <view class="pCountItem" v-for="item in 10" @click="selectPeople(item)" :style="{backgroundColor: selectedPeople === item ? '#fe7815' : '#f6f7fb', color: selectedPeople === item ? 'white' : '#333'}">{{item}}人</view>
                  <view class="pCountItem" @click="selectPeople('10+')" :style="{backgroundColor: selectedPeople === '10+' ? '#fe7815' : '#f6f7fb', color: selectedPeople === '10+' ? 'white' : '#333'}">10人+</view>
                  <i></i>
                </view>

              </view>
            </view>

            <view class="peopleCount-wrapper bedCount">
              <view class="title">床铺数量</view>
              <view class="peopleCount">
                <view class="pCount">
                  <view class="pCountItem" v-for="item in 10" @click="selectBed(item)" :style="{backgroundColor: selectedBed === item ? '#fe7815' : '#f6f7fb', color: selectedBed === item ? 'white' : '#333'}">{{item}}张</view>
                  <view class="pCountItem" @click="selectBed('10+')" :style="{backgroundColor: selectedBed === '10+' ? '#fe7815' : '#f6f7fb', color: selectedBed ==='10+' ? 'white' : '#333'}">10张+</view>
                  <i></i>
                </view>

              </view>
            </view>

            <view class="button-group">
              <view class="cancle-btn btn" @click="clearCondition">清空</view>
              <view class="confirm-btn btn" @click="confirmCondition">确定</view>
            </view>
          </view>
        </uni-popup>
      </view>
    </scroll-view>

  </view>

</template>


<script>
import API from '../../../static/data/API.js'
export default {
  data() {
    return {
      latitude: '0',
      longitude: '0',
      location: '0,0',
      recmmend: [],
      hotelCover: [],
      isFixed: false,
      scrollThreshold: 120,
      startTime: {},
      endTime: {},
      currentTime: {},
      stayRange: 1,
      actived: false,
      selectedPeople: -1,
      selectedBed: -1,
      conditionText: '',
      mapLoaded: false,
      text: '',
      showBtn: true,
      locationText: '我的附近',
      isLocating: false,
      data: null,
      showEmpty: false,
      page: 1,
      maxPage: 0,
      showNoMore: false,
      toView: '',
      isFirst: true
    }
  },
  methods: {
    toSearch2(item) {
      uni.setStorageSync('location', item.location)
      uni.setStorageSync('searchText', item.name)
      uni.navigateTo({
        url: '/pages/searchDetail/searchDetail'
      })
    },
    handleScroll(e) {
      if (e.detail.scrollTop > this.scrollThreshold) {
        if (this.toView != '') {
          this.toView = ''
        }

        this.isFixed = true
      } else {
        this.isFixed = false
      }
    },
    // 点击切换滑块选项卡
    switchToRight() {
      this.sildeDistance = '50%'
    },
    switchToLeft() {
      this.sildeDistance = '0rpx'
    },
    nvtodt(houseid) {
      uni.navigateTo({
        url: `/pages/hotelDetail/hotelDetail?houseid=${houseid}`
      })
    },
    likeHotel(item) {
      console.log('likehouse')
      item.islike = !item.islike
      uni.request({
        url: `${API.BASE_URL}/favorHouse`,
        data: {
          houseid: item.overview.houseid,
          userid: uni.getStorageSync('userId')
        }
      })
    },
    backToTop() {
      this.toView = 'top'
    },
    open() {
      this.$refs.calendar.open()
    },
    confirm(e) {
      console.log(e)
      if (e.range.data.length >= 1) {
        this.stayRange = e.range.data.length - 1
      }

      const dateArr = this.compareDates(e.range.before, e.range.after)
      console.log(dateArr[1])
      this.startTime = this.getTime(dateArr[0])
      this.endTime = this.getTime(dateArr[1])

      uni.setStorageSync('startTime', this.startTime)
      uni.setStorageSync('endTime', this.endTime)
      uni.setStorageSync('stayRange', this.stayRange)
    },
    compareDates(dateStr1, dateStr2) {
      // 解析日期字符串为日期对象
      var date1 = new Date(dateStr1)
      var date2 = new Date(dateStr2)

      // 比较日期对象
      if (date1 < date2) {
        return [date1, date2]
      } else if (date1 > date2) {
        return [date2, date1]
      } else {
        return dateStr1 + ' 和 ' + dateStr2 + ' 相同'
      }
    },
    getTime(dateObj) {
      const year = dateObj.getFullYear()
      const month = dateObj.getMonth() + 1
      const date = dateObj.getDate()
      const day = dateObj.getDay()
      return {
        year,
        month: month.toString().padStart(2, '0'),
        date: date.toString().padStart(2, '0'),
        day,
        arr: ['日', '一', '二', '三', '四', '五', '六'],
        timestamp: dateObj
      }
    },
    openPopup() {
      // open 方法传入参数 等同在 uni-popup 组件上绑定 type属性
      this.$refs.popup.open('bottom')
    },
    selectPeople(item) {
      this.selectedPeople = item
    },
    selectBed(item) {
      this.selectedBed = item
    },
    confirmCondition() {
      if (this.selectedPeople != -1 && this.selectedBed != -1) {
        this.conditionText = `${this.selectedPeople}人,${this.selectedBed}床`
      } else if (this.selectedBed != -1) {
        this.conditionText = `${this.selectedBed}床`
      } else if (this.selectedPeople != -1) {
        this.conditionText = `${this.selectedPeople}人`
      } else {
        this.conditionText = ''
      }
      this.$refs.popup.close()
    },
    clearCondition() {
      this.selectedPeople = -1
      this.selectedBed = -1
      this.conditionText = ''
    },
    getMyLocation() {
      this.isLocating = true
      this.locationText = '我的附近'
      uni.getLocation({
        type: 'gcj02',

        geocode: true,
        success: function (function (res) {
          console.log(res)
          this.latitude = res.latitude
          this.longitude = res.longitude
          this.location = `${this.longitude},${this.latitude}`
          uni.setStorageSync('street', res.address.street)
          uni.setStorageSync('location', this.location)
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
    initLocation() {
      uni.getLocation({
        type: 'gcj02',

        geocode: true,
        success: function (res) {
          console.log(res)
          this.latitude = res.latitude
          this.longitude = res.longitude
          this.location = `${this.longitude},${this.latitude}`
          uni.setStorageSync('street', res.address.street)
          uni.setStorageSync('location', this.location)
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
    handleLocationChange() {
      console.log('datachange')
      this.page = 1
      this.hotelCover = []
      this.getRecommendData()
      this.page += 1
      this.getNearBy()
    },
    getNearBy() {
      const location = uni.getStorageSync('location')
      uni.request({
        url: 'https://restapi.amap.com/v3/place/around', //仅为示例，并非真实接口地址。
        data: {
          key: 'ca5638622884957be4cff8d31d00b1b0',  
          location: location,
          types: '110000|060400|080300',
          radius: 50000,
          sortrule: 'weight',
          offset: 10
        },
        success: res => {
          const responseData = res.data
          if (responseData.info == 'OK') {
            this.recmmend = responseData.pois
          } else {
            console.log(responseData)
          }
        }
      })
    },
    selectCity() {
      uni.navigateTo({
        url: '/pages/selectCity/selectCity'
      })
    },
    getRecommendData() {
      const locationArr = this.location.split(',')

      uni.request({
        url: `${API.BASE_URL}/getRecommendHouses`,
        data: {
          longitude: locationArr[0],
          latitude: locationArr[1],
          userid: uni.getStorageSync('userId'),
          page: this.page
        },
        success: res => {
          const sdata = res.data.data
          if (res.data.requestStatus == '300') {
            this.showEmpty = true
            return false
          }
          this.showEmpty = false
          this.maxPage = Math.ceil(sdata.total / 10)
          if (this.hotelCover.length == 0) {
            this.hotelCover = res.data.data.houseInfo.sort((element1, element2) => {
              return element2.recommendValue - element1.recommendValue
            })
          } else {
            this.hotelCover = [
              ...this.hotelCover,
              ...res.data.data.houseInfo.sort((element1, element2) => {
                return element2.recommendValue - element1.recommendValue
              })
            ]
          }
        },
        fail: err => {
          console.log(err)
        }
      })
    },
    getMoreHouse() {
      if (this.page <= this.maxPage) {
        this.getRecommendData()
        this.page += 1
      } else {
        this.showNoMore = true
      }
    },
    toSearchDetail() {
      uni.removeStorageSync('searchText')
      uni.navigateTo({ url: '/pages/searchDetail/searchDetail' })
    },
    toSearch() {
      uni.navigateTo({ url: '/pages/search/search' })
    }
  },
  onPageScroll(event) {
    console.log('sroll')
    if (event.scrollTop > this.scrollThreshold) {
      this.isFixed = true
    } else {
      this.isFixed = false
    }
  },
  onLoad() {
    uni.request({
      url: `${API.BASE_URL}/verifyLogin`, //仅为示例，并非真实接口地址。
      data: {
        userId: uni.getStorageSync('userId'),
        token: uni.getStorageSync('token')
      },
      method: 'POST',
      success: res => {
        const data = res.data
        if (data.requestStatus == '200') {
        } else {
          uni.removeStorageSync('token')
          uni.removeStorageSync('phoneNumber')
          uni.removeStorageSync('userId')
          uni.redirectTo({
            url: '/pages/login/login'
          })
        }
      }
    })

    this.currentTime = this.getTime(new Date())
    const storageInfo = uni.getStorageInfoSync()
    // 判断某个值是否存在于存储中

    const hasST = storageInfo.keys.includes('searchText')
    if (hasST) {
      this.searchText = uni.getStorageSync('searchText')
    }
    const startExists = storageInfo.keys.includes('startTime')
    const endExists = storageInfo.keys.includes('startTime')
    const stayRangeExist = storageInfo.keys.includes('stayRange')

    if (startExists && endExists) {
      if (uni.getStorageSync('startTime').timestamp < this.currentTime.timestamp) {
        const today = new Date()
        this.startTime = this.getTime(today)

        const nextDay = new Date()
        nextDay.setDate(nextDay.getDate() + 1)
        this.endTime = this.getTime(nextDay)
        uni.setStorageSync('startTime', this.startTime)
        uni.setStorageSync('endTime', this.endTime)
      } else {
        this.startTime = uni.getStorageSync('startTime')
        this.endTime = uni.getStorageSync('endTime')
      }
    } else {
      const today = new Date()
      this.startTime = this.getTime(today)

      const nextDay = new Date()
      nextDay.setDate(nextDay.getDate() + 1)
      this.endTime = this.getTime(nextDay)
      uni.setStorageSync('startTime', this.startTime)
      uni.setStorageSync('endTime', this.endTime)
    }

    if (!stayRangeExist) {
      uni.setStorageSync('stayRange', 1)
    }

    const locationExist = storageInfo.keys.includes('location')

    if (locationExist) {
      const locationStr = uni.getStorageSync('location')
      this.location = locationStr
      const locationArr = locationStr.split(',')
      this.longitude = locationArr[0]
      this.latitude = locationArr[1]
    } else {
      this.initLocation()
    }

    if (storageInfo.keys.includes('locationText')) {
      this.locationText = uni.getStorageSync('locationText')
    }

    uni.$on('locationInfo', data => {
      console.log(data)
      if (data.latitude != undefined && data.longitude != undefined) {
        this.latitude = data.latitude
        this.longitude = data.longitude
        this.location = `${data.longitude},${data.latitude}`
        uni.setStorageSync('location', `${data.longitude},${data.latitude}`)
        console.log(uni.getStorageSync('location'))
      } else {
        this.location = data.location
        this.latitude = data.location.split(',')[1]
        this.longitude = data.location.split(',')[0]
        uni.setStorageSync('location', data.location)
      }

      if (data.cityName != undefined) {
        this.locationText = data.cityName
        uni.setStorageSync('locationText', data.cityName)
      } else {
        this.locationText = data.name
        uni.setStorageSync('locationText', data.name)
      }
    })
    this.getNearBy()
    this.getRecommendData()
    this.page += 1
  },
  onShow() {
    console.log('onShow')
    uni.$on('changeid', data => {
      console.log(data)
      this.hotelCover.forEach(element => {
        if (element.overview.houseid == data.hid) {
          element.islike = !data.islike
        }
      })
    })
    if (!this.isFirst) {
      const storageInfo = uni.getStorageInfoSync()
      // 判断某个值是否存在于存储中

      const startExists = storageInfo.keys.includes('startTime')
      const endExists = storageInfo.keys.includes('startTime')
      const stayRangeExist = storageInfo.keys.includes('stayRange')

      if (startExists && endExists) {
        if (uni.getStorageSync('startTime').timestamp < this.currentTime.timestamp) {
          const today = new Date()
          this.startTime = this.getTime(today)

          const nextDay = new Date()
          nextDay.setDate(nextDay.getDate() + 1)
          this.endTime = this.getTime(nextDay)
          uni.setStorageSync('startTime', this.startTime)
          uni.setStorageSync('endTime', this.endTime)
        } else {
          this.startTime = uni.getStorageSync('startTime')
          this.endTime = uni.getStorageSync('endTime')
        }
      } else {
        const today = new Date()
        this.startTime = this.getTime(today)

        const nextDay = new Date()
        nextDay.setDate(nextDay.getDate() + 1)
        this.endTime = this.getTime(nextDay)
        uni.setStorageSync('startTime', this.startTime)
        uni.setStorageSync('endTime', this.endTime)
      }
      if (!stayRangeExist) {
        uni.setStorageSync('stayRange', 1)
      }
      this.stayRange = uni.getStorageSync('stayRange')
    }
    this.isFirst = false
  },
  mounted() {
    // 监听经纬度数据的变化，一旦发生变化，立即执行回调函数
    this.$watch('location', this.handleLocationChange)
  }
}
</script>

<style lang="less">
.searchBar {
  opacity: 0;
  position: fixed;
  z-index: 11111;
  width: 100%;
  transition: top 0.3s;
}
.searchBar.fixed {
  opacity: 1;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}
.topbar {
  width: 100%;
  height: var(--status-bar-height);
  background-color: #fff;
}
.fix-searchbar {
  width: 100%;
  height: 120rpx;
  background-color: #fff;
  overflow: hidden;
  .wrapper {
    display: flex;
    width: 92%;
    height: 85rpx;
    margin: 20rpx auto 0rpx;
    justify-content: space-between;
    box-sizing: border-box;
    .left {
      flex: 1;
      border-radius: 100rpx;
      border: 2px solid #ff7014;
      display: flex;
      box-sizing: border-box;
      .location {
        max-width: 90rpx;
        white-space: nowrap;
        text-overflow: ellipsis;
        overflow: hidden;
        height: 100%;
        line-height: 85rpx;
        font-weight: bold;
        font-size: 25rpx;
        padding: 0 14rpx 0 25rpx;
      }
      .checkTime {
        font-size: 20rpx;
        font-weight: bold;
        transform: translateY(20%);
        .desc {
          color: #919191;
        }
        .date {
          margin-left: 5rpx;
        }
      }
      .input {
        flex: 1;
        text-align: center;
        line-height: 85rpx;
        font-weight: bold;
        font-size: 28rpx;
        color: #919191;
        white-space: nowrap;
        text-overflow: ellipsis;
        overflow: hidden;
      }
      .searchBtn {
        width: 100rpx;
        color: #fff;
        font-weight: bold;
        height: 72rpx;
        width: 120rpx;
        background: linear-gradient(to right, #fdb44b, #ff731e);
        text-align: center;
        line-height: 72rpx;
        margin: 3rpx 4rpx;
        border-radius: 1111rpx;
      }
    }
    .right {
      width: 100rpx;
      text-align: center;
      .iconpic {
        width: 45rpx;
        height: 45rpx;
        margin-top: 5rpx;
      }
      .desc {
        height: auto;
        font-size: 20rpx;
        color: #333;
        font-weight: bold;
        margin-top: -5rpx;
      }
    }
  }
}
.uni-margin-wrap {
  width: 690rpx;
  width: 100%;
}
.swiper {
  height: 500rpx;
}
.swiper-item {
  display: block;
  height: 600rpx;
  text-align: center;
  // background-color: #111;
  img {
    width: 100%;
    object-fit: contain;
    z-index: 10;
  }
  .filterImg {
    filter: blur(10px);
    margin-top: -50rpx;
    margin-left: -50rpx;
    z-index: 1;
    width: 200%;
    object-fit: cover;
  }
}
.swiper-list {
  margin-top: 40rpx;
  margin-bottom: 0;
}
.uni-common-mt {
  margin-top: 60rpx;
  position: relative;
}
.info {
  position: absolute;
  right: 20rpx;
}
.uni-padding-wrap {
  width: 550rpx;
  padding: 0 100rpx;
}
.home {
  background-color: #f2f5fa;
  height: 1600rpx;
  .homeHeader {
    position: relative;
    // 渐变遮罩
    .mask {
      height: 400rpx;
      background: linear-gradient(to top, rgba(242, 245, 250, 1) 200rpx, transparent);
      position: relative;
      top: -270rpx;
    }
  }

  .rentCondition {
    width: 94%;
    height: 582rpx;
    border-radius: 23px;
    background-color: rgba(255, 255, 255, 0.8);
    border: 2px solid #fff;
    position: absolute;
    top: 245rpx;
    left: 50%;
    transform: translateX(-50%);
    overflow: hidden;

    .rentCondition-wrapper {
      width: 100%;
      height: 88rpx;
      display: flex;

      .rentCondition-wrapper-left,
      .rentCondition-wrapper-right {
        width: 50%;
        height: 100%;
        position: relative;
        z-index: 20;
        text-align: center;
        line-height: 88rpx;
        font-size: 32rpx;
        font-weight: bold;
      }

      .bgcolorBlock {
        position: absolute;
        height: 30%;
        width: 50%;
        background-color: rgb(255, 255, 255);
        border-radius: 23px;
        z-index: 10;
        transition: 400ms;
        &::after {
          content: ''; /* 必须要有 content 属性，才能显示伪元素 */
          position: absolute; /* 相对于父元素定位 */

          right: 0;
          bottom: 116rpx;
          width: 80rpx;
          height: 10rpx;
          left: 50%; /* 设置伪元素的尺寸，这里使用 left 为 100% 使其充满文本后的空白区域 */
          transform: translateX(-50%);
          border-radius: 1111px;
          background: linear-gradient(to left, rgba(255, 0, 0, 0), #ff7417); /* 设置渐变背景 */
        }
      }
    }

    .rentCondition-content {
      position: relative;
      background-color: #fff;
      height: 100%;
      border-radius: 13px;
      z-index: 20;

      .current-location {
        display: flex;
        height: 144rpx;
        line-height: 144rpx;

        .current-location-left {
          flex: 1;
          height: 100%;
          text-align: left;
          margin-left: 48rpx;
          font-weight: 900;
          font-size: 50rpx;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }

        .current-location-right {
          width: 200rpx;

          .current-location-right-wrapper {
            font-size: 18rpx;
            font-weight: bold;
            width: 100rpx;
            height: 100rpx;
            margin: auto;

            text-align: center;
            .locationDesc {
              margin-top: -50rpx;
              height: 20rpx;
              line-height: 20rpx;
            }
          }
        }
      }

      .checkInTime {
        height: 90rpx;

        padding: 4rpx 42rpx;
        display: flex;

        .checkIn {
          width: 160rpx;
          overflow: hidden;
          display: flex;
          flex-direction: column;
          justify-content: space-between;
          .checkIn-Desc,
          .checkIn-Date {
            height: auto;
            font-weight: bold;
          }
          .checkIn-Desc {
            font-size: 26rpx;
            color: #919191;
          }
          .checkIn-Date {
            font-size: 34rpx;
          }
        }

        .stayTime {
          font-weight: bold;
          font-size: 20rpx;
          color: #727272;
          line-height: 150rpx;
        }

        .checkOut {
          width: 160rpx;
          overflow: hidden;
          margin-left: 16rpx;
          display: flex;
          flex-direction: column;
          justify-content: space-between;
          .checkIn-Desc,
          .checkIn-Date {
            height: auto;
            font-weight: bold;
          }
          .checkIn-Desc {
            font-size: 26rpx;
            color: #919191;
          }
          .checkIn-Date {
            font-size: 34rpx;
          }
        }
        .check-condition {
          flex: 1;
          text-align: right;
          display: flex;
          flex-direction: column;
          justify-content: space-between;
          .checkIn-Desc,
          .checkIn-Date {
            height: auto;
            font-weight: bold;
          }
          .checkIn-Desc {
            font-size: 26rpx;
            color: #919191;
          }
          .checkIn-Date {
            font-size: 34rpx;
          }
        }
      }
      .searchHotel {
        padding: 8rpx 42rpx;
        height: 120rpx;
        line-height: 120rpx;
        font-size: 30rpx;
        font-weight: bold;
        color: #919191;
        display: flex;
        justify-content: space-between;
        .clearIcon {
          width: 30rpx;
          height: 30rpx;
        }
      }
    }
  }

  .recommendContainer {
    position: relative;
    .recHover {
      color: #8d8d8d;
      background-color: rgb(235, 235, 235);
    }
    .itemCover {
      position: absolute;
      width: 42rpx;
      height: 55rpx;
      top: 0;
      right: 0rpx;
      z-index: 99;
      background-color: #fff;
    }
  }
  .recommendWrapper {
    width: 100%;
    overflow-x: hidden;
    white-space: nowrap;
    padding: 0rpx 42rpx;
    margin-top: -10rpx;
    .occp {
      display: inline-block;
      height: 1rpx;
      width: 260rpx;
    }
    .recomendItem {
      display: inline-block;
      font-weight: bold;
      font-size: 24rpx;
      background-color: #f7f6fc;
      border-radius: 4px;
      padding: 8rpx;
      margin-right: 15rpx;
    }
  }
  .searchButton {
    text-align: center;
    font-weight: bold;
    color: white;
    background: linear-gradient(to right, #ff940a, #ff7014);
    margin: 26rpx 42rpx 0rpx;
    height: 100rpx;
    line-height: 100rpx;
    font-size: 35rpx;
    border-radius: 1000px;
    box-shadow: 0 2px 16px 2px rgba(255, 149, 10, 0.21);
  }

  .content {
    width: 92%;
    margin: auto;
    .recomendDesc {
      display: flex;
      justify-content: space-between;
      font-weight: bold;
      font-size: 34rpx;
      position: relative;
      &::after {
        content: '';
        position: absolute; /* 相对于父元素定位 */
        left: 0;
        bottom: -20rpx;
        width: 70rpx;
        height: 10rpx;

        border-radius: 1111px;
        background: linear-gradient(to left, rgba(255, 0, 0, 0), #ff7417); /* 设置渐变背景 */
      }
    }

    .contentWrapper {
      margin-top: 44rpx;

      display: flex;
      flex-wrap: wrap;
      justify-content: space-between;
      .hotelItem {
        border-radius: 12rpx;
        width: 49%;
        background-color: rgb(255, 255, 255);
        margin-top: 16rpx;
        overflow: hidden;
        .picWrapper {
          width: 100%;
          height: 440rpx;
          overflow: hidden;
          position: relative;
          .pic {
            filter: brightness(90%);
            width: 100%;
            height: 100%;
          }

          .hotelDesc {
            position: absolute;
            bottom: 0;
            width: 100%;
            display: flex;
            padding: 10rpx;
            color: #fff;
            font-weight: bold;
            background: linear-gradient(to top, rgba(17, 17, 17, 0.329), rgba(0, 0, 0, 0));
            .icon {
              width: 25rpx;
              height: 25rpx;
            }
            .desc {
              width: 86%;
              font-size: 20rpx;
              overflow: hidden;
              white-space: nowrap;
              text-overflow: ellipsis;
            }
          }

          .likewrap {
            position: absolute;
            top: 15rpx;
            right: 15rpx;
            .like {
              width: 45rpx;
              height: 45rpx;
            }
          }
        }

        .textWrapp {
          padding: 20rpx 16rpx;
          font-weight: bold;
          .hotelName {
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
          }

          .rmb {
            color: #ff7014;
            font-size: 24rpx;
          }
          .currentPrice {
            margin-top: 16rpx;
            margin-left: -6rpx;
            color: #ff7014;
            font-size: 36rpx;
          }
          .orgPrice {
            font-size: 20rpx;
            color: #919191;
          }
        }
      }
    }
  }
}
.calendar {
  .uni-calendar-item--isDay-text {
    color: #ff7014;
  }
  .uni-calendar-item--multiple {
    background-color: #ffc9a8;
    span {
      background-color: transparent;
    }
  }
  .uni-calendar-item--before-checked,
  .uni-calendar-item--after-checked,
  .uni-calendar-item--isDay,
  .uni-calendar-item--checked {
    background-color: #ff7014;
    color: #fff;
  }
}

.popup-content {
  text-align: center;
  font-weight: bold;
  color: #333;
  .title {
    padding: 30rpx 0 80rpx;
    font-size: 30rpx;
  }
  .peopleCount-wrapper {
    padding: 0 15rpx;
    .peopleCount {
      padding: 0 30rpx;
      .pCount {
        width: 100%;
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        .pCountItem {
          border-radius: 1111px;
          background-color: #f6f7fb;
          width: 24%;
          margin-top: 20rpx;
          padding: 10rpx 0;
          font-size: 26rpx;
        }
        i {
          width: 24%;
        }
      }
    }
    .title {
      font-size: 25rpx;
      text-align: left;
      padding: 0;
      margin-left: 15rpx;
    }
  }

  .bedCount {
    margin: 60rpx 0;
  }

  .button-group {
    display: flex;
    justify-content: space-between;
    padding: 20rpx 60rpx;
    margin-bottom: 20rpx;
    .btn {
      width: 47%;
      height: 80rpx;
      line-height: 80rpx;
      border-radius: 1111px;
      font-size: 30rpx;
    }
    .cancle-btn {
      border: 2px solid #333;
    }
    .confirm-btn {
      background-color: #fe7815;
      border: 2px solid #fe7815;
      color: white;
    }
  }
}
.texthover {
  color: #7c7c7c;
}
.empty {
  background-color: #fff;
  height: 900rpx;
  text-align: center;
  image {
    width: 100vw;
  }
  margin-top: 30rpx;
  .desc {
    font-weight: 900;
    color: #747474;
  }
}
.nomore {
  margin-top: 80rpx;
  margin-bottom: 30rpx;
  color: #b1b1b1;
  text-align: center;
  font-weight: bold;
  font-size: 26rpx;
}
.marginblock {
  width: 100vw;
  height: 80rpx;
}
</style>
