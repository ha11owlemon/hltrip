<template>
  <view>
    <view class="statusbar"></view>
    <view class="topbar">
      <view class="left" @click="nvback">
        <image class="topbar-icon leftIco" src="../../static/image/icon/back_balck.png" mode="aspectFit" />
      </view>
      <view class="housename">评论详情</view>
      <view class="right">

      </view>

    </view>

    <view class="commentbody" v-if="info!={}">

      <view class="commentHeader">
        <view class="avatar">
          <image class="avatarPic" :src="info.avatar" mode="aspectFill" />
        </view>
        <view class="right">
          <view class="name">{{info.comment.username}}</view>
          <view class="commenttime">
            <view class="time">{{info.comment.commenttime.year}}-{{info.comment.commenttime.month}}-{{info.comment.commenttime.date}}</view>
            <view class="rating">{{info.comment.rating}}</view>
          </view>

        </view>
      </view>
      <view class="commentContent">{{info.comment.commentcontent}}</view>
      <view class="picwrpper">
        <view class="picitem" v-for="(item,index) in info.urls" @click="zoom(index)">
          <image class="images" :src="item" mode="aspectFill" />
        </view>

        <i></i><i></i><i></i>
      </view>
    </view>
    <view class="replyBar" v-if="info!={}">
      <view class="inputblock" @click="openReply">回复&nbsp;@{{info.comment.username}} ...</view>
    </view>

    <uni-popup ref="distancepopup" background-color="#fff" border-radius="20rpx 20rpx 0 0">
      <view class="popup_content">
       <textarea confirm-type="send"   class="textarea" :placeholder="placeholder" v-model="txt" @confirm="sendComment"></textarea>
			<view class="btnph"><view class="sendBtn" v-if="txt!=''" @click="sendComment">发送</view></view>
			 
      </view>
    </uni-popup>
		<uni-popup ref="alertDialog" type="dialog">
      <uni-popup-dialog type="error" cancelText="关闭" confirmText="确定" title="通知" :content="poptext" @close="nvback" @confirm="nvback"></uni-popup-dialog>
    </uni-popup>
    <q-previewImage ref="previewImage" :urls="info.urls"></q-previewImage>
  </view>
</template>

<script>
import API from '../../static/data/API.js';
export default {
  data() {
    return {
      info: {},
			txt:"",
			cid:"",
			poptext:""
    }
  },
	computed:{
		placeholder(){
			return "回复 @"+this.info.comment.username +"..."
		}
	},
  methods: {
    nvback() {
      uni.navigateBack({
        delta: 1
      })
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
    zoom(index) {
      this.$refs.previewImage.open(this.info.urls[index])
    },
		openReply(){
			this.$refs.distancepopup.open("bottom")
		},
		sendComment(){
			if(this.txt!=''){
				uni.request({
					url:`${API.BASE_URL}/replyComment`,
					data:{
						cid:this.cid,
						reply:this.txt
					},
					success:res=>{
						if(res.data){				
							this.poptext="回复成功"
							this.$refs.alertDialog.open()
						}else{						
							this.poptext="回复失败"
							this.$refs.alertDialog.open()
						}
					}
				})
			}
		}
  },
  onLoad(option) {
    this.cid=option.cid
    uni.request({
      url: `${API.BASE_URL}/getSingalComment`, //仅为示例，并非真实接口地址。
      data: {
        cid: this.cid
      },
      success: res => {
        console.log(res.data)
        this.info = res.data.data
        this.info.comment.commenttime = this.getTime(new Date(this.info.comment.commenttime))
        this.info.comment.commentcontent = '环境很不错，下次还会再来'
        this.info.comment.rating = this.info.comment.rating.toFixed(1)


      }
    })
  }
}
</script>

<style lang="less">
.statusbar {
  width: 100vw;
  height: var(--status-bar-height);
  background-color: rgba(255, 255, 255, 0);
  z-index: 10;
}
.topbar {
  width: 100vw;
  background-color: rgba(255, 255, 255, 0);
  height: 80rpx;
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
.commentbody {
  width: 100vw;
  height: 500rpx;
  font-weight: 900;
  box-sizing: border-box;
  padding: 24rpx;
  .commentHeader {
    display: flex;
    padding: 10rpx 20rpx;
    box-sizing: border-box;
    .avatar {
      width: 90rpx;
      height: 90rpx;
      .avatarPic {
        width: 100%;
        height: 100%;
        border-radius: 111px;
      }
    }
    .right {
      margin-left: 20rpx;
      .name {
        color: #333;
      }
      .commenttime {
        margin-top: 10rpx;
        font-size: 24rpx;
        color: rgb(150, 150, 150);
        display: flex;
        .rating {
          background-color: #fd7207;
          padding: 0 10rpx;
          color: aliceblue;
          height: 34rpx;
          line-height: 34rpx;
          border-radius: 6rpx;
          margin-left: 20rpx;
        }
      }
    }
  }
  .commentContent {
		white-space: pre-wrap;
    padding: 14rpx 26rpx;
    background-color: rgb(252, 252, 252);
    font-size: 28rpx;
    min-height: 200rpx;
  }
  .picwrpper {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    margin-top: 14rpx;
    i {
      width: 18%;
    }
    .picitem {
      width: 18%;
      .images {
        width: 100%;
        height: 120rpx;
        border-radius: 10rpx;
      }
    }
  }
}
.replyBar {
  position: absolute;
  bottom: 0;
  width: 100vw;
  min-height: 120rpx;
  border-top: 1px solid rgb(233, 233, 233);
  .inputblock {
    width: 95%;
    height: 80rpx;
    margin: auto;
    background-color: #f3f3f3;
    border-radius: 888rpx;
    line-height: 80rpx;
    padding: 0 20rpx;
    box-sizing: border-box;
    color: #737279;
    font-weight: 900;
    margin-top: 20rpx;
  }
}
.popup_content{
	min-height: 200rpx;
	.btnph{
		height: 100rpx;
		overflow: hidden;
		text-align: right;
	}
	.sendBtn{
		display: inline-block;
		background-color:#fd7207 ;
		border-radius: 1121rpx;
		width: 120rpx;
		height: 60rpx;
		text-align: center;
		line-height: 60rpx;
		margin-top: 20rpx;
		color: #f3f3f3;
		font-weight: 900;
		font-size: 28rpx;
		margin-right: 40rpx;
	}
}
.textarea{
	background-color: #222;
	width: 95%;
	margin: auto;
	margin-top: 20rpx;
	border-radius: 20rpx;
	background-color: #f3f3f3;
	padding: 24rpx;
	font-weight: bold;
	box-sizing: border-box;
}
</style>
