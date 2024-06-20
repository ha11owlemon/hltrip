<template>
  <view class="rt">
    <view class="statusbar"></view>
    <view class="topbar">
      <view class="left" @click="naback">
        <image class="topbar-icon leftIco" src="../../static/image/icon/back_balck.png" mode="aspectFit" />
      </view>
      <view class="right">
      </view>
    </view>
    <scroll-view scroll-y class="content">
      <view class="orderstatus">
        {{ostatus}}
        <view class="countdown" v-if="ostatus=='待支付'"><text class="countTime">{{countdownTime}}</text>&nbsp;<text class="desc">后失效</text></view>
      </view>
      <view class="tips" v-if="ostatus=='待支付'">未支付订单可能被他人抢订，请尽快完成支付!</view>
      <view class="hinfo">
        <view class="checkTime">
          <view class="left">
            <view class="desc">入离时间</view>
            <view class="checkIn">{{startTime.month}}-{{startTime.date}}</view>
            <view class="sep1">-·-</view>
            <view class="checkOut">{{endTime.month}}-{{endTime.date}}</view>
          </view>
          <view class="right">共{{stayRange}}晚</view>
        </view>
      </view>
      <view class="rentpeople">
        <view class="title">
          <view class="desc">入住人信息</view>
        </view>
        <view class="mb"></view>
        <view class="peopleList">
          <view class="listItem" v-for="(item,index) in sList">
            <view class="rname">{{item.realname}}</view>
            <view class="idnum">
              身份证&nbsp;{{item.idnumber}}
            </view>
          </view>
        </view>
      </view>
      <view class="price">
        <view class="coverItem">
          <view class="left">
            <image class="cover" :src="coverurl" mode="aspectFill" />
          </view>
          <view class="right">
            <view class="housename">{{housename}}</view>
            <view class="facbrief">
              <view class="type">{{houseType}}</view>
              <view class="sep">&nbsp;·&nbsp;</view>
              <view class="roomcount">{{roomcount}}室{{bathcount}}卫</view>
              <view class="sep">&nbsp;·&nbsp;</view>
              <view class="pcount">宜居{{maxPeople}}人</view>
            </view>
          </view>
        </view>
        <view class="item">
          <view>房费&nbsp;{{stayRange}}&nbsp;晚</view>
          <view class="totalprice">￥{{oprice*stayRange}}</view>
        </view>
        <view class="item">
          <view class="left">押金</view>
          <view class="right">￥{{deposit}}</view>
        </view>
        <view class="item">
          <view class="left">专享优惠</view>
          <view class="right orange">￥{{stayRange*(oprice-price)}}</view>
        </view>
        <view class="item mt10">
          <view class="left"></view>
          <view class="right">本单您需要支付&nbsp;￥<text class="total">{{(price*stayRange)+deposit}}</text></view>
        </view>
      </view>

      <view class="provider">
        <view class="pitem">
          <view class="left">支付方式</view>
          <view class="right">
            <image src="../../static/image/icon/alipay.png" mode="aspectFit" class="ali" />
            <view>支付宝支付</view>
          </view>
        </view>
        <view class="pitem1">
          <view class="left">发票</view>
          <view class="right">离店当日12:00后，可申请开票</view>
        </view>
      </view>

      <view class="orderMsg">
        <view class="title">订单信息</view>
        <view class="ordernum">订单编号:&nbsp;{{orderNum}}</view>
        <view class="ordernum">下单时间:&nbsp;{{orderTime.year}}.{{orderTime.month}}.{{orderTime.date}}&nbsp;{{orderTime.hour}}:{{orderTime.minute}}:{{orderTime.seconds}}</view>
      </view>

      <view class="tipsbottom">
        <view class="item">入住时间:14:00后可入住，12:00之前需退房</view>
        <view class="item">温馨提示:您未到店或未入住时，如需联系房东商家，请使用平台在线聊天工具。请勿轻易线下转账方式支付押金或其他费用，以免上当受骗。</view>
      </view>
      <view class="mblock"></view>
    </scroll-view>
    <view class="bottomBar" v-if="ostatus=='待支付'">
      <view class="bbwrapper">
        <view class="cancleorder" @click="tapCancle">
          取消订单
        </view>
        <view class="btnwrapper">
          <view class="bookingBtn" @click="topay">去支付</view>
        </view>

      </view>
    </view>
    <uni-popup ref="alertDialog" type="dialog">
      <uni-popup-dialog type="error" cancelText="按错了" confirmText="确定" title="通知" content="确定要取消该订单吗" @confirm="canaleOrder"></uni-popup-dialog>
    </uni-popup>
  </view>
</template>

<script>
import API from '../../static/data/API.js';
export default {
  data() {
    return {
      houseType: '',
      maxPeople: 0,
      roomcount: 0,
      bathcount: 0,
      housename: '',
      cancleRule: '30',
      deposit: 0,
      price: 0,
      oprice: 0,
      startTime: {},
      endTime: {},
      stayRange: 0,
      idinfo: [],
      sList: [],
      houseid: 0,
      lid: 0,
      orderNum: '',
      orderTime: {},
      coverurl: '',
      ostatus: '',
      endTimestamp: 0,
      timer:null
    }
  },
  methods: {
    pad(val) {
      return val < 10 ? `0${val}` : val
    },
    naback() {
      uni.navigateBack({
        delta: 1
      })
    },
    getInfo() {
      uni.request({
        url: `${API.BASE_URL}/getOrderInfo`, //仅为示例，并非真实接口地址。
        data: {
          orderNum: this.orderNum
        },
        success: res => {
          console.log(res.data)
          const rdata = res.data.data
          this.housename = rdata.overview.housename
          this.startTime = this.getTime(new Date(rdata.orderInfo.starttime))
          this.endTime = this.getTime(new Date(rdata.orderInfo.endtime))
          this.ostatus = rdata.orderInfo.ostatus
          this.sList = JSON.parse(rdata.orderInfo.guestinfo)
          this.bathcount = rdata.overview.bathroomcount
          this.roomcount = rdata.overview.roomcount
          this.houseType = rdata.overview.rentaltype
          this.maxPeople = rdata.overview.maxguests
          this.deposit = rdata.policy.deposit
          this.cancleRule = rdata.policy.cancelpolicy
          this.price = rdata.overview.discountprice
          this.oprice = rdata.overview.originalprice
          this.coverurl = rdata.overview.coverurl
		  const TimeObj=new Date(rdata.orderInfo.ordertime)
          this.orderTime = this.getTime(TimeObj)
		  this.orderTime.hour=TimeObj.getHours()
		  const padHour=TimeObj.getHours().toString().padStart(2,'0')
		  const padMinute=TimeObj.getMinutes().toString().padStart(2,'0')
		  const padSecond=TimeObj.getSeconds().toString().padStart(2,'0')
		  this.orderTime.hour=padHour
		  this.orderTime.minute=padMinute
		  this.orderTime.seconds=padSecond
          this.stayRange = this.calculateNightsBetweenTimestamps(this.endTime.timestamp, this.startTime.timestamp)

          if (this.ostatus == '待支付') {
            this.endTimestamp = this.orderTime.timestamp.getTime() + 30 * 60 * 1000
            const now = new Date().getTime()
            const timeIntervel = this.endTimestamp - now
            this.endTimestamp = timeIntervel
            this.timer = setInterval(() => {
              if (this.endTimestamp <= 0) {
                clearInterval(this.timer)
                this.ostatus = '已关闭'
              }
              this.endTimestamp = this.endTimestamp - 1000
            }, 1000)
          }
        }
      })
    },
    hideIDNumber(idNumber) {
      // 首先确保传入的是字符串
      idNumber = idNumber.toString()

      // 获取身份证号的长度
      var length = idNumber.length

      // 如果长度小于或等于10（不包括开头6位和结尾4位），直接返回原始字符串
      if (length <= 10) {
        return idNumber
      }

      // 隐藏中间的部分
      var hiddenPart = idNumber.substring(6, length - 4).replace(/\d/g, '*')

      // 拼接隐藏后的身份证号码
      var result = idNumber.substring(0, 6) + hiddenPart + idNumber.substring(length - 4, length)

      return result
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
    speople(e) {
      this.sList = e.detail.value
      console.log(this.sList)
    },
    toAddpage() {
      uni.navigateTo({
        url: '/pages/addCon_text/addCon_text'
      })
    },
    commitOrder() {},
    calculateNightsBetweenTimestamps(timestamp1, timestamp2) {
      let time1 = new Date(timestamp1)
      let time2 = new Date(timestamp2)

      // 将日期对象的时间部分设置为0，只保留日期部分
      time1.setHours(0, 0, 0, 0)
      time2.setHours(0, 0, 0, 0)

      // 计算相差的天数
      var diffDays = Math.floor((time1 - time2) / (1000 * 60 * 60 * 24))
      //  var diffDays = time1
      // 如果相差天数为负数，说明日期顺序错误，直接返回0晚
      if (diffDays < 0) {
        return 0
      }

      // 如果相差天数为0，则表示入住和离开是同一天，返回1晚
      if (diffDays === 0) {
        return 1
      }

      // 否则返回相差天数
      return diffDays
    },
    topay() {
      uni.navigateTo({
        url: `/pages/payment/payment?num=${this.orderNum}`
      })
    },
    tapCancle() {
      this.$refs.alertDialog.open()
    },
    canaleOrder() {
      uni.request({
        url: `${API.BASE_URL}/closeOrder`,
        data: {
          orderNum: this.orderNum
        },
        success: res => {
          this.getInfo()
        }
      })
    }
  },
  computed: {
    countdownTime() {
      if (!this.endTimestamp) {
        return '--:--:--'
      }

      if (this.endTimestamp > 0) {
        const hours = Math.floor((this.endTimestamp % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
        const minutes = Math.floor((this.endTimestamp % (1000 * 60 * 60)) / (1000 * 60))
        const seconds = Math.floor((this.endTimestamp % (1000 * 60)) / 1000)
        return `${this.pad(hours)}:${this.pad(minutes)}:${this.pad(seconds)}`
      } else {
        return '00:00:00'
      }
    }
  },
  onLoad(option) {
    this.orderNum = option.num
  },
  onShow() {
    console.log(111);
    this.timer=null
    this.getInfo()
  },
  beforeUnmount() {
    // 在组件卸载前清除定时器
    // clearInterval(this.timer);
    console.log("orderpay 销毁");
  }
}
</script >

<style lang="less">
.rt {
  background: #f6f7fb;
  width: 100vw;
  height: 100vh;
}
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
  padding: 20rpx 20rpx;
  box-sizing: border-box;
  .topbar-icon {
    vertical-align: bottom;
    width: 30rpx;
    height: 30rpx;
    margin-bottom: 5rpx;
  }

  .left {
    text-align: center;
    width: 40rpx;
    height: 40rpx;
  }

  .right {
    width: 40rpx;
    height: 40rpx;
  }
}
.content {
  position: fixed;
  left: 0;
  top: var(--status-bar-height);
  transform: translateY(80rpx);
  width: 100vw;
  height: 1500rpx;
  box-sizing: border-box;
  padding: 0 20rpx;
  .hinfo {
    width: 100%;

    background-color: #fff;
    border-radius: 16rpx;
    padding: 28rpx 23rpx;
    box-sizing: border-box;
    .checkTime {
      display: flex;
      justify-content: space-between;
      font-size: 26rpx;
      .left {
        display: flex;
        .desc {
          font-weight: 900;
          width: 130rpx;
        }
        .sep1 {
          margin-left: 10rpx;
          margin-right: 10rpx;
          font-weight: 900;
          color: #8f8f8f;
        }
        .checkIn,
        .checkOut {
          font-weight: bold;
        }
      }
      .right {
        font-weight: bold;
        font-size: 24rpx;
        color: #c2c2c2;
      }
    }
    .tips {
      color: #ac4103;
      font-weight: 900;
      font-size: 24rpx;
    }
  }
  .orderstatus {
    font-weight: 900;
    color: #333;
    font-size: 40rpx;
    margin-bottom: 30rpx;
    .countdown {
      color: #8f8f8f;
      font-size: 24rpx;
      margin-top: 10rpx;
      .countTime {
        color: #fa5c01;
      }
    }
  }
  .rentpeople {
    width: 100%;
    margin-top: 15rpx;
    background-color: #fff;
    border-radius: 16rpx;
    padding: 28rpx 23rpx;
    box-sizing: border-box;

    .title {
      display: flex;
      font-weight: 900;
      line-height: 30rpx;
      .desc {
        font-size: 26rpx;
      }
      .peoplecount {
        font-size: 24rpx;
        margin-left: 24rpx;
        color: #fa5c01;
      }
    }
    .selectPeople {
      margin-top: 24rpx;
      .checkgroup {
        display: flex;
        flex-wrap: wrap;
        .checkitem {
          width: 22%;
          font-size: 24rpx;
          height: 34rpx;
          padding: 0 0 10rpx;
          border: 1px solid #f6f7fb;
          border-radius: 4rpx;
          margin-right: 15rpx;
          .rname {
            font-weight: 900;
            line-height: 34rpx;
            margin-left: -10rpx;
          }
        }

        .addBtn {
          width: 22%;
          height: 34rpx;
          background-color: #ffeed4;
          padding: 0 0 10rpx;
          text-align: center;
          font-size: 24rpx;
          font-weight: 900;
          line-height: 44rpx;
          border-radius: 4rpx;
        }
      }
    }
    .mb {
      width: 100%;
      height: 24rpx;
      border-bottom: 1rpx dashed #f1f1f1;
    }
    .listItem {
      padding: 15rpx 10rpx;
      box-sizing: border-box;
      font-weight: 900;
      color: #333;
      .rname {
        font-size: 25rpx;
      }
      .idnum {
        margin-top: 4rpx;
        font-size: 22rpx;
      }
    }
  }
  .price {
    width: 100%;
    margin-top: 15rpx;
    background-color: #fff;
    border-radius: 16rpx;
    padding: 28rpx 23rpx;
    box-sizing: border-box;
    .item {
      display: flex;
      justify-content: space-between;
      font-size: 23rpx;
      font-weight: 900;
      padding: 10rpx 0;
      .orange {
        color: #fa5c01;
      }
      .total {
        font-size: 28rpx;
      }
    }
    .coverItem {
      display: flex;
      .left {
        .cover {
          width: 170rpx;
          height: 120rpx;
          background-color: rgb(185, 185, 185);
          border-radius: 14rpx;
          overflow: hidden;
        }
      }
      .right {
        .housename {
          font-size: 27rpx;
          text-overflow: ellipsis;
          overflow: hidden;
          white-space: nowrap;
          width: 80%;
          line-height: 40rpx;
          font-weight: 900;
          margin-top: 0rpx;
          margin-left: 12rpx;
          padding-right: 16rpx;
          box-sizing: border-box;
        }
        .facbrief {
          font-size: 22rpx;
          font-weight: 900;
          height: 40rpx;
          line-height: 40rpx;
          display: flex;
          margin-top: 5rpx;
          color: #8f8f8f;
          margin-left: 12rpx;
        }
      }
    }
    .mt10 {
      margin-top: 10rpx;
    }
  }
  .provider {
    width: 100%;
    margin-top: 15rpx;
    background-color: #fff;
    border-radius: 16rpx;
    padding: 28rpx 23rpx;
    box-sizing: border-box;

    font-size: 23rpx;
    font-weight: 900;
    vertical-align: top;
    .pitem {
      display: flex;
      justify-content: space-between;
      line-height: 60rpx;
      height: 60rpx;
      .right {
        display: flex;
        justify-content: center; /* 水平居中 */
        align-items: center; /* 垂直居中 */
        line-height: 30rpx;
        .ali {
          width: 30rpx;
          height: 30rpx;
          margin-right: 8rpx;
        }
      }
    }
    .pitem1 {
      margin-top: 10rpx;
      display: flex;
      justify-content: space-between;
      line-height: 60rpx;
      height: 60rpx;

      .right {
        color: #c2c2c2;
      }
    }
  }
  .orderMsg {
    width: 100%;
    margin-top: 15rpx;
    background-color: #fff;
    border-radius: 16rpx;
    padding: 28rpx 23rpx;
    box-sizing: border-box;
    font-size: 23rpx;
    font-weight: 900;
    .title {
      font-size: 26rpx;
      line-height: 50rpx;
    }
    .ordernum {
      line-height: 40rpx;
      color: #333;
    }
  }
  .tips {
    width: 100%;
    font-size: 24rpx;
    color: #fe7615;
    font-weight: 900;
    box-sizing: border-box;
    padding: 18rpx 23rpx;
    border-radius: 10rpx;
    background-color: #fc690013;
    margin-bottom: 10rpx;
  }
  .tipsbottom {
    width: 100%;
    margin-top: 15rpx;
    border-radius: 16rpx;
    padding: 28rpx 23rpx;
    box-sizing: border-box;
    font-size: 23rpx;
    font-weight: 900;
    color: #bebfc1;
    .item {
      margin-bottom: 10rpx;
    }
  }
  .mblock {
    width: 100%;
    height: 200rpx;
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
    .cancleorder {
      line-height: 80rpx;
      margin-top: 10rpx;
      font-weight: 900;
      color: #8f8f8f;
      font-size: 26rpx;
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
</style>
