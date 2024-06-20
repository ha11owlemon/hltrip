<template>
  <view>
    <view class="statusbar"></view>
    <view class="topbar">
      <view class="left" @click="nvback">
        <image class="topbar-icon leftIco" src="../../static/image/icon/back_balck.png" mode="aspectFit" />
      </view>
      <view class="housename">个人资料</view>
      <view class="right" :class="{'actived':canNext}" @click="changeProfile">
        更改
      </view>
    </view>
    <view class="content">
      <view class="avatarw p2s">
        <view class="left" @click="chooseImage">
          <image class="avatar" :src="avatar" mode="aspectFill" />
        </view>
        <input type="text" class="nameinput" v-model="nickname" placeholder="请输入用户名">
      </view>
      <view class="mb"></view>
      <view class="phone p2s">
        <div class="left">手机号</div>
        <view class="right">{{phonenumber}}</view>
      </view>
    </view>

    <uni-popup ref="alertDialog" type="dialog">
      <uni-popup-dialog type="error" cancelText="关闭" confirmText="确定" title="通知" :content="tiptext" @confirm="dialogConfirm" @close="dialogConfirm"></uni-popup-dialog>
    </uni-popup>

		<uni-popup ref="message" type="message">
        <uni-popup-message type="warn" message="请输入用户名" :duration="2000"></uni-popup-message>
      </uni-popup>
  </view>
</template>

<script>
import API from '../../static/data/API.js';
export default {
  data() {
    return {
      avatar: '',
      nickname: '',
      phonenumber: '',
      editNameL: false,
			tiptext:""
    }
  },
  methods: {
    nvback() {
			uni.navigateBack()
		},
    chooseImage() {
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
                  this.avatar = uploadFileRes.data
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
    changeProfile() {
			if(this.canNext){
				uni.request({
        url: `${API.BASE_URL}/changeLProfile`,
        data: {
          name: this.nickname,
          avatar: this.avatar,
          lid: uni.getStorageSync('landlordid')
        },
        success: res => {
          if (res.data) {
            console.log('修改成功')
						this.tiptext="修改成功"
						this.$refs.alertDialog.open('info')
          } else {
						this.tiptext="修改失败"
						this.$refs.alertDialog.open('info')
            console.log('修改失败')
          }
        }
      })
			}else{
				this.$refs.message.open()
			}
      
    },
		dialogConfirm(){
			uni.navigateBack({
				 delta: 1
			});
		}
  },
  onLoad() {
    uni.request({
      url: `${API.BASE_URL}/getLandlordProfileData`, //仅为示例，并非真实接口地址。
      data: {
        landlordid: uni.getStorageSync('landlordid')
        // userid: 7
      },
      success: res => {
        console.log(res.data)
        this.avatar = res.data.data.landlordProfile.avatar
        this.nickname = res.data.data.landlordProfile.nickname
        this.phonenumber = res.data.data.landlordProfile.phonenumber
      }
    })
  },
  computed: {
    canNext() {
      if (this.avatar != '' && this.nickname != '') {
        return true
      } else {
        return false
      }
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
  border-bottom: 1px solid rgb(236, 236, 236);
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
.content {
  position: fixed;
  top: var(--status-bar-height);
  transform: translateY(80rpx);
  width: 100vw;
  height: 800rpx;
  .p2s {
    padding-left: 40rpx;
    padding-right: 40rpx;
    padding-top: 24rpx;
    padding-bottom: 24rpx;
    box-sizing: border-box;
    display: flex;
    justify-content: space-between;
    font-weight: 900;
  }
  .avatarw {
    width: 100%;
    justify-content: start;
    .left {
      height: 100rpx;
      width: 100rpx;
      .avatar {
        width: 100rpx;
        height: 100rpx;
        border-radius: 900px;
      }
    }
    .right {
      margin-left: 30rpx;
      width: 60%;
      line-height: 100rpx;
      font-weight: 900;
      color: #333;
    }
    .nameinput {
      display: block;
      margin-top: 20rpx;
      margin-left: 30rpx;
      width: 60%;
      line-height: 100rpx;
      font-weight: 900;
      color: #333;
    }
  }

  .mb {
    width: 100vw;
    height: 20rpx;
    background: #f5f5f5;
  }
}
</style>
