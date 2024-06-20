<template>
  <view>
    <view class="statusbar"></view>
    <view class="topbar">
      <view class="left" @click="back">
        返回
      </view>
      常用入住人
      <view class="right">
      </view>
    </view>

    <scroll-view scroll-y="true" class="content" scroll-with-animation="true" >
      <view class="addBtn" @click="addpeople">
        <image class="icon" src="../../static/image/icon/add.png" mode="aspectFit" />
        <text class="addtext">添加入住人</text>
      </view>

      <view class="featureitem" v-for="(item,index) in personInfo" :key="index" v-if="personInfo.length!=0">
        <view class="left">
          <view class="ftitle">{{item.realname}}</view>
          <view class="fcontent">{{item.idnumber}}</view>
        </view>
        <view class="right" @click="deletePop(index)">
          <image class="ico" src="../../static/image/icon/clear.png" mode="aspectFit" />
        </view>
      </view>
		    <view class="empty" v-if="personInfo.length==0">
      <image src="../../static/image/empty_bg.png" mode="" /><br>
      暂无记录
    </view>
    </scroll-view>

    <uni-popup ref="alertDialog" type="dialog">
      <uni-popup-dialog type="error" cancelText="关闭" confirmText="确定" title="通知" content="确定删除吗" @confirm="dialogConfirm"></uni-popup-dialog>
    </uni-popup>
  </view>
</template>

<script>
import API from '../../static/data/API.js';
export default {
  data() {
    return {
      personInfo: [],
      currentIndex: 0,
      msgtype: '',
      msgText: '',
			isFirst:true
    }
  },
  methods: {
    deletePop(index) {
      this.currentIndex = index
      this.$refs.alertDialog.open('info')
    },
    addpeople() {
      uni.navigateTo({
        url: '/pages/addCon_text/addCon_text'
      })
    },
    dialogConfirm() {
      uni.request({
        url: `${API.BASE_URL}/deleteIDinfo`, //仅为示例，并非真实接口地址。
        data: {
          uid: uni.getStorageSync('userId'),
          name: this.personInfo[this.currentIndex].realname,
          idnum: this.personInfo[this.currentIndex].orgNum
        },
        success: res => {
          if (res.data) {
            this.personInfo.splice(this.currentIndex, 1)
            this.msgtype = 'success'
            this.msgText = '删除成功'
            this.$refs.message.open()
          } else {
            this.msgtype = 'error'
            this.msgText = '删除失败'
            this.$refs.message.open()
          }
        }
      })
    },
    back() {
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
          this.personInfo = res.data.data.info
          this.personInfo.forEach(element => {
						element.orgNum=element.idnumber
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
    }
  },
  computed: {
  },
  onLoad() {
    // uni.removeStorageSync('houseInfo');
    this.getInfo()
  },
  onShow() {
		if(!this.isFirst){
			this.getInfo()
		}
		this.isFirst=false
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
  padding: 30rpx 40rpx 30rpx;
  width: 100vw;
  height: 1500rpx;
  .title {
    font-weight: 900;
    color: #585858;
  }
  .tbmargin60 {
    margin-top: 60rpx;
  }
  .tbmargin30 {
    margin-top: 30rpx;
  }
  .limitWidth {
    width: 200rpx !important;
  }
  .tips {
    margin-top: 100rpx;
    width: 100%;
    text-align: center;
    font-size: 22rpx;
    color: #bebebe;
    font-weight: bold;
  }
  .addBtn {
    padding: 25rpx 20rpx;
    margin-top: 10rpx;
    background-color: #fd6f102a;
    display: flex;
    align-content: center;
    justify-content: center;
    border-radius: 10rpx;
    .icon {
      width: 36rpx;
      height: 36rpx;
    }
    .addtext {
      font-weight: bold;
      margin-left: 10rpx;
      color: #1b1b1b;
      line-height: 36rpx;
    }
  }
  .featureitem {
    padding: 30rpx 25rpx;
    border-radius: 14rpx;
    display: flex;
    background-color: rgb(250, 250, 250);
    margin-top: 25rpx;
    .left {
      width: 90%;
      .ftitle {
        font-weight: 900;
        color: #1b1b1b;
      }
      .fcontent {
        font-size: 26rpx;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        width: 60%;
        color: #585858;
        margin-top: 5rpx;
      }
    }
    .right {
      flex: 1;
      display: flex;
      justify-content: center;
      align-content: center;
      width: 40rpx;
      height: auto;

      .ico {
        margin-top: 50%;
        transform: translateY(-50%);
        width: 40rpx;
        height: 40rpx;
      }
    }
  }
}
.empty {
	margin-top: 200rpx;
  text-align: center;
  color: #808080;
  font-weight: bold;
}
</style>
