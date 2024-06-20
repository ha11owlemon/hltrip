<template>
  <view class="rt">
    <view class="statusbar"></view>
    <view class="topbar">
      <view class="left" @click="naback">
        <image class="topbar-icon leftIco" src="../../static/image/icon/back_balck.png" mode="aspectFit" />
      </view>
      <view class="housename">{{housename}}</view>
      <view class="right">
      </view>
    </view>
    <scroll-view class="content">
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
        <view class="facbrief">
          <view class="type">{{houseType}}</view>
          <view class="sep">&nbsp;·&nbsp;</view>
          
          <view class="roomcount">{{roomcount}}室{{bathcount}}卫</view>
          <view class="sep">&nbsp;·&nbsp;</view>
          <view class="pcount">宜居{{maxPeople}}人</view>
        </view>
        <view class="tips">预订成功
          <text class="tip" v-if="cancleRule=='30'">{{cancleRule}}分钟</text><text class="tip" v-if="cancleRule!='30'">{{cancleRule}}天</text>
          内可以免费取消
        </view>
      </view>
      <view class="rentpeople">
        <view class="title">
          <view class="desc">入住人信息</view>
          <view class="peoplecount">已选{{sList.length}}人</view>
        </view>
        <view class="selectPeople">
          <checkbox-group @change="speople" class="checkgroup">
            <label class="checkitem " v-for="item in idinfo">
              <checkbox :value="item" :checked="false" color="#fd6f10" style="transform:scale(0.5)" />
              <text class="rname ">{{item.realname}}</text>
            </label>
            <view class="addBtn" @click="toAddpage">添加</view>
          </checkbox-group>

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

      <view class="tipsbottom">
        <view class="item">入住时间:14:00后可入住，12:00之前需退房</view>
        <view class="item">温馨提示:您未到店或未入住时，如需联系房东商家，请使用平台在线聊天工具。请勿轻易线下转账方式支付押金或其他费用，以免上当受骗。</view>
      </view>
      <view class="mblock"></view>
    </scroll-view>
    <view class="bottomBar">
      <view class="bbwrapper">
        <view class="pricemoudle">
          <view class="pricewrapper">
            <text class="symbol">￥</text>
            <text class="discounprice">{{price}}</text>
            <text class="night">/晚</text>
            <del class="orgprice">￥{{oprice}}</del>
          </view>
          <view class="discoutMoudle">
            促销已减{{oprice-price}}元
          </view>
        </view>
        <view class="btnwrapper">
          <view class="bookingBtn" @click="commitOrder">去支付</view>
        </view>

      </view>
    </view>
    <uni-popup ref="message" type="message">
      <uni-popup-message :type="msgType" :message="messageText" :duration="duration"></uni-popup-message>
    </uni-popup>
    <uni-popup ref="alertDialog" type="dialog">
      <uni-popup-dialog type="error" cancelText="关闭" confirmText="确定" title="通知" content="该房间已被预订或您有未完成的订单" @confirm="dialogConfirm"></uni-popup-dialog>
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
      msgType:'',
      messageText:'',
      duration:2000
    }
  },
  methods: {
    dialogConfirm() {
      uni.navigateBack({
        delta: 1
      })
    },
    naback() {
      uni.navigateBack({
        delta: 1
      })
    },
    getInfo() {
      uni.request({
        url: `${API.BASE_URL}/getIDinfo`, //仅为示例，并非真实接口地址。
        data: {
          uid: uni.getStorageSync('userId')
        },
        success: res => {
          this.idinfo = res.data.data.info
          this.idinfo.forEach(element => {
            element.orgNum = element.idnumber
            element.idnumber = this.hideIDNumber(element.idnumber)
          })
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
    speople(e) {
      this.sList = e.detail.value
      console.log(this.sList)
    },
    toAddpage() {
      uni.navigateTo({
        url: '/pages/addCon_text/addCon_text'
      })
    },
    commitOrder() {
      if (this.canNext) {
        uni.request({
          url: `${API.BASE_URL}/getOrder`,
          data: {
            hid: this.houseid,
            endTimeStr: this.endTime.timestamp,
            startTimeStr: this.startTime.timestamp,
            totalprice: this.price * this.stayRange + this.deposit,
            uid: uni.getStorageSync('userId'),
            guestInfo: JSON.stringify(this.sList),
            lid: this.lid,
            housename: this.housename
          },
          success: res => {
            console.log(res.data)
            if (res.data.requestStatus == '200') {
              const orderStr = res.data.data.orderStr
              const orderNum = res.data.data.orderNum
              uni.setStorageSync('orderStr', orderStr)
              uni.navigateTo({
                url: `/pages/payment/payment?num=${orderNum}`
              })
            } else if (res.data.requestStatus == '401') {
              this.$refs.alertDialog.open('info')
              console.log('生成订单失败，已经有人订了')
            } else {
              this.$refs.alertDialog.open('info')
              console.log('出现错误，请重试')
            }
          }
        })
      } else {
        this.msgType="warn"
        this.messageText="请先选择入住人"
        this.$refs.message.open()
      }
    }
  },
  onLoad(option) {
    this.startTime = uni.getStorageSync('startTime')
    this.endTime = uni.getStorageSync('endTime')
    this.stayRange = uni.getStorageSync('stayRange')
    console.log(option)

    this.cancleRule = option.cancleRule
    this.deposit = parseFloat(option.deposit)
    this.houseType = option.houseType
    this.housename = option.housename
    this.maxPeople = option.maxPeople
    this.price = parseFloat(option.price)
    this.oprice = parseFloat(option.oprice)
    this.roomcount = option.roomcount
    this.bathcount = option.bathcount
    this.houseid = option.houseid
    this.lid = option.lid
  },
  onShow() {
    this.getInfo()
  },
  computed: {
    canNext() {
      if (this.sList.length == 0) {
        return false
      } else {
        return true
      }
    }
  }
}
</script >

<style lang="less">
.rt {
  background: linear-gradient(to bottom, #ffdaa5, #f6f7fb 1200rpx);
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
  .housename {
    text-overflow: ellipsis;
    overflow: hidden;
    white-space: nowrap;
    width: 80%;
    line-height: 40rpx;
    font-weight: 900;
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
    .facbrief {
      font-size: 24rpx;
      font-weight: 900;
      height: 70rpx;
      line-height: 70rpx;
      display: flex;
    }
    .tips {
      color: #ac4103;
      font-weight: 900;
      font-size: 24rpx;
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
</style>
