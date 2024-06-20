<template>
  <view>
    <view class="statusbar"></view>
    <view class="topbar">
      <view class="left" @click="back">
        返回
      </view>
      房东认证
      <view class="right">
        <view class="nextBtn" :class="{'btnAct':canNext}" @click="next" v-if="!isLandlord">去认证</view>
      </view>
    </view>

    <scroll-view scroll-y="true" class="content" scroll-with-animation="true" v-if="!isLandlord">

      <view class="idcard1 verify_item addPic" v-if="!pics.idpic1" @click="chooseImage('idpic1')">
        <image class="image" src="../../static/image/icon/add.png" mode="aspectFill" />
      </view>
      <view class="image-container" v-if="pics.idpic1">
        <image class="image" :src="pics.idpic1" mode="aspectFill" />
        <view class="delete-icon" @click="deleteImage('idpic1')">
          <image class="deleteIco" src="../../static/image/icon/clear.png" mode="aspectFill" />
        </view>
      </view>
      <view class="title">请上传身份证正面照片</view>

      <view class="idcard2 verify_item addPic" v-if="!pics.idpic2" @click="chooseImage('idpic2')">
        <image class="image" src="../../static/image/icon/add.png" mode="aspectFill" />
      </view>
      <view class="image-container" v-if="pics.idpic2">
        <image class="image" :src="pics.idpic2" mode="aspectFill" />
        <view class="delete-icon" @click="deleteImage('idpic2')">
          <image class="deleteIco" src="../../static/image/icon/clear.png" mode="aspectFill" />
        </view>
      </view>
      <view class="title">请上传身份证反面照片</view>
      <view class="idcard3 verify_item addPic" v-if="!pics.idpic3" @click="chooseImage('idpic3')">
        <image class="image" src="../../static/image/icon/add.png" mode="aspectFill" />
      </view>
      <view class="image-container" v-if="pics.idpic3">
        <image class="image" :src="pics.idpic3" mode="aspectFill" />
        <view class="delete-icon" @click="deleteImage('idpic3')">
          <image class="deleteIco" src="../../static/image/icon/clear.png" mode="aspectFill" />
        </view>
      </view>
      <view class="title">请上传手持身份证照片</view>
    </scroll-view>
    <view class="text" v-if="isLandlord">
      您已经认证过了，无需重复认证
    </view>
    <view class="text" v-if="showLoading">
      <image class="ico" src="../../static/image/icon/loading.gif" mode="" />
    </view>
    <uni-popup ref="alertDialog" type="dialog">
      <uni-popup-dialog type="error" cancelText="关闭" @close="dialogConfirm" confirmText="确定" title="通知" content="验证成功" @confirm="dialogConfirm"></uni-popup-dialog>
    </uni-popup>
  </view>
</template>

<script>
import API from '../../static/data/API.js';
export default {
  data() {
    return {
      pics: {
        idpic1: '',
        idpic2: '',
        idpic3: ''
      },
      isLandlord: false,
      showLoading: false
    }
  },
  methods: {
    dialogConfirm() {
      uni.navigateBack()
    },
    next() {
      if (this.canNext) {
        const arr = []
        arr.push(this.pics.idpic1)
        arr.push(this.pics.idpic2)
        arr.push(this.pics.idpic3)
        this.showLoading = true
        uni.request({
          url: `${API.BASE_URL}/verifyLandlord`,
          data: {
            userid: uni.getStorageSync('userId'),
            urls: arr
          },
          success: res => {
            if (res.data.dataDesc == 'success') {
              // 跳转到成功页面
              uni.setStorageSync('landlordid', res.data.data.landlordid)
              this.showLoading = false
              this.$refs.alertDialog.open('info')
            } else {
              // 跳转到失败页面
              this.showLoading = false
            }
          }
        })

        // 跳转到认证提示页
        // uni.navigateTo({
        //   url: '/pages/upload/upload_image/upload_image'
        // })
      }
    },
    chooseImage(key) {
      console.log(this.pics[key])
      uni.chooseImage({
        count: 1, //默认9
        sizeType: ['original', 'compressed'], //可以指定是原图还是压缩图，默认二者都有
        sourceType: ['album', 'camera'], //从相册选择
        success: function (res) {
          res.tempFilePaths.forEach(filePath => {
            uni.uploadFile({
              url: `${API.BASE_URL}/uploadImage`,
              filePath: filePath,
              name: 'file',
              formData: {
                // 其他参数
                uid: uni.getStorageSync('userId'),
                role: 'tenant'
              },
              success: uploadFileRes => {
                if (uploadFileRes.data != 'error') {
                  this.pics[key] = uploadFileRes.data
                }
              },
              fail: uploadFileRes => {
                console.log(uploadFileRes)
              }
            })
          })
        }.bind(this)
      })
    },
    deleteImage(key) {
      // 其他房间的处理类似
      // 发送删除图片的请求
      uni.request({
        url: `${API.BASE_URL}/deletePic`, //仅为示例，并非真实接口地址。
        data: {
          url: this.pics[key]
        },
        success: res => {
          this.pics[key] = ''
        }
      })
    },
    back() {
      uni.navigateBack({
        delta: 1
      })
    }
  },
  computed: {
    canNext() {
      if (this.pics.idpic1 != '' && this.pics.idpic2 != '' && this.pics.idpic3 != '') {
        return true
      } else {
        return false
      }
    }
  },
  onLoad() {
    this.isLandlord = uni.getStorageSync('isLandlord')
    // uni.request({
    // 	url:"${API.BASE_URL}/hasLandlord",
    // 	data:{
    // 		userid:uni.getStorageSync("userId")
    // 	},
    // 	success:res=>{
    // 		this.isLandlord=res.data
    // 	}
    // })
  },
  onBackPress() {}
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
    color: #2c2c2c;
    text-align: center;
    margin-top: 20rpx;
    margin-bottom: 40rpx;
    font-size: 26rpx;
  }
  .image-container {
    position: relative;
    width: 98%; // 一行显示4个，每个item间隔5rpx
    height: 320rpx;
    margin-top: 10rpx;
    background-color: rgb(248, 248, 248);
    border-radius: 40rpx;
    .image {
      width: 100%;
      height: 100%;
      border-radius: 22rpx;
    }
    .delete-icon {
      position: absolute;
      top: -10rpx;
      right: -4rpx;
      width: 30rpx;
      height: 30rpx;
      line-height: 30rpx;
      text-align: center;
      border-radius: 100rpx;

      background-color: rgba(0, 0, 0, 0.555);
      .deleteIco {
        width: 100%;
        height: 100%;
        filter: brightness(150%);
      }
    }
  }
  .addPic {
    width: 100%;
    text-align: center;
    height: 320rpx;
    line-height: 0rpx;
    border-radius: 40rpx;
    background-color: rgb(248, 248, 248);
    line-height: 320rpx;
    .image {
      width: 100rpx;
      height: 100rpx;
      filter: brightness(460%);
      transform: translateY(50%);
    }
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
}
.text {
  line-height: 100vh;
  height: 100vh;
  width: 100vw;
  text-align: center;
  font-size: 30rpx;
  color: #2c2c2c;
  font-weight: 900;
  .ico {
    width: 60rpx;
    height: 60rpx;
  }
}
</style>
