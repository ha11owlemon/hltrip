<template>
  <view>
    <view class="statusbar"></view>
    <view class="topbar">
      <view class="left" @click="nvback">
        <image class="topbar-icon leftIco" src="../../static/image/icon/back_balck.png" mode="aspectFit" />
      </view>
      <view class="housename">全部订单</view>
      <view class="right">
      </view>
    </view>
    <view class="switchTab">
      <view class="item" @click="changePage(0)" :class="{'tab_select':currentPage==0}">全部</view>
      <view class="item" @click="changePage(1)" :class="{'tab_select':currentPage==1}">待支付</view>
      <view class="item" @click="changePage(2)" :class="{'tab_select':currentPage==2}">进行中</view>
      <view class="item" @click="changePage(3)" :class="{'tab_select':currentPage==3}">已完成</view>
    </view>
    <scroll-view scroll-y class="sw_content" >
      <view class="se_item" v-if="currentPage==0">
        <view class="empty" v-if="allOrder.length==0">
          <image class="imgept" src="../../static/image/empty_bg.png" mode="" /><br>
          暂无相关订单
        </view>
        <view class="commentItem" v-if="allOrder.length!=0" v-for="(item,index) in allOrder" :key="index">
          <view class="picwrp" @click="toBill(item)">
            <view class="left">
              <view class="order_status" :class="{'active':item.order.ostatus=='待支付'}">{{item.order.ostatus}}</view>
              <view class="housename">
                {{item.hov.housename}}
              </view>
              <view class="checktime">
                {{item.order.starttime.month}}.{{item.order.starttime.date}}&nbsp;-{{item.order.endtime.month}}.{{item.order.endtime.date}}&nbsp;·&nbsp;{{item.hov.rentaltype}}
              </view>
              <view class="checktime">
                金额:￥{{item.order.totalprice.toFixed(2)}}
              </view>
            </view>

            <image class="pic" :src="item.hov.coverurl" mode="aspectFill" />
          </view>
          <view>
            <view class="bbtn2" v-if="item.order.ostatus=='待支付'">
              <view class="toDetail" @click="toBill(item)">去支付</view>
              <view class="cancle" @click="openCD1(item)">取消订单</view>
              <view class="blk"></view>
              <view class="ordernum">订单号:{{item.order.ordernumber}}</view>
            </view>

            <view class="bbtn3" v-else-if="item.order.ostatus=='进行中'||item.order.ostatus=='待入住'">
              <view class="cancle" @click="openCD2(item)">取消订单</view>
              <view class="ordernum">订单号:{{item.order.ordernumber}}</view>
            </view>

            <view class="bbtn1" v-else>
              <view class="toDetail" @click="bookagain(item)">再次预订</view>
              <view class="ordernum">订单号:{{item.order.ordernumber}}</view>
            </view>
          </view>

        </view>
      </view>
      <view class="se_item" v-if="currentPage==1">
        <view class="empty" v-if="wait_pay.length==0">
          <image class="imgept" src="../../static/image/empty_bg.png" mode="" /><br>
          暂无相关订单
        </view>
        <view class="commentItem" v-if="wait_pay.length!=0" v-for="(item,index) in wait_pay" :key="index">
          <view class="picwrp" @click="toBill(item)">
            <view class="left">
              <view class="order_status" :class="{'active':item.order.ostatus=='待支付'}">{{item.order.ostatus}}</view>
              <view class="housename">
                {{item.hov.housename}}
              </view>
              <view class="checktime">
                {{item.order.starttime.month}}.{{item.order.starttime.date}}&nbsp;-{{item.order.endtime.month}}.{{item.order.endtime.date}}&nbsp;·&nbsp;{{item.hov.rentaltype}}
              </view>
              <view class="checktime">
                金额:￥{{item.order.totalprice.toFixed(2)}}
              </view>
            </view>

            <image class="pic" :src="item.hov.coverurl" mode="aspectFill" />
          </view>
          <view class="bbtn2">
            <view class="toDetail" @click="toBill(item)">去支付</view>
            <view class="cancle" @click="openCD1(item)">取消订单</view>
            <view class="blk"></view>
            <view class="ordernum">订单号:{{item.order.ordernumber}}</view>
          </view>

        </view>
      </view>
      <view class="se_item" v-if="currentPage==2">
        <view class="empty" v-if="processing.length==0">
          <image class="imgept" src="../../static/image/empty_bg.png" mode="" /><br>
          暂无相关订单
        </view>
        <view class="commentItem" v-if="processing.length!=0" v-for="(item,index) in processing" :key="index">
          <view class="picwrp" @click="toBill(item)">
            <view class="left">
              <view class="order_status" :class="{'active':item.order.ostatus=='待支付'}">{{item.order.ostatus}}</view>
              <view class="housename">
                {{item.hov.housename}}
              </view>
              <view class="checktime">
                {{item.order.starttime.month}}.{{item.order.starttime.date}}&nbsp;-{{item.order.endtime.month}}.{{item.order.endtime.date}}&nbsp;·&nbsp;{{item.hov.rentaltype}}
              </view>
              <view class="checktime">
                金额:￥{{item.order.totalprice.toFixed(2)}}
              </view>
            </view>

            <image class="pic" :src="item.hov.coverurl" mode="aspectFill" />
          </view>
          <view>
            <view class="bbtn3">
              <view class="cancle" @click="openCD2(item)">取消订单</view>
              <view class="ordernum">订单号:{{item.order.ordernumber}}</view>
            </view>
          </view>

        </view>
      </view>
      <view class="se_item" v-if="currentPage==3">
        <view class="empty" v-if="complete.length==0">
          <image class="imgept" src="../../static/image/empty_bg.png" mode="" /><br>
          暂无相关订单
        </view>
        <view class="commentItem" v-if="complete.length!=0" v-for="(item,index) in complete" :key="index">
          <view class="picwrp" @click="toBill(item)">
            <view class="left">
              <view class="order_status" :class="{'active':item.order.ostatus=='待支付'}">{{item.order.ostatus}}</view>
              <view class="housename">
                {{item.hov.housename}}
              </view>
              <view class="checktime">
                {{item.order.starttime.month}}.{{item.order.starttime.date}}&nbsp;-{{item.order.endtime.month}}.{{item.order.endtime.date}}&nbsp;·&nbsp;{{item.hov.rentaltype}}
              </view>
              <view class="checktime">
                金额:￥{{item.order.totalprice.toFixed(2)}}
              </view>
            </view>

            <image class="pic" :src="item.hov.coverurl" mode="aspectFill" />
          </view>
          <view>
            <view class="bbtn1">
              <view class="toDetail" @click="bookagain(item)">再次预订</view>
              <view class="ordernum">订单号:{{item.order.ordernumber}}</view>
            </view>
          </view>

        </view>
      </view>
      <view class="mbb"></view>
    </scroll-view>

    <uni-popup ref="alertDialog" type="dialog">
      <uni-popup-dialog type="error" cancelText="按错了" confirmText="确定" title="通知" content="确定要取消该订单吗" @confirm="alertCancle"></uni-popup-dialog>
    </uni-popup>
    <uni-popup ref="alertDialog1" type="dialog">
      <uni-popup-dialog type="error" cancelText="关闭" confirmText="确定" title="通知" :content="tipText" @confirm="confirmCancle"></uni-popup-dialog>
    </uni-popup>

    <uni-popup ref="message" type="message">
      <uni-popup-message type="warn" :message="message" :duration="2000"></uni-popup-message>
    </uni-popup>
  </view>
</template>

<script>
import API from '../../static/data/API.js';
export default {
  data() {
    return {
      currentPage: 0,
      allOrder: [],
      wait_pay: [],
      processing: [],
      complete: [],
      cancleOnum1: 0,
      cancleOnum2: 0,
      tipText: '',
      message: ''
    }
  },
  onLoad(option) {
    if (option.page == undefined) {
      this.currentPage = 0
    } else {
      this.currentPage = option.page
    }
    this.getOrderList()
  },
  methods: {
    getOrderList() {
      uni.request({
        url: `${API.BASE_URL}/getUserOrders`, //仅为示例，并非真实接口地址。
        data: {
          uid: uni.getStorageSync('userId')
        },
        success: res => {
          const orderList = res.data.data.orderList.reverse()
          orderList.forEach(element => {
            element.order.starttime = this.getTime(new Date(element.order.starttime))
            element.order.endtime = this.getTime(new Date(element.order.endtime))
          })
          this.allOrder = orderList
          this.allOrder.forEach(element => {
            if (element.order.ostatus == '待支付') {
              this.wait_pay.unshift(element)
            } else if (element.order.ostatus == '进行中' || element.order.ostatus == '待入住') {
              this.processing.unshift(element)
            } else if (element.order.ostatus == '已完成') {
              this.complete.unshift(element)
            }
          })
        }
      })
    },
    nvback() {
      uni.navigateBack()
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
    changePage(index) {
      this.currentPage = index
    },
    bookagain(item) {
      uni.navigateTo({
        url: `/pages/hotelDetail/hotelDetail?houseid=${item.hov.houseid}`
      })
    },
    toBill(item) {
      uni.navigateTo({
        url: `/pages/orderpay/orderpay?num=${item.order.ordernumber}`
      })
    },
    alertCancle() {
      this.canaleOrder()
    },
    canaleOrder() {
      uni.request({
        url: `${API.BASE_URL}/closeOrder`,
        data: {
          orderNum: this.cancleOnum1
        },
        success: res => {
          this.allOrder = []
          this.wait_pay = []
          this.processing = []
          this.complete = []
          this.getOrderList()
          this.message = '取消成功'
          this.$refs.message.open()
        }
      })
    },
    openCD1(item) {
      this.cancleOnum1 = item.order.ordernumber
      this.$refs.alertDialog.open()
    },
    openCD2(item) {
      this.cancleOnum2 = item.order.ordernumber
      uni.request({
        url: `${API.BASE_URL}/canIcancleOrder`,
        data: {
          onum: this.cancleOnum2
        },
        success: res => {
          if (res.data) {
            this.tipText = '确定取消订单吗，现在取消将全额退款'
            this.$refs.alertDialog1.open()
          } else {
            this.tipText = '确定取消订单吗，现在取消将扣除所有房费'
            this.$refs.alertDialog1.open()
          }
        }
      })
    },
    confirmCancle() {
      uni.request({
        url: `${API.BASE_URL}/confirmCancle`,
        data: {
          onum: this.cancleOnum2
        },
        success: res => {
          if (res.data) {
            this.message = '取消成功'
            this.$refs.message.open()
            this.allOrder = []
            this.wait_pay = []
            this.processing = []
            this.complete = []
            this.getOrderList()
          } else {
            this.message = '取消失败'
            this.$refs.message.open()
            this.allOrder = []
            this.wait_pay = []
            this.processing = []
            this.complete = []
            this.getOrderList()
          }
        }
      })
    }
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
  padding: 20rpx 20rpx;
  box-sizing: border-box;
  .topbar-icon {
    vertical-align: bottom;
    width: 30rpx;
    height: 30rpx;
    margin-bottom: 5rpx;
  }
  font-weight: 900;
  .left {
    text-align: center;
    width: 60rpx;
    height: 40rpx;
  }

  .right {
    width: 60rpx;
    height: 40rpx;
    font-size: 26rpx;
    color: #fd720763;
    left: 40rpx;
  }
  .actived {
    color: #fd7207;
  }
}
.switchTab {
  width: 100vw;
  height: 60rpx;
  line-height: 60rpx;
  display: flex;
  justify-content: space-between;
  position: fixed;
  top: var(--status-bar-height);
  transform: translateY(80rpx);
  font-weight: 900;
  color: #767676;
  font-size: 26rpx;
  box-sizing: border-box;
  padding: 0 50rpx;
  .item {
    height: 100%;
    position: relative;
  }
  .tab_select {
    color: #000;
    &::after {
      content: '';
      position: absolute; /* 相对于父元素定位 */
      left: 50%;
      transform: translateX(-50%);
      bottom: 0;
      width: 70rpx;
      height: 3rpx;
      // #ff7417
      border-radius: 1111px;
      background-color: #ff7417;
    }
  }
}
.sw_content {
  width: 100vw;
  padding: 8rpx 16rpx;
  background-color: #f9f9f9;
  box-sizing: border-box;
  position: fixed;
  top: var(--status-bar-height);
  transform: translateY(140rpx);
  height: 1500rpx;

  .commentItem {
    background-color: #fff;
    box-sizing: border-box;
    padding: 28rpx;
    border-radius: 14rpx;
    overflow: hidden;
    font-weight: 900;
    margin-bottom: 16rpx;
    .item {
      font-size: 26rpx;
    }
    .picwrp {
      margin-top: 10rpx;
      display: flex;
      width: 100%;
      justify-content: space-between;
      .left {
        width: 60%;
      }
      .order_status {
        font-size: 24rpx;
        margin-left: 20rpx;
        color: #333;
      }
      .active {
        color: #fd7207;
      }
      .housename {
        font-size: 30rpx;
        margin-left: 20rpx;
        margin-top: 24rpx;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }
      .checktime {
        font-size: 25rpx;
        color: #555555;
        margin-left: 20rpx;
        margin-top: 10rpx;
      }
      .pic {
        width: 38%;
        height: 170rpx;
        border-radius: 16rpx;
      }
    }
    .bbtn1 {
      margin-top: 30rpx;
      display: flex;
      width: 100%;
      justify-content: space-between;
      align-items: flex-end;
      box-sizing: border-box;
      .toDetail {
        height: 52rpx;
        border-radius: 1999rpx;
        text-align: center;
        font-size: 27rpx;
        width: 150rpx;
        line-height: 52rpx;
        border: 1px solid #333;
        margin-left: 6rpx;
      }
      .ordernum {
        font-size: 20rpx;
        font-weight: normal;
        color: #929292;
        text-align: right;
        margin-bottom: 10rpx;
      }
    }
    .bbtn2 {
      margin-top: 30rpx;
      display: flex;
      width: 100%;
      justify-content: space-between;
      align-items: flex-end;
      box-sizing: border-box;
      .toDetail {
        height: 56rpx;
        border-radius: 1999rpx;
        text-align: center;
        font-size: 24rpx;
        width: 120rpx;
        line-height: 56rpx;
        background-color: #ff7417;
        color: #f9f9f9;
        margin-left: 6rpx;
      }
      .cancle {
        height: 56rpx;
        line-height: 56rpx;
        font-size: 24rpx;
        color: #767676;
      }
      .blk {
        width: 16rpx;
      }
      .ordernum {
        font-size: 20rpx;
        font-weight: normal;
        color: #929292;
        text-align: right;
        margin-bottom: 10rpx;
      }
    }
    .bbtn3 {
      margin-top: 30rpx;
      display: flex;
      width: 100%;
      justify-content: space-between;
      align-items: flex-end;
      box-sizing: border-box;
      .cancle {
        height: 50rpx;
        border-radius: 1999rpx;
        text-align: center;
        font-size: 26rpx;
        border: 1px solid #000;
        width: 160rpx;
        line-height: 50rpx;
        color: #000;
        margin-left: 6rpx;
        font-size: 24rpx;
      }
      .blk {
        width: 16rpx;
      }
      .ordernum {
        font-size: 20rpx;
        font-weight: normal;
        color: #929292;
        text-align: right;
        margin-bottom: 10rpx;
      }
    }
  }
  .empty {
    text-align: center;
    font-weight: 900;
    color: #747474;
    .imgept {
      filter: brightness(97%);
    }
  }
  .mbb {
    height: 300rpx;
    width: 100%;
  }
}
</style>
