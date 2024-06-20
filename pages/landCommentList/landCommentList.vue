<template>
  <view>
    <view class="statusbar"></view>
    <view class="topbar">
      <view class="left" @click="nvback">
        <image class="topbar-icon leftIco" src="../../static/image/icon/back_balck.png" mode="aspectFit" />
      </view>
      <view class="housename">待回复</view>
      <view class="right">

      </view>

    </view>

    <scroll-view scroll-y class="commentList" :class="{'whiteBg':info.length==0}">
      <view class="commentItem" v-for="(item,index) in info" @click="toreply(item)">
        <view class="citem">
          <view class="left">
            <view class="comment">@<text class="uname">{{item.comment.username}}</text>&nbsp;回复说：{{item.comment.commentcontent}}</view>
            <view class="commenttime">{{item.comment.commenttime.year}}-{{item.comment.commenttime.month}}-{{item.comment.commenttime.date}}&nbsp;评论<text class="reply">回复</text></view>
          </view>
          <view class="right">
            <image :src="item.hov.coverurl" class="cover" mode="aspectFill" />
          </view>
        </view>
      </view>
      <view class="empty" v-if="info.length==0">
        <image src="../../static/image/empty_bg.png" mode="" /><br>
        暂无相关订单
      </view>
      <view class="mbb"></view>
    </scroll-view>
  </view>
</template>

<script>
import API from '../../static/data/API.js';
export default {
  data() {
    return {
      info: []
    }
  },
  methods: {
    nvback() {
      uni.navigateBack({
        delta: 1
      })
    },
    getComments() {
      uni.request({
        url: `${API.BASE_URL}/landlordQueryComment`,
        data: {
          lid:uni.getStorageSync('landlordid')
        },
        success: res => {
          console.log(res.data)
          this.info = res.data.data.comments
          this.info.forEach(element => {
            element.comment.commenttime = this.getTime(new Date(element.comment.commenttime))
          })
        }
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
		toreply(item){
			uni.navigateTo({
				 url: `/pages/comment_reply/comment_reply?cid=${item.comment.commentid}`
			});		}
  },
  onShow() {
    this.getComments()
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
.commentList {
  position: fixed;
  top: var(--status-bar-height);
  transform: translateY(80rpx);
  width: 100vw;
  height: 1550rpx;
  background-color: #f8f8f8;

  box-sizing: border-box;
  padding: 14rpx 20rpx;
  .mbb {
    width: 100%;
    height: 350rpx;
  }
  .commentItem {
    background-color: #fff;
    box-sizing: border-box;
    padding: 14rpx 28rpx;
    border-radius: 14rpx;
    overflow: hidden;
    font-weight: 900;
    margin-bottom: 16rpx;
		.citem{
			display: flex;
			justify-content: space-between;
			.left{
				width: 60%;
				.comment{
					width: 100%;
					display: -webkit-box;
        -webkit-box-orient: vertical;
        overflow: hidden;
        text-overflow: ellipsis;
        -webkit-line-clamp: 2; /* 指定显示的行数 */
				}
				.commenttime{
					color: #747474;
					font-size: 24rpx;
					margin-top: 20rpx;
				}
				.reply{
					margin-left: 20rpx;
				}
			}
			.right{
				width: 32%;
				height: 140rpx;
				.cover{
					width: 100%;
					height: 100%;
					border-radius: 8rpx;
				}
			}
		}
  }
}

.empty {
  text-align: center;
  margin-top: 300rpx;
  font-weight: 900;
  color: #747474;
}
.whiteBg {
  background-color: #fff;
}
</style>
