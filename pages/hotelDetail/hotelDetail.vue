<template>
  <view>
    <view class="statusbar" :class="{'bgwhite':isFixed}"></view>
    <view class="topbar" :class="{'bgwhite':isFixed}">
      <view class="left" @click="naback">
        <image class="topbar-icon leftIco" v-if="!isFixed" src="../../static/image/icon/back_white.png" mode="aspectFit" />
        <image class="topbar-icon leftIco" v-if="isFixed" src="../../static/image/icon/back_balck.png" mode="aspectFit" />
      </view>
      <view class="right">
        <image class="topbar-icon rightIco" v-if="!isFixed" src="../../static/image/icon/message_white.png" mode="aspectFit" />
        <image class="topbar-icon rightIco" v-if="isFixed" src="../../static/image/icon/message_black.png" mode="aspectFit" />
      </view>
    </view>

    <view class="navigatorbar">
    </view>
    <scroll-view scroll-y="true" class="detailParent" v-if="!isloading">
      <!-- 轮播图 -->
      <view class="swiper-wrap">
        <swiper class="swiper" :circular="true" :autoplay="true" @change="swiperChange">
          <swiper-item v-for="(item,index) in houseImg" :key="index">
            <image class="houseImgs" :src="item.url" mode="aspectFill" @tap="goGallery" />
          </swiper-item>
        </swiper>

        <!-- 图片指示器 -->
        <view class="indicator">{{currentPic}}/{{houseImg.length}}</view>
      </view>

      <view class="overview">
        <view class="houseName">
          <view class="left">{{overview.housename}}</view>
          <view class="right">
            <view class="rating">
              <view class="rate">{{overview.rating}}</view>
              <image class="ratePic" :src="ratePic" mode="aspectFit" />
              <view class="colorblock"></view>
              <view class="commentCount">{{overview.commentcount}}点评</view>
            </view>

          </view>
        </view>

        <view class="houseInfo">
          <view class="rentType info-item">
            <view class="icowrapper">
              <image class="ico" src="../../static/image/icon/house.png" mode="aspectFit" />
              <view class="colorblock"></view>
            </view>
            <view class="textBlack">{{overview.rentaltype}}</view>
            <view class="textGray">{{overview.housetype}}</view>
          </view>
          <view class="roomCount info-item">
            <view class="icowrapper">
              <image class="ico roomico" src="../../static/image/icon/door.png" mode="aspectFit" />
              <view class="colorblock"></view>
            </view>
            <view class="textBlack">{{overview.roomcount}}间卧室</view>
            <view class="textGray">{{overview.bathroomcount}}卫{{overview.kitchencount}}厨</view>
          </view>
          <view class="bedCount info-item">
            <view class="icowrapper">
              <image class="ico" src="../../static/image/icon/bed.png" mode="aspectFit" />
              <view class="colorblock"></view>
            </view>
            <view class="textBlack">{{overview.bedcount}}床{{overview.maxguests}}人

            </view>
            <view class="textGray">
              <text v-if="policies.allowaddguests==0">不可加客</text>
              <text v-else>加客{{policies.allowaddguests}}一人</text>
            </view>
          </view>
        </view>

        <view class="addresswrapper">
          <view class="textBlack">{{overview.address}}</view>
          <view class="textGray" v-if="addressMoudle[0]">-距{{addressMoudle[0].name}}约{{addressMoudle[0].distance}}米</view>
          <view class="textGray" v-if="addressMoudle[1]">-距{{addressMoudle[1].name}}约{{addressMoudle[1].distance}}米</view>

          <view class="toMap" @click="nvgToMapview">
            <image class="ico" src="../../static/image/icon/locationOrange.png" mode="aspectFit" />
            <view class="text">地图·周边</view>
          </view>

          <view class="rightarrow">
            <image class="ico" src="../../static/image/icon/right.png" mode="aspectFit" />
          </view>
        </view>

        <view class="checkDate" @click="openCalendar">
          <text class="date">{{startTime.month}}月{{startTime.date}}日</text>
          <text class="desc">入住</text>
          <text class="date">{{endTime.month}}月{{endTime.date}}日</text>
          <text class="desc">离开</text>

          <view class="right">
            <text class="stayRange">{{stayRange}}晚</text>
            <image class="ico" src="../../static/image/icon/right.png" mode="aspectFit" />
          </view>

        </view>

        <view class="facilitiesbrief">
          <view class="title">
            <view class="left">设施/服务</view>
            <view class="right" @click="openfacPopup">
              <view class="desc">{{facilitiesCount}}项设施</view>
              <image class="ico" src="../../static/image/icon/right.png" mode="aspectFit" />
            </view>
          </view>
          <view class="content">
            <view class="fac-item" v-for="(group,index) in facilitiesbrief" :key="index">
              <view class="left" v-if="group.items.length">
                <view class="leftText">{{group.group}}</view>
              </view>
              <view class="right">
                <view class="right-item" v-for="(item,index) in group.items" :key="index">
                  <image class="ico" src="../../static/image/icon/complete.png" mode="aspectFit" />
                  <view class="desc">{{item.facName}}</view>
                </view>
                <i></i>
              </view>
            </view>
          </view>
        </view>

        <view class="bedDetail">
          <view class="title">
            <view class="left">床位信息</view>
          </view>
          <view class="content">
            <view class="beditem" v-for="(item,index) in bedMsg" :key="index">
              <view class="left">
                <view class="leftText">{{item.bedDesc}}</view>
              </view>
              <view class="right">
                <view class="rightText">{{item.count}}张</view>
              </view>
            </view>
          </view>
        </view>
        <view class="commentBrief" v-if="commentBrief">
          <view class="title">
            <view class="left">房客点评</view>
            <view class="right" @click="toComDet">
              <view class="desc">{{overview.commentcount}}条点评</view>
              <image class="ico" src="../../static/image/icon/right.png" mode="aspectFit" />
            </view>
          </view>

          <view class="content">
            <view class="top">
              <view class="rate">
                <text class="finalRate">{{commentBrief.rating}}</text>
                <image class="ratePic" :src="ratePic" mode="aspectFit" />
                <text class="totalCommentCount">{{`(共${overview.commentcount}条)`}}</text>
              </view>
              <view class="rateDetail" v-if="commentBrief.rateDetail.length!=0">
                <view class="rateDetail-item" v-for="(item, index) in commentBrief.rateDetail" :key="index">
                  <text class="desc">{{item.desc}}</text>
                  <text class="sRate">{{item.rating}}</text>
                </view>
              </view>
            </view>

            <view class="nbottom">
              <view class="avatar" v-if="avatars!=undefined">
                <view class="avatar-left">
                  <image class="avatarPic" :src="avatars.userAvatars" mode="aspectFill" />
                </view>
                <view class="avatar-right">
                  <view class="nickname">{{commentBrief.username}}</view>
                  <view class="tar">
                    <view class="time">{{commentBrief.commenttime.year}}年{{commentBrief.commenttime.month}}月{{commentBrief.commenttime.date}}日评论</view>
                    <view class="userrate">{{commentBrief.rating}}</view>
                  </view>
                </view>
              </view>

              <view class="commentContent">
                {{commentBrief.commentcontent}}
              </view>
              <view class="picWrapper" v-if="commentImages!=[]">
                <image v-for="(item, index) in commentImages" :key="index" class="comPic" :src="item.url" mode="scaleToFill" />
                <i></i><i></i><i></i>
              </view>
            </view>
          </view>
        </view>

        <view class="features">
          <view class="title">
            <view class="left">房源特色</view>
            <view class="right" @click="openfeaPopup">
              <view class="desc">亮点周边</view>
              <image class="ico" src="../../static/image/icon/right.png" mode="aspectFit" />
            </view>
          </view>

          <view class="content" v-if="features.length!=0">
            <text class="contentText">{{features[0].featurecontent}}</text>

          </view>
        </view>

        <view class="landLord">
          <view class="title">
            <view class="left">房东介绍</view>
            <view class="right" @click="openLD">
              <view class="desc">房东主页</view>
              <image class="ico" src="../../static/image/icon/right.png" mode="aspectFit" />
            </view>
          </view>

          <view class="content" v-if="avatars!=undefined">
            <view class="contentWrapper">
              <view class="left">
                <image class="lavatar" :src="avatars.landLordAvatars" mode="aspectFill" />
              </view>
              <view class="right">
                <view class="nickname">{{overview.landlordnickname}}</view>
                <view class="text">实名认证</view>
              </view>
            </view>
          </view>
        </view>

        <view class="policy">
          <view class="title">
            <view class="left">预订须知 <text class="Tips">(规则由房东制定)</text></view>
            <view class="right" @tap="openntkPopup">
              <view class="desc">全部政策</view>
              <image class="ico" src="../../static/image/icon/right.png" mode="aspectFit" />
            </view>
          </view>

          <view class="content" v-if="policy!=undefined">
            <view class="pitem">
              <view class="pileft"> <text class="pdesc">入住/离开</text> </view>
              <view class="piright"><text class="ptext">入住日14:00后入住，离店日12:00前离开(以当地城市时区为准)。</text></view>
            </view>
            <view class="pitem">
              <view class="pileft"><text class="pdesc">在线押金</text></view>
              <view class="piright">
                <text class="ptext" v-if="policy.deposit==0">不收取押金</text>
                <text class="ptext" v-else>收取押金{{policy.deposit}}元</text>
              </view>
            </view>
            <view class="pitem">
              <view class="pileft"><text class="pdesc">加客费用</text></view>
              <view class="piright">
                <text class="ptext" v-if="policy.allowaddguests==0">不允许加客</text>
                <text class="ptext" v-else>加一人收取{{policy.allowaddguests}}元</text>
              </view>
            </view>
            <view class="pitem">
              <view class="pileft"><text class="pdesc">房东要求</text></view>
              <view class="piright ldrequire ">
                {{policy.ntkText}}
              </view>
            </view>
            <view class="pitem">
              <view class="pileft"><text class="pdesc">取消规则</text></view>
              <view class="piright">
                <text class="ptext cancle" v-if="policy.cancelpolicy==30">预订后30分钟内可以免费取消，30分钟后取消扣除所有费用</text>
                <text class="ptext cancle" v-else>入住前{{policy.cancelpolicy}}天可以免费取消，超过以后取消扣除所有费用</text>
              </view>
            </view>
          </view>
        </view>

        <!-- 开始写弹出层的部分 -->

        <!-- 预订须知弹出层 -->
        <view class="popup-wrapper">
          <uni-popup ref="ntkpopup" background-color="#fff">
            <view class="popup-content">
              <view class="popup-header">入住须知</view>
              <view class="policy ntkpopup">
                <view class="content" v-if="policy!=undefined">
                  <view class="pitem">
                    <view class="pileft"> <text class="pdesc">入住/离开</text> </view>
                    <view class="piright"><text class="ptext">入住日14:00后入住，离店日12:00前离开(以当地城市时区为准)。</text></view>
                  </view>
                  <view class="pitem">
                    <view class="pileft"><text class="pdesc">在线押金</text></view>
                    <view class="piright">
                      <text class="ptext" v-if="policy.deposit==0">不收取押金</text>
                      <text class="ptext" v-else>收取押金{{policy.deposit}}元</text>
                    </view>
                  </view>
                  <view class="pitem">
                    <view class="pileft"><text class="pdesc">加客费用</text></view>
                    <view class="piright">
                      <text class="ptext" v-if="policy.allowaddguests==0">不允许加客</text>
                      <text class="ptext" v-else>加一人收取{{policy.allowaddguests}}元</text>
                    </view>
                  </view>
                  <view class="pitem">
                    <view class="pileft"><text class="pdesc">房东要求</text></view>
                    <view class="piright ldrequire ">

                      <view v-for="(item, index) in policy.needtoknow" :key="index" class="ldrequire-item">
                        <span v-if="item=='1'">-允许{{ntkArr[index]}}；</span>
                        <span v-else>-不允许{{ntkArr[index]}}；</span>
                      </view>

                    </view>
                  </view>
                  <view class="pitem">
                    <view class="pileft"><text class="pdesc">取消规则</text></view>
                    <view class="piright">
                      <text class="ptext cancle" v-if="policy.cancelpolicy==30">预订后30分钟内可以免费取消，30分钟后取消扣除所有费用</text>
                      <text class="ptext cancle" v-else>入住前{{policy.cancelpolicy}}天可以免费取消，超过以后取消扣除所有费用</text>
                    </view>
                  </view>
                </view>
              </view>
            </view>

          </uni-popup>
        </view>

        <!-- 全部设施弹出层 -->
        <uni-popup ref="facpopup" background-color="#fff">

          <view class="popup-header">全部设施</view>
          <view class="facilitiesbrief facpop">
            <view class="content">
              <view class="fac-item" v-for="(group,index) in facilities" :key="index">
                <view class="left" v-if="group.items.length">
                  <view class="leftText">{{group.group}}</view>
                </view>
                <view class="right">
                  <view class="right-item" v-for="(item,index) in group.items" :key="index">
                    <image v-if="item.vaild" class="ico" src="../../static/image/icon/complete.png" mode="aspectFit" />
                    <image v-else class="ico" src="../../static/image/icon/clear.png" mode="aspectFit" />
                    <view class="desc">{{item.facName}}</view>
                  </view>
                  <i></i>
                </view>
              </view>
              <view class="facbottom"></view>
            </view>
          </view>

        </uni-popup>

        <!-- 房源特色弹出层 -->
        <uni-popup ref="feapopup" background-color="#fff">

          <view class="popup-header">特色周边</view>
          <view class="facilitiesbrief feapop" v-if="features.length!=0">
            <view class="swTop">
              <view v-for="(item,index) in features" :key="index" class="topItem" @click="changeIndex(index)" :class="{'itemAct':currentIndex1==index}">{{item.featuretype}}</view>
            </view>
            <view class="swContent">
              <view class="contentview" v-for="(item,i) in features" :key="i">
                <text v-if="currentIndex1===i">{{item.featurecontent}}</text>

              </view>
              <view class="facbottom"></view>
            </view>
          </view>

        </uni-popup>

      </view>
      <view class="bbottom"></view>

    </scroll-view>
    <wu-calendar ref="calendar" color="#fd6f10" :insert="false" :rangeSameDay="true" @confirm="calendarConfirm" mode="range" :selected="selected" :rangeHaveDisableTruncation="true" :startDate="`${currentTime.year}-${currentTime.month}-${currentTime.date}`"></wu-calendar>

    <view class="bottomBar">
      <view class="bbwrapper">
        <view class="avatarwrapper" v-if="avatars!=undefined" @click="calltel">
          <image class="avapic" :src="avatars.landLordAvatars" mode="aspectFit" />
          <view class="avatarText">咨询</view>
        </view>

        <view class="likewrapper" @click="likehouse">
          <image v-if="islike" class="like coloradd" src="../../static/image/icon/like.png" />
          <image class="like" v-if="!islike" src="../../static/image/icon/like-active.png" />
          <view class="likeText">收藏</view>
        </view>

        <view class="pricemoudle">
          <view class="pricewrapper">
            <text class="symbol">￥</text>
            <text class="discounprice">{{overview.discountprice}}</text>
            <text class="night">/晚</text>
            <del class="orgprice">￥{{overview.originalprice}}</del>
          </view>
          <view class="discoutMoudle">
            促销已减{{overview.originalprice-overview.discountprice}}元
          </view>
        </view>
        <view class="btnwrapper">
          <view class="bookingBtn" @click="toCheck">立即预订</view>
        </view>

      </view>
    </view>
    <view class="loading" v-if="isloading">
      <image class="loadingpic" src="../../static/image/icon/loading.gif" mode="aspectFit" />
    </view>
  </view>

</template>

<script>
import API from '../../static/data/API.js';
export default {
  data() {
    return {
      hid: 0,
      overview: {},
      houseImg: [],
      idd: 0,
      currentPic: 1,
      policies: {},
      ratePic: '',
      currentDay: {},
      addressMoudle: [],
      locationInfo: {},
      startTime: {},
      endTime: {},
      stayRange: 1,
      facilities: [],
      facilitiesbrief: [],
      facilitiesCount: 0,
      bedMsg: [],
      commentBrief: null,
      commentImages: [],
      avatars: undefined,
      features: [],
      policy: undefined,
      ntkArr: ['接待婴儿', '接待儿童', '接待老人', '接待外宾', '带宠物', '吸烟', '做饭', '聚会', '商业拍摄'],
      currentIndex1: 0,
      selected: [],
      isloading: false,
      scrollThreshold: 140,
      isFixed: false,
      islike: false,
      count: 0,
      currentTime: {},
      tel: 0
    }
  },
  onPageScroll(event) {
    if (event.scrollTop > this.scrollThreshold) {
      this.isFixed = true
      try {
        this.$nextTick(() => {
          plus.navigator.setStatusBarStyle('dark')
        })
      } catch (error) {
        console.log(err)
      }
    } else {
      this.isFixed = false
      try {
        this.$nextTick(() => {
          plus.navigator.setStatusBarStyle('light')
        })
      } catch (error) {
        console.log(err)
      }
    }
  },
  methods: {
    calltel() {
      uni.makePhoneCall({
        phoneNumber: this.tel,
        success: function () {
          console.log('拨打电话成功！')
        },
        fail: function (error) {
          console.error('拨打电话失败：', error)
        }
      })
    },
    calendarConfirm(e) {
      if (e.range.before == '' || e.range.after == '') {
        return
      }

      if (e.range.data.length >= 1) {
        this.stayRange = e.range.data.length - 1
      }
      this.startTime = this.getTime(new Date(e.range.before))
      this.endTime = this.getTime(new Date(e.range.after))
      uni.setStorageSync('startTime', this.startTime)
      uni.setStorageSync('endTime', this.endTime)
      uni.setStorageSync('stayRange', this.stayRange)
      console.log(this.startTime)
      console.log(this.endTime)
    },
    swiperChange(event) {
      this.currentPic = event.detail.current + 1
    },
    handleRatePic() {
      let rate = this.overview.rating
      if (rate <= 0.5) {
        this.ratePic = `../../static/image/rating${0.5}.png`
      } else if (rate <= 1.0) {
        this.ratePic = `../../static/image/rating${1.0}.png`
      } else if (rate <= 1.5) {
        this.ratePic = `../../static/image/rating${1.5}.png`
      } else if (rate <= 2.0) {
        this.ratePic = `../../static/image/rating${2.0}.png`
      } else if (rate <= 2.5) {
        this.ratePic = `../../static/image/rating${2.5}.png`
      } else if (rate <= 3.0) {
        this.ratePic = `../../static/image/rating${3.0}.png`
      } else if (rate <= 3.5) {
        this.ratePic = `../../static/image/rating${3.5}.png`
      } else if (rate <= 4.0) {
        this.ratePic = `../../static/image/rating${4.0}.png`
      } else if (rate <= 4.5) {
        this.ratePic = `../../static/image/rating${4.5}.png`
      } else if (rate <= 5.0) {
        this.ratePic = `../../static/image/rating${5.0}.png`
      }
    },
    getHouseData(id) {
      this.isloading = true
      return new Promise((resolve, reject) => {
        uni.request({
          url: `${API.BASE_URL}/getHouseByHouseid`, //仅为示例，并非真实接口地址。
          data: {
            houseid: id,
            userid: uni.getStorageSync('userId')
          },
          success: res => {
            if (res.data.requestStatus == '200') {
              const resoureData = res.data.data
              console.log(resoureData)
              this.overview = resoureData.houseOverview
              this.overview.rating = this.overview.rating.toFixed(1)
              this.handleRatePic()
              if (this.overview.commentcount >= 500) {
                this.overview.commentcount = '500+'
              }
              this.houseImg = resoureData.houseImgs
              this.policies = resoureData.policies
              this.locationInfo = resoureData.location
              this.facilities = resoureData.facilities
              this.handlefacilitiesOverview(this.facilities)
              this.countFac()
              this.handleBedMsg()
              const cb = JSON.stringify(resoureData.commentBrief)
              if (cb != '{}') {
                this.handleComBrf(resoureData.commentBrief.commentContent)
                if (resoureData.commentBrief.hasimage) {
                  if (resoureData.commentBrief.commentImages.length >= 5) {
                    this.commentImages = resoureData.commentBrief.commentImages.slice(0, 5)
                  } else {
                    this.commentImages = resoureData.commentBrief.commentImages
                  }
                } else {
                  this.commentImages = []
                }
              } else {
                this.commentBrief = null
              }

              this.avatars = resoureData.avatars

              this.features = resoureData.features

              this.policy = resoureData.policies
              this.policy.needtoknow = this.policy.needtoknow.split('')
              this.handlePolicyText()
              this.selected = resoureData.bookingTimeList
              this.islike = resoureData.islike
              this.tel = resoureData.landlordTel
              resolve(res.data.data.location.location)
            }
            reject('请求失败')
          }
        })
      })
    },
    getTransportInfo(location) {
      uni.request({
        url: 'https://restapi.amap.com/v3/geocode/regeo',
        data: {
          key: 'ca5638622884957be4cff8d31d00b1b0',
          location: location,
          poitype: '150100|150200|150300|150400|150500|150600|150700|150800|150900',
          radius: 3000,
          extensions: 'all'
        },
        success: res => {
          if (res.data.info == 'OK') {
            const poi = res.data.regeocode.pois[0]
            poi.distance = Math.round(parseFloat(poi.distance))
            this.addressMoudle.push(poi)
          }
        }
      })
      uni.request({
        url: 'https://restapi.amap.com/v3/geocode/regeo',
        data: {
          key: 'ca5638622884957be4cff8d31d00b1b0',
          location: location,
          poitype: '110000',
          radius: 3000,
          extensions: 'all'
        },
        success: res => {
          if (res.data.info == 'OK') {
            const poi = res.data.regeocode.pois[0]
            poi.distance = Math.round(parseFloat(poi.distance))
            this.addressMoudle.push(poi)
          }
        }
      })
    },
    async fetchData(id) {
      const data = await this.getHouseData(id)
      console.log(data)
      this.getTransportInfo(data)
    },
    countFac() {
      this.facilities.forEach(element => {
        element.items.forEach(element2 => {
          if (element2.vaild) {
            this.facilitiesCount++
          }
        })
      })
    },
    handlefacilitiesOverview(data) {
      let newfb = data.slice(0, 4)
      newfb.forEach(element => {
        const obj = {
          group: '',
          items: []
        }
        obj.group = element.group
        for (let index = 0; index < 6; index++) {
          if (element.items[index] == undefined) {
            return false
          }
          if (element.items[index].vaild) {
            obj.items.push(element.items[index])
          }
        }
        this.facilitiesbrief.push(obj)
      })
    },
    handleBedMsg() {
      if (this.overview.bed218 != 0) {
        this.bedMsg.push({
          bedDesc: '双人床 2.00m × 1.80m',
          count: this.overview.bed218
        })
      }
      if (this.overview.bed215 != 0) {
        this.bedMsg.push({
          bedDesc: '大床 2.00m × 1.50m',
          count: this.overview.bed215
        })
      }
      if (this.overview.bed212 != 0) {
        this.bedMsg.push({
          bedDesc: '单人床 2.00m × 1.20m',
          count: this.overview.bed212
        })
      }
      if (this.overview.tatami != '') {
        const arr = this.overview.tatami.split(',')
        this.bedMsg.push({
          bedDesc: '榻榻米 ' + arr[0],
          count: arr[1]
        })
      }
    },
    handleComBrf(data) {
      let arr = []
      arr.push({
        desc: '整洁卫生',
        rating: data.cleanliness.toFixed(1)
      })
      arr.push({
        desc: '描述相符',
        rating: data.accuracy.toFixed(1)
      })

      arr.push({
        desc: '交通位置',
        rating: data.locationtransport.toFixed(1)
      })
      arr.push({
        desc: '安全程度',
        rating: data.safety.toFixed(1)
      })
      arr.push({
        desc: '性价比',
        rating: data.valueformmoney.toFixed(1)
      })
      delete data.cleanliness
      delete data.accuracy
      delete data.locationtransport
      delete data.safety
      delete data.valueformmoney
      data.rating = data.rating.toFixed(1)
      data.rateDetail = arr

      data.commenttime = this.getTime(new Date(data.commenttime))
      this.commentBrief = data
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
    handlePolicyText() {
      let str = ''
      for (let i = 0; i < this.policy.needtoknow.length; i++) {
        if (this.policy.needtoknow[i] == '1') {
          str = str + `允许${this.ntkArr[i]}；`
        } else {
          str = str + `不允许${this.ntkArr[i]}；`
        }
      }
      this.policy.ntkText = str
    },
    openntkPopup() {
      // open 方法传入参数 等同在 uni-popup 组件上绑定 type属性
      this.$refs.ntkpopup.open('bottom')
    },
    openfacPopup() {
      // open 方法传入参数 等同在 uni-popup 组件上绑定 type属性
      this.$refs.facpopup.open('bottom')
    },
    openfeaPopup() {
      this.$refs.feapopup.open('bottom')
    },
    changeIndex(i) {
      this.currentIndex1 = i
    },
    nvgToMapview() {
      uni.navigateTo({
        url: `/pages/mapView/mapView?location=${this.locationInfo.location}`
      })
    },
    goGallery() {
      uni.navigateTo({
        url: `/pages/picDetail/picDetail`
      })
      uni.$emit('sendPicList', this.houseImg)
    },
    toComDet() {
      uni.navigateTo({
        url: `/pages/getFullComment/getFullComment?total=${this.overview.commentcount}&houseid=${this.overview.houseid}`
      })
    },
    openLD() {
      uni.navigateTo({
        url: `/pages/landLordDetail/landLordDetail?landlordid=${this.overview.landlordid}`
      })
    },
    openCalendar() {
      this.$refs.calendar.open()
    },
    naback() {
      uni.navigateBack()
    },
    likehouse() {
      this.islike = !this.islike
      uni.request({
        url: `${API.BASE_URL}/favorHouse`,
        data: {
          houseid: this.overview.houseid,
          userid: uni.getStorageSync('userId')
        }
      })
    },
    toCheck() {
      const overview = this.overview
      const policy = this.policy
      uni.navigateTo({
        url: `/pages/commitOrder/commitOrder?houseid=${overview.houseid}&housename=${overview.housename}&houseType=${overview.rentaltype}&maxPeople=${overview.maxguests}&roomcount=${overview.roomcount}&bathcount=${overview.bathroomcount}&cancleRule=${policy.cancelpolicy}&deposit=${policy.deposit}&price=${overview.discountprice}&oprice=${overview.originalprice}&lid=${overview.landlordid}`
      })
    }
  },
  onLoad: async function (option) {
    this.currentTime = this.getTime(new Date())
    try {
      this.$nextTick(() => {
        plus.navigator.setStatusBarStyle('light')
      })
    } catch (error) {
      console.log(err)
    }
    // this.idd=option.index
    this.hid = option.houseid
    await this.fetchData(option.houseid)
    this.isloading = false
    this.startTime = uni.getStorageSync('startTime')
    this.endTime = uni.getStorageSync('endTime')
    this.stayRange = uni.getStorageSync('stayRange')
    this.currentDay = this.getTime(new Date())
  },
  mounted() {
    // 设置状态栏文字颜色为白色，背景颜色为黑色
    try {
      this.$nextTick(() => {
        plus.navigator.setStatusBarStyle('light')
      })
    } catch (error) {
      console.log(err)
    }
  },

  onBackPress(options) {
    console.log(this.overview)
    let hid = this.overview.houseid
    const obj = { hid: hid, islike: this.islike }
    uni.$emit('changeid', obj)
    if (options.from === 'navigateBack') {
      return false
    }
    uni.navigateBack()
    return true
  }
}
</script>

<style lang="less">
.statusbar {
  width: 100vw;
  height: var(--status-bar-height);
  background-color: rgba(255, 255, 255, 0);
  position: fixed;
  top: 0;
  left: 0;
  z-index: 10;
}
.topbar {
  width: 100vw;
  background-color: rgba(255, 255, 255, 0);
  height: 80rpx;
  position: fixed;
  top: var(--status-bar-height);
  left: 0;
  z-index: 10;
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

.detailParent {
  // height: 100vh;
  width: 100vw;
}
.swiper-wrap {
  width: 100vw;
  height: 500rpx;
  position: relative;
  .houseImgs {
    width: 100vw;
    height: 500rpx;
  }
  .swiper {
    height: 500rpx;
  }
  .indicator {
    position: absolute;
    bottom: 48rpx;
    left: 50%;
    transform: translateX(-50%);
    background-color: rgba(17, 17, 17, 0.644);
    color: rgb(194, 194, 194);
    width: 80rpx;
    height: 42rpx;
    border-radius: 9999px;
    text-align: center;
    line-height: 42rpx;
    font-size: 22rpx;
    font-weight: bold;
  }
}

.swiper-item {
  height: 400rpx;
}

// 概览样式
.overview {
  position: relative;
  padding: 0 30rpx;
  &::before {
    content: '';
    position: absolute; /* 相对于父元素定位 */
    left: 0;
    top: -46rpx;
    height: 30rpx;
    width: 100vw;
    border-radius: 999px 999px 0 0;
    background: #fff;
  }

  .houseName {
    margin-top: 20rpx;
    display: flex;
    height: 105rpx;
    .left {
      font-weight: bold;
      width: 75%;
      height: auto;
      display: -webkit-box;
      -webkit-box-orient: vertical;
      overflow: hidden;
      text-overflow: ellipsis;
      -webkit-line-clamp: 2; /* 指定显示的行数 */
      font-size: 40rpx;
    }
    .right {
      flex: 1;
      position: relative;
      height: 100%;
      .rating {
        bottom: 0;
        left: 50%;
        transform: translate(-50%);
        position: absolute;
        background-color: #eff3fe;
        height: 200rpx;
        width: 150rpx;
        border-radius: 30rpx;
        text-align: center;

        .rate {
          font-size: 45rpx;
          font-weight: bold;
          color: #1eb5be;
          margin-top: 20rpx;
        }
        .ratePic {
          width: 90rpx;
          height: 24rpx;
          position: relative;
        }
        .colorblock {
          position: absolute; /* 相对于父元素定位 */
          left: 50%;
          transform: translate(-50%);
          top: 124rpx;
          height: 6rpx;
          width: 24rpx;
          background: rgb(22, 22, 22);
        }
        .commentCount {
          font-size: 20rpx;
          font-weight: bold;
          margin-top: 20rpx;
          color: #1f2326;
        }
      }
    }
  }

  .houseInfo {
    width: 100%;
    display: flex;
    margin-top: 34rpx;
    justify-content: space-between;
    .info-item {
      width: 32%;
      height: 160rpx;
      border-radius: 16rpx;
      background-color: #f7f8fa;
      text-align: center;
      .icowrapper {
        margin-left: 50%;
        transform: translateX(-50%);
        margin-top: 20rpx;
        width: 50rpx;
        height: 50rpx;
        border: 1px solid #222431;
        border-radius: 999rpx;
        display: flex;
        align-items: center;
        justify-content: space-evenly;
        position: relative;
        .ico {
          position: absolute;
          width: 34rpx;
          height: 34rpx;
          z-index: 20;
        }
        .colorblock {
          border-radius: 999rpx;
          background-color: #d2d8f2;
          position: absolute;
          width: 24rpx;
          height: 24rpx;
          top: 20rpx;
          z-index: 0;
        }
      }
    }
    .roomico {
      width: 30rpx !important;
      height: 30rpx !important;
    }

    .textBlack {
      font-weight: bold;
      font-size: 26rpx;
      margin-top: 5rpx;
    }
    .textGray {
      font-weight: bold;
      font-size: 20rpx;
      color: #6a6b6d;
      margin-top: 5rpx;
    }
    .bedCount {
      .attentionIco {
        width: 28rpx;
        height: 28rpx;
        margin-left: -3rpx;
      }
    }
  }

  .addresswrapper {
    width: 100%;
    height: 160rpx;
    border-radius: 16rpx;
    margin-top: 20rpx;
    background: url('../../static/image/map_bg.png');
    background-size: contain; /* 图片将被缩放以填充整个容器，可能会被裁剪 */
    background-position: center right; /* 图片在容器中的位置，可以使用像素值或百分比 */
    background-repeat: no-repeat; /* 禁止图片重复 */
    background-color: #f6f7fb;
    overflow: hidden;
    position: relative;
    .textBlack {
      font-weight: bold;
      color: #1f2326;
      font-size: 28rpx;
      margin-top: 20rpx;
      padding-left: 20rpx;
      width: 70%;
      white-space: nowrap;
      text-overflow: ellipsis;
      overflow: hidden;
    }
    .textGray {
      margin-top: 5rpx;
      font-weight: bold;
      color: #6a6b6d;
      font-size: 24rpx;
      padding-left: 20rpx;
    }
    .toMap {
      position: absolute;
      display: flex;
      right: 55rpx;
      top: 50%;
      transform: translateY(-50%);
      flex-direction: column;
      justify-content: center; /* 在主轴上居中 */
      align-items: center; /* 在交叉轴上居中 */
      .ico {
        width: 34rpx;
        height: 34rpx;
      }
      .text {
        margin-top: 4rpx;
        font-weight: bold;
        font-size: 22rpx;
      }
    }

    .rightarrow {
      position: absolute;
      display: flex;
      right: 10rpx;
      top: 50%;
      transform: translateY(-50%);
      flex-direction: column;
      justify-content: center; /* 在主轴上居中 */
      align-items: center; /* 在交叉轴上居中 */
      .ico {
        width: 34rpx;
        height: 34rpx;
      }
    }
  }

  .checkDate {
    position: relative;
    width: 100%;
    height: 100rpx;
    border-radius: 16rpx;
    background-color: #ff741e15;
    margin-top: 20rpx;
    line-height: 100rpx;
    .date {
      font-weight: bold;
      font-size: 36rpx;
      margin-left: 16rpx;
    }
    .desc {
      font-weight: bold;
      color: #6a6b6d;
      font-size: 24rpx;
      margin-left: 16rpx;
    }

    .right {
      position: absolute;
      display: flex;
      right: 10rpx;
      top: 0;
      align-items: center; /* 在交叉轴上居中 */
      .ico {
        width: 34rpx;
        height: 34rpx;
        filter: contrast(0%) grayscale(100%);
      }
      .stayRange {
        font-weight: bold;
        font-size: 28rpx;
      }
    }
  }

  .facilitiesbrief {
    margin-top: 15rpx;
    width: 100%;
    .content {
      border: 1px solid #f4f4f5;
      border-radius: 16rpx;
      min-height: 200rpx;
      .fac-item {
        display: flex;
        justify-content: space-between;
        margin-top: 10rpx;
        .left {
          width: 110rpx;
          font-weight: bold;
          .leftText {
            margin-left: 26rpx;
            margin-top: 20rpx;
            font-size: 28rpx;
          }
        }
        .right {
          flex: 1;
          display: flex;
          justify-content: space-between;
          flex-wrap: wrap;
          i {
            width: 32%;
          }
          .right-item {
            width: 32%;
            display: flex;
            align-items: center;
            height: 50rpx;
            margin-top: 8rpx;
            .ico {
              width: 25rpx;
              height: 25rpx;
            }
            .desc {
              font-size: 24rpx;
              font-weight: bold;
              color: #6a6b6d;
              white-space: nowrap;
              text-overflow: ellipsis;
              overflow: hidden;
              margin-left: 4rpx;
            }
          }
        }
      }
    }
  }

  .bedDetail {
    margin-top: 15rpx;
    width: 100%;
    .content {
      border: 1px solid #f4f4f5;
      border-radius: 16rpx;
      min-height: 40rpx;
      padding: 30rpx 20rpx;
      font-weight: bold;
      .beditem {
        display: flex;
        height: 40rpx;
        line-height: 40rpx;
        font-size: 28rpx;
      }
      .left {
        color: #6a6b6d;
      }
      .right {
        font-weight: normal;
        margin-left: 50rpx;
        color: #ff7417;
      }
    }
  }

  .commentBrief {
    margin-top: 15rpx;
    width: 100%;

    .content {
      border: 1px solid #f4f4f5;
      border-radius: 16rpx;
      overflow: hidden;
      .top {
        width: 100%;
        height: 180rpx;
        background-color: #edf4fe;
        box-sizing: border-box;
        padding: 20rpx 30rpx;
        vertical-align: bottom;
        .rate {
          .finalRate {
            color: #1eb5be;
            font-weight: bold;
            font-size: 54rpx;
          }
          .ratePic {
            width: 120rpx;
            height: 30rpx;
            margin-bottom: -4rpx;
            margin-left: 8rpx;
          }
          .totalCommentCount {
            font-weight: bold;
            font-size: 22rpx;
            margin-left: 10rpx;
          }
        }

        .rateDetail {
          width: 89%;
          display: flex;
          flex-wrap: wrap;
          font-size: 22rpx;
          font-weight: bold;
          .rateDetail-item {
            height: 34rpx;
            line-height: 34rpx;
            width: 33%;
            .sRate {
              margin-left: 10rpx;
            }
          }
        }
      }
      .nbottom {
        padding: 0 20rpx;
        .avatar {
          display: flex;
          width: 100%;
          margin-top: 15rpx;

          .avatar-left {
            width: 100rpx;
            height: 100rpx;
            background-color: rgb(199, 131, 131);
            border-radius: 9999px;
            overflow: hidden;
            .avatarPic {
              width: 100rpx;
              height: 100rpx;
            }
          }
          .avatar-right {
            flex: 1;
            margin-left: 20rpx;
            .nickname {
              font-weight: bold;
              white-space: nowrap;
              overflow: hidden;
              text-overflow: ellipsis;
            }
            .tar {
              display: flex;
              font-size: 24rpx;
              font-weight: bold;
              .time {
                color: #6a6b6d;
              }
              .userrate {
                color: #fff;
                background-color: #ff7417;
                padding: 0 10rpx;
                margin-left: 30rpx;
                border-radius: 5rpx;
                position: relative;
                &::after {
                  content: '';
                  position: absolute; /* 相对于父元素定位 */
                  left: -8rpx;
                  top: 50%;
                  transform: translateY(-50%);
                  width: 0;
                  height: 0;
                  border-top: 10rpx solid transparent; /* 上边框设置为透明 */
                  border-right: 10rpx solid #ff7417; /* 右边框设置为实色 */
                  border-bottom: 10rpx solid transparent; /* 下边框设置为透明 */
                }
              }
            }
          }
        }
        .commentContent {
          font-weight: bold;
          font-size: 28rpx;
          margin-top: 20rpx;
          display: -webkit-box;
          -webkit-box-orient: vertical;
          overflow: hidden;
          text-overflow: ellipsis;
          -webkit-line-clamp: 2; /* 指定显示的行数 */
        }
        .picWrapper {
          display: flex;
          flex-wrap: wrap;
          margin-top: 20rpx;
          margin-bottom: 20rpx;
          justify-content: space-between;
          i {
            width: 120rpx;
          }
          .comPic {
            width: 120rpx;
            height: 120rpx;
            border-radius: 16rpx;
          }
        }
      }
    }
  }

  .features {
    margin-top: 15rpx;
    width: 100%;
    .content {
      width: 100%;
      border: 1px solid #f4f4f5;
      border-radius: 16rpx;
    }
    .contentText {
      margin: 10rpx 20rpx;

      white-space: pre-wrap;
      font-weight: bold;
      display: -webkit-box;
      -webkit-box-orient: vertical;
      overflow: hidden;
      text-overflow: ellipsis;
      -webkit-line-clamp: 2; /* 指定显示的行数 */
      line-clamp: 2;
      font-size: 26rpx;
      overflow: hidden;
    }
  }
  .landLord {
    margin-top: 15rpx;
    width: 100%;
    .content {
      width: 100%;
      border: 1px solid #f4f4f5;
      border-radius: 16rpx;
      .contentWrapper {
        margin: 30rpx 24rpx;
        display: flex;
        .left {
          width: 100rpx;
          height: 100rpx;
          // background-color: rgb(221, 221, 221);
          overflow: hidden;
          border-radius: 1111px;
          .lavatar {
            width: 100rpx;
            height: 100rpx;
          }
        }
        .right {
          flex: 1;
          margin-left: 40rpx;
          font-weight: bold;
          .nickname {
            font-size: 34rpx;
          }
          .text {
            font-size: 24rpx;
            color: #6a6b6d;
          }
        }
      }
    }
  }

  .policy {
    margin-top: 15rpx;
    width: 100%;
    .content {
      width: 100%;
      border: 1px solid #f4f4f5;
      border-radius: 16rpx;
      font-weight: 900;
      .pitem {
        display: flex;
        margin: 28rpx;
        .pileft {
          width: 200rpx;
          font-size: 28rpx;
        }
        .piright {
          flex: 1;
          color: #787879;
          font-size: 26rpx;
        }
        .cancle {
          font-family: 'Arial', 'Helvetica', sans-serif;
          color: #fd6f10;
        }
        .ldrequire {
          white-space: nowrap;
          text-overflow: ellipsis;
          overflow: hidden;
        }
      }
    }
  }

  .title {
    .Tips {
      font-size: 24rpx;
    }
    display: flex;
    justify-content: space-between;
    width: 100%;
    height: 100rpx;
    line-height: 100rpx;
    .left {
      font-weight: 900;
      font-size: 36rpx;
    }

    .right {
      display: flex;
      align-items: center;
      .desc {
        font-weight: bold;
        font-size: 24rpx;
        color: #6a6b6d;
      }

      .ico {
        width: 34rpx;
        height: 34rpx;
      }
    }
  }

  .ntkpopup {
    margin-top: 0;
    .ldrequire-item {
      margin: 20rpx 0;
    }
  }

  .facpop {
    margin-top: 0;
    height: 1100rpx;
    .content {
      overflow-y: auto;
      height: 1060rpx;
      .facbottom {
        height: 40rpx;
      }
    }
  }

  .feapop {
    margin-top: 0;
    height: 1100rpx;
    position: relative;
    overflow: hidden;
    .swTop {
      display: flex;
      position: absolute;
      left: 50%;
      transform: translate(-50%);
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
      margin-top: 75rpx;
      width: 100vw;
      overflow-y: auto;
      height: 1060rpx;
      .contentview {
        width: 90%;
        margin: auto;
        font-weight: bold;
        font-size: 28rpx;
        white-space: pre-wrap;
      }

      .facbottom {
        height: 40rpx;
      }
    }
  }
  .popup-header {
    font-weight: 900;
    text-align: center;
    height: 100rpx;
    font-size: 40rpx;
    line-height: 100rpx;
  }
}

.bbottom {
  height: 200rpx;
}

.loading {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  .loadingpic {
    width: 60rpx;
    height: 60rpx;
  }
}
.bottomBar {
  border-top: 1px solid rgb(248, 248, 248);
  background-color: rgb(255, 255, 255);
  width: 100%;
  height: 130rpx;
  position: fixed;
  bottom: 0;
  box-shadow: 2px -2px 14px 0 rgba(0, 0, 0, 0.055);
  .bbwrapper {
    color: #1f2326;
    display: flex;
    padding: 10rpx 28rpx;
    align-items: bottom;
    vertical-align: bottom;
    .avatarwrapper {
      display: flex;
      flex-direction: column;
      align-items: center;
      margin-top: 20rpx;
      width: 100rpx;
      .avapic {
        width: 45rpx;
        height: 45rpx;
        overflow: hidden;
        border-radius: 999px;
      }
      .avatarText {
        font-size: 22rpx;
        font-weight: bold;
      }
    }
    .likewrapper {
      display: flex;
      flex-direction: column;
      margin-top: 20rpx;
      width: 100rpx;
      margin-left: 15rpx;
      .like {
        width: 45rpx;
        height: 45rpx;
      }

      .coloradd {
        filter: brightness(0.3);
      }
      .likeText {
        font-size: 22rpx;
        font-weight: bold;
        color: #333;
      }
    }

    .pricemoudle {
      display: flex;
      flex-direction: column;
      margin-top: 12rpx;
      .pricewrapper {
        font-weight: 900;
        .symbol {
          font-size: 20rpx;
          color: rgba(254, 117, 21, 1);
        }
        .night {
          font-size: 20rpx;
        }
        .discounprice {
          font-size: 38rpx;
          color: rgba(254, 117, 21, 1);
        }
        .orgprice {
          font-size: 20rpx;
          color: #c2c5c9;
          margin-left: 6rpx;
        }
      }

      .discoutMoudle {
        color: rgba(254, 117, 21, 1);
        font-weight: bold;
        font-size: 23rpx;
        height: 30rpx;
        line-height: 30rpx;
        line-height: 30rpx;
        background-color: rgba(254, 118, 21, 0.116);
        width: auto;
        border-radius: 100rpx;
        text-align: center;
      }
    }
    .btnwrapper {
      flex: 1;

      .bookingBtn {
        margin: 15rpx 0 auto auto;
        width: 100px;
        height: 80rpx;
        text-align: center;
        border-radius: 999rpx;
        line-height: 80rpx;
        font-weight: 900;
        color: #fff;
        background-color: rgba(254, 117, 21, 1);
      }
    }
  }
}
.bgwhite {
  background-color: #fff !important;
}
.navigatorbar {
  position: fixed;
  background-color: rgb(204, 86, 86);
  top: 80rpx;
}
</style>
