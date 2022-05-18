<template>
  <div id="app">  
    <div v-if="!excludedRoute">
        <b-navbar toggleable="lg" type="dark" style="background-color: purple;">
            <b-navbar-brand href="#">E-lectricity</b-navbar-brand>

            <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

            <b-collapse id="nav-collapse" is-nav>
            <b-navbar-nav>
                <b-nav-item href="/invoices">Facturas</b-nav-item>
                <b-nav-item :to="{ name: 'UploadInvoice' }">Subir factura</b-nav-item>
            </b-navbar-nav>

            <b-navbar-nav class="ml-auto">
                <b-nav-item-dropdown right>
                <template #button-content>
                    <b>{{ currentUser.username }}</b>
                </template>
                <b-dropdown-item :to="{ name: 'UserProfile' }">Profile</b-dropdown-item>
                <b-dropdown-item href="/logout">Log Out</b-dropdown-item>
                </b-nav-item-dropdown>
            </b-navbar-nav>
            </b-collapse>
        </b-navbar>
    </div>
    <div style="padding-left: 5%; padding-right: 5%">
      <router-view />
    </div>
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
      showNagivationBar: true,
      currentUser: {},
      excludedRoutes: [
          '/login',
          '/register',
          ''
      ],
    }
  },
  mounted() {
    this.$nextTick(function() {
      if (!this.excludedRoute)
        this.fetchData();
    });
  },
  updated() {
    this.$nextTick(function() {
      if (this.$store.state.vueRoutes.includes(this.$route.path)) {
        document.querySelector('#main_container').innerText = '';
      }
    });
  },
  methods: {
    fetchData() {
      this.$store.dispatch('loadCurrentUser').then(() => {
        this.currentUser = this.$store.state.currentUser;
      });
    }
  },
  computed: {
    excludedRoute() {
      return this.excludedRoutes.includes(this.$route.path);
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
