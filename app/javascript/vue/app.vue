<template>
  <div id="app">
    <NavigationBar />
    <router-view />
  </div>
</template>

<script>
import NavigationBar from './components/NavigationBar.vue';

export default {
  name: 'E-lectricity',
  components: {
    NavigationBar,
  },
  data() {
    return {
      vueRoutes: [
        '/profile'
      ]
    }
  },
  updated() {
    this.$nextTick(function() {
      if (this.vueRoutes.includes(this.$route.path)) {
        document.querySelector('#main_container').innerText = '';
      }
    });
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
