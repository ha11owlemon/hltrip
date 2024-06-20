<template>
  <view>
    <view class="statusbar"></view>
    <view class="topbar">
      <view class="left" @click="naback">
        <image class="topbar-icon leftIco" src="../../static/image/icon/back_balck.png" mode="aspectFit" />
      </view>
      <view class="housename">评论</view>
      <view class="right" @click="commitComment" :class="{'actived':canNext}">
				发布
      </view>
    </view>

    <scroll-view scroll-y class="commentcontent">
      <textarea class="tarea" placeholder-style="color:#bdbdbd" placeholder="说点什么吧..." @input="hanldeInput" v-model="content" />
      <view class="count">{{currentCursor}}/120</view>

      <scroll-view scroll-x="true"  class="item">
        <view class="addPic" @click="chooseImage">
          <image class="image" src="../../static/image/icon/add.png" mode="aspectFill" />
        </view>
        <view class="image-container" v-for="(url, index) in urls" :key="index">
          <image class="image" :src="url" mode="aspectFill" />
          <view class="delete-icon" @click="deleteImage(index)">
            <image class="deleteIco" src="../../static/image/icon/clear.png" mode="aspectFill" />
          </view>
        </view>
      </scroll-view>
			<view class="rating">
				<view class="ritem">
					<view class="desc">整洁卫生</view>
					<uni-rate allow-half activeColor="#fd7c3c" :margin="8" v-model="clean" /> <view class="rate">{{clean}}</view></view>
				<view class="ritem">
					<view class="desc">描述相符</view>
					<uni-rate allow-half activeColor="#fd7c3c" :margin="8" v-model="acc" /> <view class="rate">{{acc}}</view></view>
				<view class="ritem">
					<view class="desc">交通位置</view>
					<uni-rate allow-half activeColor="#fd7c3c" :margin="8" v-model="ltp" /> <view class="rate">{{ltp}}</view></view>
				<view class="ritem">
					<view class="desc">安全程度</view>
					<uni-rate allow-half activeColor="#fd7c3c" :margin="8" v-model="sft" /> <view class="rate">{{sft}}</view></view>
				<view class="ritem">
					<view class="desc">性价比</view>
					<uni-rate allow-half activeColor="#fd7c3c" :margin="8" v-model="vfm" /> <view class="rate">{{vfm}}</view></view>
			</view>
			
      <view class="mbb"></view>
    </scroll-view>
		<uni-popup ref="alertDialog" type="dialog">
      <uni-popup-dialog type="error" cancelText="关闭" @close="dialogConfirm" confirmText="确定" title="通知" :content="messageText" @confirm="dialogConfirm"></uni-popup-dialog>
    </uni-popup>
		<uni-popup ref="message" type="message">
      <uni-popup-message type="warn" message="请先输入内容" :duration="duration"></uni-popup-message>
    </uni-popup>
  </view>
</template>

<script>
import API from '../../static/data/API.js';
export default {
  data() {
    return {
      uname: '',
      lid: '',
      hid: '',
			oid:"",
      currentCursor: 0,
      content: '',
      urls: [],
			clean:0,
			acc:0,
			ltp:0,
			sft:0,
			vfm:0,
			messageText:""
    }
  },
  methods: {
    hanldeInput(e) {
      this.currentCursor = e.detail.cursor
    },
    naback() {
      uni.navigateBack({
        delta: 1
      })
    },
    chooseImage() {
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
                  this.urls.push(uploadFileRes.data)
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
    deleteImage(index) {
      // 其他房间的处理类似
      // 发送删除图片的请求
      uni.request({
        url: `${API.BASE_URL}/deletePic`, //仅为示例，并非真实接口地址。
        data: {
          url: this.urls[index]
        },
        success: res => {
          this.urls.splice(index, 1)
        }
      })
    },
		commitComment(){
			if(this.canNext){
				let calcrating=((this.clean+this.acc+this.ltp+this.sft+this.vfm)/5).toFixed(1)

				uni.request({
					url:`${API.BASE_URL}/commitComment`,
					data:{
						uid:uni.getStorageSync("userId"),
						commentContent:this.content,
						uname:this.uname,
						rate1:this.clean,
						rate2:this.acc,
						rate3:this.ltp,
						rate4:this.sft,
						rate5:this.vfm,
						rating:calcrating,
						lid:this.lid,
						hid:this.hid,
						urls:this.urls,
						oid:this.oid
					},
					success:res=>{
						if(res.data){
							this.messageText="点评成功"
							this.$refs.alertDialog.open()
						}else{
							this.messageText="点评失败"
							this.$refs.alertDialog.open()
						}
					}
				})
			}else{
				this.$refs.message.open()
			}
		},
		dialogConfirm(){
			uni.navigateBack({
				delta:2
			})
		}
  },
  onLoad(option) {
    this.uname=option.uname
    this.lid=option.lid
    this.hid=option.hid
		this.oid=option.oid
  },
	computed:{
		canNext(){
			if(this.content!=''){
				return true
			}else{
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
  color: #bdbdbd;
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
    width: 90rpx;
    height: 40rpx;
  }

  .right {
    width: 90rpx;
    height: 45rpx;
		line-height: 45rpx;
    font-size: 26rpx;
    background-color: #fd720791;
    left: 40rpx;
		text-align: center;
		color: rgb(255, 255, 255);
		border-radius: 111px;
		
  }
  .actived {
    background-color: #fd7207;
		color: #fff;
  }
}

.commentcontent {
  position: fixed;
  top: var(--status-bar-height);
  transform: translateY(80rpx);
  width: 100vw;
  height: 1550rpx;
  background-color: #fcfcfc;

  box-sizing: border-box;
  .mbb {
    width: 100%;
    height: 350rpx;
  }
  .tarea {
    background-color: #fff;
    padding: 20rpx;
    width: 100vw;
    box-sizing: border-box;
    height: 340rpx;
    font-weight: 900;
    color: #333;
  }

  .count {
    text-align: right;
    margin-top: 10rpx;
    margin-right: 20rpx;
    font-size: 28rpx;
    color: #bebebe;
  }
  .item {
    margin-bottom: 20rpx;
    width: 100vw;
    padding: 20rpx;
    box-sizing: border-box;
    overflow-x: auto;
    padding: 16rpx 0rpx;
		overflow: hidden;
		white-space: nowrap;
		vertical-align: bottom;
    .image-container {
      position: relative;
      width: 23%; // 一行显示4个，每个item间隔5rpx
      height: 170rpx;
			display: inline-block;
			margin-right: 20rpx;
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
			display: inline-block;
      height: 170rpx;
      border-radius: 20rpx;
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
  .delete-icon image {
    width: 100%;
    height: 100%;
  }
	.rating{
		width: 100vw;
		padding: 10rpx 27rpx 10rpx 57rpx;
		color: #333;
		box-sizing: border-box;
		font-weight: 900;
		.ritem{
			line-height: 50rpx;
			display: flex;
			justify-content: space-between;
			margin-top: 12rpx;
			.desc{
				width: 140rpx;
			}
			.rate{
				width: 100rpx;
				color: #fd7207;
			}
		}
	}
}
</style>
