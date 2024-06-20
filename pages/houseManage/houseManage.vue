<template>
  <view>
    <view class="statusbar"></view>
    <view class="topbar">
      <view class="left" @click="back">
        返回
      </view>
      房源管理
      <view class="right">

      </view>
    </view>

    <scroll-view scroll-y="true" class="content" scroll-with-animation="true" v-if="isLandlord">

      <view class="house_item" v-if="houseList.length!=0" v-for="(item,index) in houseList" :key="index">
        <view class="left">
          <view class="picwrapper">
            <image class="pic" :src="item.coverurl" mode="aspectFill" />
          </view>
          <view class="text">
            <view class="hotelname">{{item.housename}}</view>
            <view class="price">
              <text class="rmb">￥</text>
              <text class="disprice">{{item.discountprice}}</text>
              <text class="per9">/晚</text>
              <del class="orgprice">￥{{item.originalprice}}</del>
            </view>
          </view>
        </view>
        <view class="right">
          <view class="delete ritem" @click="openDiag(item.houseid)">删除</view>

          <view class="changeprice ritem" @click="openPricePop(item.houseid)">改价</view>
        </view>
      </view>
			<view class="empty" v-else><image src="../../static/image/empty_bg.png" mode="" /><br>
			暂无房源
			</view>
    </scroll-view>
    <view class="text" v-if="showLoading">
      <image class="ico" src="../../static/image/icon/loading.gif" mode="" />
    </view>
    <uni-popup ref="alertDialog" type="dialog">
      <uni-popup-dialog type="error" cancelText="关闭" confirmText="确定" title="通知" content="确定删除房屋吗" @confirm="deleteConfirm"></uni-popup-dialog>
    </uni-popup>

    <uni-popup ref="message" type="message">
      <uni-popup-message :type="msgtype" :message="msgText" :duration="2000"></uni-popup-message>
    </uni-popup>

    <uni-popup ref="popup" background-color="#fff" borderRadius="10px 10px 10px 10px">
      <view class="pricepop">
        <view class="title">修改价格</view>
        <view class="inputContainer">
          <input type="number" v-model="price" inputmode="decimal" placeholder-style="color:#c7c7c7" class="pinput" placeholder="请输入折扣价(实际价格)" />
          <input type="number" v-model="orgprice" placeholder-style="color:#c7c7c7" inputmode="decimal" class="pinput" placeholder="请输入原价" />
        </view>
        <view class="btngroup">
          <view class="cancle" @click="closedialog">取消</view>
          <view class="confirm" @click="pricepopConfirm">确定</view>
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
      isLandlord: false,
      showLoading: false,
      houseList: [],
      currentHouseid: null,
      msgtype: 'success',
      msgText: '删除成功',
      price: '',
      orgprice: ''
    }
  },
  methods: {
    back() {
      uni.navigateBack({
        delta: 1
      })
    },
    openDiag(id) {
      this.currentHouseid = id
      this.$refs.alertDialog.open('info')
    },
    queryHouse() {
      uni.request({
        url: `${API.BASE_URL}/getLordHouses`, //仅为示例，并非真实接口地址。
        data: {
          landlordid: uni.getStorageSync("landlordid")
        },
        success: res => {
          console.log(res.data)
          this.houseList = res.data.data.landlordHouses
        }
      })
    },
    deleteConfirm() {
      uni.request({
        url: `${API.BASE_URL}/deleteHouse`,
        data: {
          landlordid:uni.getStorageSync("landlordid"),      
          houseid: this.currentHouseid
        },
        success: res => {
          console.log(res.data)
          if (res.data.requestStatus == '200') {
            this.houseList = this.houseList.filter(element => {
              return element.houseid != this.currentHouseid
            })
             this.msgtype = 'success'
            this.msgText = '删除成功'
            this.$refs.message.open()
            uni.$emit("deleteHouseSuccess",null)
          } else {
            this.msgtype = 'error'
            this.msgText = '删除失败'
            this.$refs.message.open()
          }
        },
        fail: err => {
          console.log(err)
          this.msgtype = 'error'
          this.msgText = '删除失败' + err.message
          this.$refs.message.open()
        }
      })
    },
    openPricePop(id) {
      this.currentHouseid = id
      this.$refs.popup.open('center')
    },
    closedialog() {
      this.$refs.popup.close()
    },
    pricepopConfirm() {
      const p = parseFloat(this.price)
      const op = parseFloat(this.orgprice)
      if (this.price == '' || this.orgprice == '') {
        this.msgtype = 'warn'
        this.msgText = '价格不能为空'
        this.$refs.message.open()
      } else if (p > op) {
        this.msgtype = 'warn'
        this.msgText = '折扣价不能大于原价'
        this.$refs.message.open()
      } else {
        uni.request({
          url: `${API.BASE_URL}/updatePrice`,
          data: {
            landlordid: uni.getStorageSync('landlordid'),
            houseid: this.currentHouseid,
            orgprice: this.orgprice,
            price: this.price
          },
          success: res => {
            if (res.data.requestStatus == '200') {
              this.houseList.forEach(element => {
                if (element.houseid == this.currentHouseid) {
                  element.discountprice = this.price
                  element.originalprice = this.orgprice
                  this.price = ''
                  this.orgprice = ''
                }
              })
              this.msgtype = 'success'
              this.msgText = '修改价格成功'
              this.$refs.message.open()
              this.$refs.popup.close()
            } else {
              this.msgtype = 'error'
              this.msgText = '修改价格失败'
              this.$refs.message.open()
              this.$refs.popup.close()
              this.price = ''
              this.orgprice = ''
            }
          },
          fail: err => {
            this.msgtype = 'error'
            this.msgText = '修改价格失败' + err.message
            this.$refs.message.open()
            this.price = ''
            this.orgprice = ''
          }
        })
      }
    }
  },
  onLoad() {
    this.isLandlord = uni.getStorageSync('isLandlord')
    uni.request({
      url: `${API.BASE_URL}/getLordHouses`, //仅为示例，并非真实接口地址。
      data: {
        landlordid: uni.getStorageSync("landlordid")
				// landlordid: 76
      },
      success: res => {
        console.log(res.data)
        this.houseList = res.data.data.landlordHouses
      }
    })
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
  padding: 30rpx 30rpx 30rpx;
  width: 100vw;
  height: 1500rpx;
  .house_item {
    box-sizing: border-box;
    display: flex;
    width: 100%;
    padding: 18rpx 10rpx;
    background-color: rgba(255, 196, 148, 0.041);
    border-radius: 16rpx;
    margin-bottom: 24rpx;
    .left {
      width: 70%;
      height: 150rpx;
      display: flex;
      .picwrapper {
        width: 150rpx;
        height: 150rpx;
        border-radius: 20rpx;
        overflow: hidden;
        .pic {
          width: 100%;
          height: 100%;
        }
      }
      .text {
        flex: 1;
        font-weight: 900;
        color: #252525;
        display: flex;
        flex-direction: column;
        margin-left: 20rpx;
        height: 100%;

        justify-content: space-between;
        padding: 10rpx 0;
        box-sizing: border-box;
        .hotelname {
          width: 220rpx;
          font-size: 32rpx;
          // overflow: hidden;
          // text-overflow: ellipsis;
          // white-space: nowrap;
          -webkit-box-orient: vertical;
          overflow: hidden;
          text-overflow: ellipsis;
          -webkit-line-clamp: 2; /* 指定显示的行数 */
        }
        .price {
          color: #fd6f10;
          .disprice {
            font-size: 28rpx;
          }
          .rmb {
            font-size: 23rpx;
          }
          .per9 {
            font-size: 20rpx;
          }
          .orgprice {
            margin-left: 6rpx;
            color: #9e9e9e;
            font-size: 20rpx;
          }
        }
      }
    }
    .right {
      flex: 1;
      display: flex;
      font-size: 22rpx;
      font-weight: 900;

      .ritem {
        width: 50%;
        font-size: 26rpx;
        text-align: center;
        line-height: 150rpx;
        color: #fd6f10;
      }
    }
  }
	.empty{
		text-align: center;
		color: #808080;
		font-weight: bold;

	}
}
.pricepop {
  // background-color: #f2f;
  width: 600rpx;
  height: 370rpx;
  padding: 10rpx 40rpx;
  box-sizing: border-box;
  .title {
    color: #fd6f10;
    font-weight: 900;
    width: 100%;
    text-align: center;
    height: 80rpx;
    line-height: 80rpx;
  }
  .pinput {
    border-bottom: 1px solid #ffac752c;
    color: #a3a3a3;
    font-weight: bold;
    font-size: 30rpx;
    padding: 5rpx 10rpx 0;
    margin-top: 30rpx;
  }
  .btngroup {
    display: flex;
    margin-top: 20rpx;
    .cancle,
    .confirm {
      width: 50%;
      text-align: center;
      height: 100rpx;
      line-height: 100rpx;
      font-weight: 900;
      color: #808080;
    }
  }
}
</style>
