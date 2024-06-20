<template>
  <view class="root_ctn">
    <view class="searchBar fixed">
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
            <view class="input" @click="toSearch">
							<text v-if="!searchText">位置/民宿/关键字</text>
							<text v-if="searchText" style="color:#333;font-weight:900">{{searchText}}</text>
							 </view>
            <view class="searchBtn">搜索</view>
          </view>
        </view>
      </view>
      <view class="conditions">
        <view class="sortCondition c_item" @click="openSortpop" :class="{'conditionSelected':rec_index!=0}">{{rec_textArr[rec_index]}}</view>
        <view class="priceCondition c_item" @click="openPricpop" :class="{'conditionSelected':maxPrice!=null||minPrice!=null}">价格范围</view>
        <view class="distanceCondition c_item" @click="openDistpop" :class="{'conditionSelected':distance_index!=null}">{{distance_text}}</view>
        <view class="facCondition c_item" @click="openFacpop" :class="{'conditionSelected':hasFacCondition}">筛选条件</view>
      </view>
    </view>

    <!-- 房屋展示 -->
    <view class="house-content" v-if="houseInfo.length!=0">
      <view class="contentMargin"></view>
      <scroll-view scroll-y="true" class="houseList" @scrolltolower="getMoreHouse">

        <view class="houseItem" v-for="(house,index) in houseInfo" :key="index">
          <view class="cover">
            <swiper class="swiper" circular :autoplay="false" :circular="true">
              <swiper-item v-for="(cover,index) in house.coverurls">
                <view class="swiper-item">
                  <image :src="cover" class="coverPic" mode="aspectFill" @click="toHouseDetail(house.overview.houseid)" />
                </view>
              </swiper-item>
            </swiper>
            <view class="iconGroup">
              <image class="like bright" @click="likeHotel(house)" src="../../static/image/icon/like.png" v-if="!house.islike" />
              <image class="like" @click="likeHotel(house)" src="../../static/image/icon/like-active.png" v-if="house.islike" />
            </view>
            <view class="distance">距离您约{{house.distance.toFixed(1)}}米</view>
          </view>
          <view class="avatar">
            <image class="avatarPic" :src="house.landlordAvatar" mode="aspectFill" />
          </view>

          <view class="desc left20">
            <view class="favorDesc">{{house.overview.favoritecount}}人收藏</view>
            <view class="commentDesc">{{house.overview.commentcount}}条评论</view>
          </view>
          <view class="rating">{{house.overview.rating.toFixed(1)}}</view>
          <view class="housename left20">{{house.overview.housename}}</view>
          <view class="facs left20">{{house.overview.roomcount}}室{{house.overview.bathroomcount}}卫·{{house.overview.bedcount}}床·宜居{{house.overview.maxguests}}人</view>
          <view class="priceMoudle left20">
            <text class="rmb">￥</text>
            <text class="disprice">{{house.overview.discountprice}}</text>
            <text class="per9">/晚</text>
            <del class="orgprice">￥{{house.overview.originalprice}}</del>
            <text class="reduce">已减{{house.overview.originalprice-house.overview.discountprice}}元</text>
            <text class="tag">早鸟特惠</text>
          </view>
        </view>
        <view class="nomore" v-if="shownomore">-没有更多了-</view>
        <view class="bottomMarginBolck"></view>
      </scroll-view>
    </view>
    <!-- 无结果 -->
    <view class="empty" v-if="showEmpty">
      <image src="../../static/image/empty_bg.png" mode="" />
      <text class="desc">暂无数据</text>
    </view>
    <!-- 提示信息弹窗 -->
    <uni-popup ref="sortpopup" background-color="#fff" border-radius="0 0 20rpx 20rpx">
      <view class="sort_popup_content">
        <view class="marginblock"></view>
        <view class="text_content">

          <view class="sort_item" :class="{'selected':rec_index==index}" @click="selectSort(index)" v-for="(item,index) in rec_textArr" :key="index">

            <view>{{rec_textArr[index]}}</view>
            <image class="selectIco" src="../../static/image/icon/selected.png" mode="aspectFit" />
          </view>
        </view>
      </view>
    </uni-popup>

    <!-- 距离筛选  和上面共用一套样式-->
    <uni-popup ref="distancepopup" background-color="#fff" border-radius="0 0 20rpx 20rpx">
      <view class="sort_popup_content">
        <view class="marginblock"></view>
        <view class="text_content">
          <view class="sort_item" :class="{'selected':distance_index==item}" v-for="item in 5" @click="selectDistance(item)">

            <view>距您{{item}}公里</view>
            <image class="selectIco" src="../../static/image/icon/selected.png" mode="aspectFit" />
          </view>

        </view>
      </view>
    </uni-popup>

    <!-- 价格筛选  -->
    <uni-popup ref="pricepopup" background-color="#fff" border-radius="0 0 20rpx 20rpx" @change="closePricePop">
      <view class="price_popup_content">
        <view class="marginblock"></view>
        <view class="price_content">
          <view class="price_item" @click="selectPrice(null,150,0)" :class="{'selected2':price_index==0}">￥150以下</view>
          <view class="price_item" @click="selectPrice(150,200,1)" :class="{'selected2':price_index==1}">￥150-￥200</view>
          <view class="price_item" @click="selectPrice(200,300,2)" :class="{'selected2':price_index==2}">￥200-￥300</view>
          <view class="price_item" @click="selectPrice(300,400,3)" :class="{'selected2':price_index==3}">￥300-￥400</view>
          <view class="price_item" @click="selectPrice(400,600,4)" :class="{'selected2':price_index==4}">￥400-￥600</view>
          <view class="price_item" @click="selectPrice(600,null,5)" :class="{'selected2':price_index==5}">￥600以上</view>
        </view>
        <view class="priceOption">
          <text class="priceCancle" @click="clearPrice">清空</text>
          <view class="priceConfirm" @click="confirmPrice">确定</view>
        </view>
      </view>
    </uni-popup>

    <!-- 设施筛选  -->
    <uni-popup ref="facpopup" background-color="#fff" border-radius="0 0 20rpx 20rpx" @change="closeFacpop">
      <view class="fac_popup_content">
        <view class="marginblock"></view>
        <scroll-view class="fac_content">
          <view class="peopleCount-wrapper">
            <view class="title">房源户型</view>
            <view class="peopleCount">
              <view class="pCount">
                <view class="pCountItem" @click="selectRoom(1)" :class="{'selected2':room_index==1}">
                  一室
                </view>
                <view class="pCountItem" @click="selectRoom(2)" :class="{'selected2':room_index==2}">
                  二室
                </view>
                <view class="pCountItem" @click="selectRoom(3)" :class="{'selected2':room_index==3}">
                  三室
                </view>
                <view class="pCountItem" @click="selectRoom(4)" :class="{'selected2':room_index==4}">
                  四室及以上
                </view>
              </view>

            </view>
          </view>
          <view class="peopleCount-wrapper bedCount">
            <view class="title">宜居人数</view>
            <view class="peopleCount">
              <view class="pCount">
                <view class="pCountItem" v-for="item in 10" @click="selectPeople(item)" :class="{'selected2':people_index==item}">{{item}}人</view>
                <view class="pCountItem" @click="selectPeople(11)" :class="{'selected2':people_index==11}">10人+</view>
                <i></i>
              </view>

            </view>
          </view>

          <view class="peopleCount-wrapper bedCount">
            <view class="title">床铺数量</view>
            <view class="peopleCount">
              <view class="pCount">
                <view class="pCountItem" v-for="item in 10" @click="selectBed(item)" :class="{'selected2':bed_index==item}">{{item}}张</view>
                <view class="pCountItem" @click="selectBed(11)" :class="{'selected2':bed_index==11}">10张+</view>
                <i></i>
              </view>

            </view>
          </view>
        </scroll-view>
        <view class="facOption">
          <text class="facCancle" @click="clearFac">清空</text>
          <view class="facConfirm" @click="confirmFac">确定</view>
        </view>
      </view>
    </uni-popup>
  </view>
</template>

<script>
import API from '../../static/data/API.js';
export default {
  data() {
    return {
      searchText: '',
      startTime: {},
      endTime: {},
      stayRange: 1,
      locationText: '我的附近',
      room_condition: null,
      people_condition: null,
      bed_condition: null,
      distance_condition: null,
      maxPrice: null,
      minPrice: null,
      rec_index: 0,
      price_index: null,
      room_index: null,
      people_index: null,
      bed_index: null,
      distance_index: null,
      distance: null,
      rec_textArr: ['推荐排序', '距离优先', '价格升序', '价格降序', '评论优先'],
      distance_text: '位置区域',
      maxPrice_cache: null,
      minPrice_cache: null,
      facDataCache: {
        room_count: null,
        bed_count: null,
        maxPeople: null
      },
      page: 1,
      maxPage: null,
      houseInfo: [],
      total: 0,
      shownomore: false,
      showEmpty: false
    }
  },
  methods: {
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
    selectCity() {
      uni.navigateTo({
        url: '/pages/selectCity/selectCity'
      })
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
    openSortpop() {
       this.$refs.facpopup.close()
      this.$refs.pricepopup.close()
      this.$refs.distancepopup.close()
      this.$refs.sortpopup.open('top')
    },
    openDistpop() {
      this.$refs.facpopup.close()
      this.$refs.pricepopup.close()
      this.$refs.sortpopup.close()
      this.$refs.distancepopup.open('top')
    },
    openPricpop() {
      this.$refs.facpopup.close()
      this.$refs.distancepopup.close()
      this.$refs.sortpopup.close()
      this.$refs.pricepopup.open('top')
    },
    openFacpop() {
      this.$refs.pricepopup.close()
      this.$refs.distancepopup.close()
      this.$refs.sortpopup.close()
      this.$refs.facpopup.open('top')
    },
    selectSort(index) {
      this.rec_index = index
      this.$refs.sortpopup.close()
      //把文字内容变色，伪类也变色，并且改变相应文字
      // 做排序操作
    },
    selectDistance(item) {
      if (item == this.distance_index) {
        this.distance_index = null
        this.distance_text = '位置区域'
        this.distance_condition = null
      } else {
        this.distance_index = item
        this.distance_text = `距您${item}公里`
        this.distance_condition = item
      }
      this.$refs.distancepopup.close()
    },
    selectPrice(minPrice, maxPrice, index) {
      console.log(222)
      if (this.minPrice_cache == minPrice && this.maxPrice_cache == maxPrice) {
        this.maxPrice_cache = null
        this.minPrice_cache = null
        this.price_index = null
      } else {
        this.maxPrice_cache = maxPrice
        this.minPrice_cache = minPrice
        this.price_index = index
      }
    },
    closePricePop(e) {
      if (!e.show) {
        if (this.maxPrice == null && this.minPrice == null) {
          this.price_index = null
          this.maxPrice_cache = null
          this.minPrice_cache = null
        }
      }
    },
    confirmPrice() {
      this.minPrice = this.minPrice_cache
      this.maxPrice = this.maxPrice_cache
      //发起请求
      this.houseInfo = []
      this.page = 1
      this.getRecommendData()
      this.$refs.pricepopup.close()
    },
    clearPrice() {
      this.maxPrice = null
      this.minPrice = null
      this.price_index = null
      this.maxPrice_cache = null
      this.minPrice_cache = null
    },
    selectRoom(index) {
      if (index == this.facDataCache.room_count) {
        this.facDataCache.room_count = null
        this.room_index = null
      } else {
        this.facDataCache.room_count = index
        this.room_index = index
      }
    },
    selectPeople(index) {
      if (index == this.facDataCache.maxPeople) {
        this.facDataCache.maxPeople = null
        this.people_index = null
      } else {
        this.facDataCache.maxPeople = index
        this.people_index = index
      }
    },
    selectBed(item) {
      if (item == this.facDataCache.bed_count) {
        this.facDataCache.bed_count = null
        this.bed_index = null
      } else {
        this.facDataCache.bed_count = item
        this.bed_index = item
      }
    },
    closeFacpop(e) {
      if (!e.show) {
        console.log(this.hasFacCondition)
        console.log(this.room_condition)
        console.log(this.bed_condition)
        console.log(this.people_condition)
        if (this.room_condition == null && this.bed_condition == null && this.people_condition == null) {
          this.room_index = null
          this.bed_index = null
          this.people_index = null
          this.facDataCache = {
            room_count: null,
            bed_count: null,
            maxPeople: null
          }
        }
      }
    },
    confirmFac() {
      console.log(3)
      this.room_condition = this.facDataCache.room_count
      this.people_condition = this.facDataCache.maxPeople
      this.bed_condition = this.facDataCache.bed_count
      console.log(this.room_condition)
      console.log(this.people_condition)
      console.log(this.bed)
      this.houseInfo = []
      // 发送请求
      this.page = 1
      this.getRecommendData()
      // 关闭弹窗
      this.$refs.facpopup.close()
    },

    clearFac() {
      this.room_condition = null
      this.bed_condition = null
      this.people_condition = null
      this.people_index = null
      this.bed_index = null
      this.room_index = null
      this.facDataCache = {
        room_count: null,
        bed_count: null,
        maxPeople: null
      }
    },
    getRecommendData() {
      this.shownomore = false
      this.showEmpty = false
      const locationArr = uni.getStorageSync('location').split(',')
      uni.request({
        url: `${API.BASE_URL}/getRecommendHouses`, //仅为示例，并非真实接口地址。
        data: {
          longitude: locationArr[0],
          latitude: locationArr[1],
          userid: uni.getStorageSync("userId"),
          page: this.page,
          maxPrice_c: this.maxPrice,
          minPrice_c: this.minPrice,
          bedcount_c: this.bed_condition,
          roomcount_c: this.room_condition,
          maxpeople_c: this.people_condition,
          distance_c: this.distance_condition
        },
        success: res => {
          const rdata = res.data.data
          if (res.data.requestStatus == '300') {
            if (this.houseInfo.length == 0) {
              this.showEmpty = true
            }
          } else {
            if (this.houseInfo.length != 0) {
              this.houseInfo = [
                ...this.houseInfo,
                ...rdata.houseInfo.sort((element1, element2) => {
                  return element2.recommendValue - element1.recommendValue
                })
              ]
            } else {
              this.houseInfo = rdata.houseInfo.sort((element1, element2) => {
                return element2.recommendValue - element1.recommendValue
              })
              this.total = rdata.total
            }
          }
          this.page = this.page + 1
        }
      })
    },
    toHouseDetail(houseid) {
      uni.navigateTo({
        url: `/pages/hotelDetail/hotelDetail?houseid=${houseid}`
      })
    },
    getMoreHouse() {
      console.log(this.maxpage)
      if (this.maxpage >= this.page) {
        this.getRecommendData()
      } else {
        // 显示没有更多了
        console.log('no more')
        this.shownomore = true
      }
    },
    handleSort() {
      if (this.rec_index == 0) {
        this.houseInfo = this.houseInfo.sort((element1, element2) => {
          return element2.recommendValue - element1.recommendValue
        })
      } else if (this.rec_index == 1) {
        this.houseInfo = this.houseInfo.sort((element1, element2) => {
          return element1.distance - element2.distance
        })
      } else if (this.rec_index == 2) {
        this.houseInfo = this.houseInfo.sort((element1, element2) => {
          return element1.overview.discountprice - element2.overview.discountprice
        })
      } else if (this.rec_index == 3) {
        this.houseInfo = this.houseInfo.sort((element1, element2) => {
          return element2.overview.discountprice - element1.overview.discountprice
        })
      } else if (this.rec_index == 4) {
        this.houseInfo = this.houseInfo.sort((element1, element2) => {
          return element2.overview.commentcount - element1.overview.commentcount
        })
      }
    },
    handleDistance() {
      if (this.distance_index != null) {
        this.distance_condition == null
        this.distance_condition = this.distance_index * 1000
        this.houseInfo = []
        this.rec_index = 0
        this.page = 1
        this.getRecommendData()
      } else {
        console.log(this.distance_condition)
        this.houseInfo = []
        this.rec_index = 0
        this.page = 1
        this.getRecommendData()
      }
    },
		toSearch(){
			uni.removeStorageSync('searchText');
			uni.navigateTo({
				url:"/pages/search/search"
			})
		}
  },
  computed: {
    hasFacCondition() {
      if (this.room_condition == null && this.bed_condition == null && this.people_condition == null) {
        return false
      } else {
        return true
      }
    },
    maxpage() {
      return Math.ceil(this.total / 10)
    }
  },
  onLoad() {

		
    const storageInfo = uni.getStorageInfoSync()
    // 判断某个值是否存在于存储中
		const hasST = storageInfo.keys.includes("searchText")
		if(hasST){
			this.searchText=uni.getStorageSync("searchText")
		}
    const startExists = storageInfo.keys.includes('startTime')
    const endExists = storageInfo.keys.includes('startTime')
    const stayRangeExist = storageInfo.keys.includes('stayRange')

    if (startExists && endExists) {
      this.startTime = uni.getStorageSync('startTime')
      this.endTime = uni.getStorageSync('endTime')
      if (this.startTime <= new Date()) {
        const today = new Date()
        this.startTime = this.getTime(today)

        const nextDay = new Date()
        nextDay.setDate(nextDay.getDate() + 1)
        this.endTime = this.getTime(nextDay)
        uni.setStorageSync('startTime', this.startTime)
        uni.setStorageSync('endTime', this.endTime)
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
    if (storageInfo.keys.includes('locationText')) {
      this.locationText = uni.getStorageSync('locationText')
    }
    this.getRecommendData()
    this.$watch('rec_index', this.handleSort)
    this.$watch('distance_index', this.handleDistance)
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
  .conditions {
    background-color: rgb(255, 255, 255);
    display: flex;
    justify-content: space-between;
    padding: 10rpx 45rpx 24rpx;
    .c_item {
      width: 150rpx;
      text-align: center;
      font-size: 26rpx;
      font-weight: 900;
      color: #585858;
      position: relative;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      &::after {
        content: '';
        position: absolute;
        bottom: 4rpx;
        right: 5rpx;
        border-bottom: 10rpx solid #585858;
        border-left: 10rpx solid transparent;
        // color: #ff7014;
      }
    }
  }
}
.searchBar.fixed {
  opacity: 1;
  z-index: 999;
  // box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
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

.sort_popup_content {
  .marginblock {
    width: 100vw;
    height: 200rpx;
  }
  .text_content {
    .sort_item {
      font-weight: 900;
      color: #585858;
      padding: 20rpx 45rpx;
      display: flex;
      justify-content: space-between;
      .selectIco {
        width: 34rpx;
        height: 34rpx;
        opacity: 0;
      }
    }
    .selected {
      color: #ff7014;
      .selectIco {
        opacity: 1;
      }
    }
  }
}
.price_popup_content {
  .marginblock {
    height: 200rpx;
    width: 100vw;
  }
  .price_content {
    padding: 0 45rpx;
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    margin-bottom: 20rpx;
    .price_item {
      font-weight: 900;

      width: 30%;
      text-align: center;
      height: 48rpx;
      font-size: 26rpx;
      line-height: 48rpx;
      border-radius: 111rpx;
      background-color: #f7f6fb;
      margin-top: 16rpx;
    }
  }
  .priceOption {
    background-color: #fdfdfd;
    border-radius: 0 0 20rpx 20rpx;
    width: 100vw;
    height: 140rpx;
    display: flex;
    justify-content: space-between;
    padding: 0 45rpx;
    box-sizing: border-box;
    .priceCancle {
      font-weight: 900;
      line-height: 140rpx;
      color: #585858;
    }
    .priceConfirm {
      width: 400rpx;
      text-align: center;
      height: 60rpx;
      line-height: 60rpx;
      color: #ff7014;
      font-weight: 900;
      border-radius: 9999px;
      border: 1px solid #ff7014;
      background-color: #fff;
      margin-top: 40rpx;
    }
  }
}

.fac_popup_content {
  .marginblock {
    height: 200rpx;
    width: 100vw;
  }
  .fac_content {
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
  .facOption {
    background-color: #fdfdfd;
    border-radius: 0 0 20rpx 20rpx;
    width: 100vw;
    height: 140rpx;
    display: flex;
    justify-content: space-between;
    padding: 0 45rpx;
    box-sizing: border-box;
    .facCancle {
      font-weight: 900;
      line-height: 140rpx;
      color: #585858;
    }
    .facConfirm {
      width: 400rpx;
      text-align: center;
      height: 60rpx;
      line-height: 60rpx;
      color: #ff7014;
      font-weight: 900;
      border-radius: 9999px;
      border: 1px solid #ff7014;
      background-color: #fff;
      margin-top: 40rpx;
    }
  }
}

.conditionSelected {
  color: #ff7014 !important;
  &::after {
    content: '';
    position: absolute;
    bottom: 4rpx;
    right: 5rpx;
    border-bottom: 10rpx solid #ff7014 !important;
    border-left: 10rpx solid transparent;
    // color: #ff7014;
  }
}
.selected2 {
  color: #fff;
  background-color: #ff7014 !important;
}

.house-content {
  width: 100vw;
  height: 100vh;

  .contentMargin {
    height: 240rpx;
    width: 100vw;
  }
  .houseList {
    height: 1500rpx;
    .left20 {
      margin-left: 20rpx !important;
    }
    .houseItem {
      border-radius: 30rpx;
      padding: 8rpx;
      box-sizing: border-box;
      background-color: rgb(255, 255, 255);
      width: 94vw;
      margin: 24rpx auto;
      box-shadow: 0 0 11px 0px #00000021;
      position: relative;
      .cover {
        height: 440rpx;
        width: 100%;
        position: relative;
        .swiper {
          height: 440rpx;
          border-radius: 30rpx;
          overflow: hidden;
        }
        .coverPic {
          width: 100%;
          height: 440rpx;
          filter: brightness(90%);
        }
        .iconGroup {
          right: 15rpx;
          top: 15rpx;
          position: absolute;
          .bright {
            filter: brightness(300%);
          }
          .like {
            width: 46rpx;
            height: 46rpx;
          }
        }
        .distance {
          font-weight: 900;
          position: absolute;
          bottom: 30rpx;
          left: 20rpx;
          background-color: rgba(255, 255, 255, 0.863);
          color: #232220;
          font-size: 20rpx;
          padding: 8rpx 28rpx;
          border-radius: 1111rpx;
        }
      }
      .avatar {
        position: absolute;
        border-radius: 9999rpx;
        background-color: #fff;
        width: 102rpx;
        height: 102rpx;
        overflow: hidden;
        text-align: center;
        right: 40rpx;
        top: 415rpx;
        display: flex;
        align-items: center;
        justify-content: space-around;

        .avatarPic {
          width: 90rpx;
          height: 90rpx;
          border-radius: 1111rpx;
        }
      }
      .desc {
        margin-top: 30rpx;
        font-size: 24rpx;
        font-weight: 900;
        color: #7c7c7c;
        display: flex;
        .favorDesc,
        .commentDesc {
          background-color: #f8f8f8;
          border-radius: 10rpx;
          padding: 8rpx 10rpx;
        }
        .commentDesc {
          margin-left: 16rpx;
        }
      }
      .rating {
        position: absolute;
        right: 40rpx;
        bottom: 20rpx;
        font-size: 60rpx;
        font-weight: bold;
        color: #ff6e146b;
      }
      .housename {
        margin-top: 15rpx;
        font-size: 36rpx;
        font-weight: 900;
        text-overflow: ellipsis;
        overflow: hidden;
        white-space: nowrap;
      }
      .facs {
        margin-top: 4rpx;
        font-size: 26rpx;
        font-weight: 900;
      }

      .priceMoudle {
        margin-top: 20rpx;
        margin-bottom: 20rpx;
        font-weight: 900;
        .rmb {
          font-size: 20rpx;
        }
        .disprice {
          font-size: 44rpx;
        }
        .disprice,
        .rmb,
        .per9 {
          color: #fe7815;
        }
        .per9 {
          font-size: 23rpx;
        }
        .orgprice {
          color: #cccccc;
          font-size: 20rpx;
          margin-left: 5rpx;
        }
        .reduce {
          padding: 6rpx 20rpx;
          background-color: #fe76151a;
          color: #fe7815;
          border-radius: 6rpx;
          font-size: 22rpx;
          margin-left: 8rpx;
        }
        .tag {
          padding: 6rpx 20rpx;
          border: 1px dotted #fe7815;
          border-radius: 6rpx;
          font-size: 22rpx;
          color: #fe7815;
        }
      }
    }
    .bottomMarginBolck {
      height: 200rpx;
      width: 100vw;
    }
  }
}
.root_ctn {
  overflow: hidden;
}
.nomore {
  margin-top: 20rpx;
  margin-bottom: 30rpx;
  color: #b1b1b1;
  text-align: center;
  font-weight: bold;
  font-size: 26rpx;
}
.empty {
  margin-top: 240rpx;
  width: 100vw;
  text-align: center;
  position: relative;
  .desc {
    position: absolute;
    font-weight: 900;
    color: #919191;
    bottom: 0rpx;
    left: 50%;
    transform: translateX(-50%);
  }
}
</style>
