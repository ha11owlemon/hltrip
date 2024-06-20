<template>
  <view class="content">
    <image src="../../static/image/start/startBanner.png" mode="aspectFit" class="banner" />
  </view>
</template>

<script>
export default {
  data() {
    return {
      title: 'Hello'
    }
  },
  onLoad() {
    setTimeout(() => {
    }, 1500)
  },
  methods: {}
}
</script>

<style lang="less" scoped>
.content {
  align-items: center;
  justify-content: center;
  background-color: #fff;
  height: 100vh;
	position: relative;
	overflow: hidden;
	.banner{
		position: absolute;
		width: 400rpx;
		bottom: -50rpx;
		left: 50%;
		transform: translateX(-50%);
	}
}

</style>
