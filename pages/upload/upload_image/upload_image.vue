<template>
  <view class="container">
    <view class="statusbar"></view>
    <view class="topbar">
      <view class="left" @click="back">
        上一步
      </view>
      图片上传
      <view class="right">
        <view class="nextBtn" :class="{'btnAct':canNext}" @click="next">下一步</view>
      </view>
    </view>
    <!-- 头部标签页 -->
    <view class="tabs">
      <view class="tab" v-for="(item, index) in tabs" :key="index" @click="switchTab(index)" :class="{ active: currentTab === index }">
        {{ item }}
      </view>
    </view>

    <!-- 内容页 -->
    <scroll-view class="content" scroll-y="true">
      <view class="item" v-if="currentTab === 0">

        <view class="image-container" v-for="(url, index) in houseInfo.houseImg[0].urls" :key="index">
          <image class="image" :src="url" mode="aspectFill" />
          <view class="delete-icon" @click="deleteImage(index,0)">
            <image class="deleteIco" src="../../../static/image/icon/clear.png" mode="aspectFill" />
          </view>
        </view>
        <view class="addPic" @click="chooseImage(0)">
          <image class="image" src="../../../static/image/icon/add.png" mode="aspectFill" />
        </view>
        <i></i><i></i>
      </view>
      <view class="item" v-if="currentTab === 1">

        <view class="image-container" v-for="(url, index) in houseInfo.houseImg[1].urls" :key="index">
          <image class="image" :src="url" mode="aspectFill" />
          <view class="delete-icon" @click="deleteImage(index,1)">
            <image class="deleteIco" src="../../../static/image/icon/clear.png" mode="aspectFill" />
          </view>
        </view>
        <view class="addPic" @click="chooseImage(1)">
          <image class="image" src="../../../static/image/icon/add.png" mode="aspectFill" />
        </view>
        <i></i><i></i>
      </view>
      <view class="item" v-if="currentTab === 2">

        <view class="image-container" v-for="(url, index) in houseInfo.houseImg[2].urls" :key="index">
          <image class="image" :src="url" mode="aspectFill" />
          <view class="delete-icon" @click="deleteImage(index,2)">
            <image class="deleteIco" src="../../../static/image/icon/clear.png" mode="aspectFill" />
          </view>
        </view>
        <view class="addPic" @click="chooseImage(2)">
          <image class="image" src="../../../static/image/icon/add.png" mode="aspectFill" />
        </view>
        <i></i><i></i>
      </view>
      <view class="item" v-if="currentTab === 3">

        <view class="image-container" v-for="(url, index) in houseInfo.houseImg[3].urls" :key="index">
          <image class="image" :src="url" mode="aspectFill" />
          <view class="delete-icon" @click="deleteImage(index,3)">
            <image class="deleteIco" src="../../../static/image/icon/clear.png" mode="aspectFill" />
          </view>
        </view>
        <view class="addPic" @click="chooseImage(3)">
          <image class="image" src="../../../static/image/icon/add.png" mode="aspectFill" />
        </view>
        <i></i><i></i>
      </view>
      <view class="item" v-if="currentTab === 4">

        <view class="image-container" v-for="(url, index) in houseInfo.houseImg[4].urls" :key="index">
          <image class="image" :src="url" mode="aspectFill" />
          <view class="delete-icon" @click="deleteImage(index,4)">
            <image class="deleteIco" src="../../../static/image/icon/clear.png" mode="aspectFill" />
          </view>
        </view>
        <view class="addPic" @click="chooseImage(4)">
          <image class="image" src="../../../static/image/icon/add.png" mode="aspectFill" />
        </view>
        <i></i><i></i>
      </view>
      <view class="magrinblock"></view>
    </scroll-view>
  </view>
</template>

<script>
import API from '../../../static/data/API.js';
export default {
  data() {
    return {
      tabs: ['卧室', '卫生间', '客厅', '厨房', '其他'],
      currentTab: 0,
      houseInfo: {
        houseImg: [
          {
            ImgGroup: '卧室',
            urls: []
          },
          {
            ImgGroup: '卫生间',
            urls: []
          },
          {
            ImgGroup: '客厅',
            urls: []
          },
          {
            ImgGroup: '厨房',
            urls: []
          },
          {
            ImgGroup: '其他',
            urls: []
          }
        ]
      }
      // 存储卧室图片
      // 其他标签页对应的图片数组
    }
  },
  computed: {
    canNext() {
      let count = 0
      this.houseInfo.houseImg.forEach(ImgGroup => {
        ImgGroup.urls.forEach(url => {
          count++
        })
      })
      if (count < 10) {
        return false
      } else {
        return true
      }
    }
  },
  methods: {
    switchTab(index) {
      this.currentTab = index
    },
    chooseImage(index) {
      uni.chooseImage({
        count: 9, //默认9
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
                role: 'landlord'
              },
              success: uploadFileRes => {
                if (uploadFileRes.data != 'error') {
                  this.houseInfo.houseImg[index].urls.push(uploadFileRes.data)
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
    deleteImage(index, groupindex) {
      // 其他房间的处理类似
      // 发送删除图片的请求
      uni.request({
        url: `${API.BASE_URL}/deletePic`, //仅为示例，并非真实接口地址。
        data: {
          url: this.houseInfo.houseImg[groupindex].urls[index]
        },
        success: res => {
          this.houseInfo.houseImg[groupindex].urls.splice(index, 1)
        }
      })
    },
    back() {
      uni.navigateBack({
        delta: 1
      })
    },
    next() {
      if (this.canNext) {
        const info = uni.getStorageSync('houseInfo')
        info.houseImg = this.houseInfo.houseImg
        console.log(info)

        uni.setStorageSync('houseInfo', info)
        uni.navigateTo({
          url: '/pages/upload/upload_facility/upload_facility'
        })
      }
    }
  },
  onLoad() {
    const hov = uni.getStorageSync('houseInfo')
    console.log('加载时的houseinfo', hov)
    this.houseInfo = JSON.parse(JSON.stringify(hov))
  },
  onBackPress() {
    const info = uni.getStorageSync('houseInfo')
    info.houseImg = this.houseInfo.houseImg
    uni.setStorageSync('houseInfo', info)
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
.container {
  padding: 20rpx;
  box-sizing: border-box;
  padding: 14rpx 26rpx;

  .tabs {
    position: fixed;
    display: flex;
    justify-content: space-between;
    background-color: #fff;
    margin-bottom: 20rpx;
    width: 100vw;
    top: var(--status-bar-height);
    left: 50%;
    transform: translate(-50%, 15rpx);
    font-size: 28rpx;
    border: 1px solid #dfdfdf;
    border-radius: 16rpx;
    overflow: hidden;
    width: 70%;
  }
  .tab {
    flex: 1;
    text-align: center;
    padding: 14rpx 0;
    color: #1d1d1d;
    font-weight: 900;
  }

  .tab.active {
    background-color: #ff6600;
    color: #fff;
    font-weight: 900;
  }
}

.content {
  border-radius: 10rpx;
  position: fixed;
  width: 100vw;
  top: 120rpx;
  transform: translateY(var(--status-bar-height));
  left: 0;
  height: 1500rpx;
  box-sizing: border-box;
  .item {
    margin-bottom: 20rpx;
    width: 100%;
    display: flex;
    padding: 20rpx;
    flex-wrap: wrap;
    box-sizing: border-box;
    justify-content: space-between;
    .image-container {
      position: relative;
      width: 23%; // 一行显示4个，每个item间隔5rpx
      height: 170rpx;
      margin-bottom: 20rpx;

      .image {
        width: 100%;
        height: 100%;
        border-radius: 22rpx;
      }
      .delete-icon {
        position: absolute;
        top: -8rpx;
        right: -8rpx;
        width: 30rpx;
        height: 30rpx;
        line-height: 30rpx;
        text-align: center;
        border-radius: 100rpx;

        background-color: rgba(0, 0, 0, 0.555);
        .deleteIco {
          filter: brightness(150%);
        }
      }
    }
    .addPic {
      width: 23%;
      text-align: center;
      height: 170rpx;
      border-radius: 20rpx;
      background-color: rgb(248, 248, 248);
      .image {
        width: 60%;
        height: 60%;
        filter: brightness(460%);
        margin-top: 50%;
        transform: translateY(-50%);
      }
    }
    i {
      width: 23%;
    }
  }
  .magrinblock {
    width: 100vw;
    height: 300rpx;
  }
}

.delete-icon image {
  width: 100%;
  height: 100%;
}
.topbar {
  font-weight: 900;
  width: 100vw;
  background-color: rgb(255, 255, 255);
  left: 0;
  height: 120rpx;
  position: fixed;
  bottom: 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  z-index: 999;
  box-shadow: -1px -4px 15px 7px #11111105;
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
</style>
