<template>
  <div id="app">  
    <b-navbar
      toggleable="lg"
      type="dark"
      sticky
      style="background-color: purple; z-index: 2"
      v-if="!excludedRoute"
    >
        <b-navbar-brand href="#">E-lectricity</b-navbar-brand>

        <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

        <b-collapse id="nav-collapse" is-nav>
        <b-navbar-nav>
            <b-nav-item
              :to="{ name: 'ContractsIndex' }"
              :class="isPath('/contracts') ? 'current-page' : ''"
            >Mis contratos</b-nav-item>
            <b-nav-item
              :to="{ name: 'NewContract' }"
              :class="isPath('/add_contract') ? 'current-page' : ''"
            >Añadir contrato</b-nav-item>
            <b-nav-item
              :to="{ name: 'UploadInvoice' }"
              :class="isPath('/upload_invoice') ? 'current-page' : ''"
            >Subir factura</b-nav-item>
            <b-nav-item
              :to="{ name: 'CompareInvoices' }"
              :class="isPath('/compare_invoices') ? 'current-page' : ''"
            >Comparar facturas</b-nav-item>
        </b-navbar-nav>

        <b-navbar-nav class="ml-auto">
            <b-nav-item-dropdown right>
            <template #button-content>
                <b>{{ currentUser.username }}</b>
            </template>
            <b-dropdown-item :to="{ name: 'UserProfile' }">Perfil</b-dropdown-item>
            <b-dropdown-item href="/logout">Desconectarse</b-dropdown-item>
            </b-nav-item-dropdown>
        </b-navbar-nav>
        </b-collapse>
    </b-navbar>
    <div>
      <router-view />
    </div>
  </div>
</template>

<script>
import axios from 'axios';

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
          '/e-lectricity'
      ],
      interval: null,
    }
  },
  mounted() {
    if (this.$route.path === '/')
      this.$router.push(this.$route.fullPath.replace('/#', ''));
    this.$nextTick(function() {
      if (!this.excludedRoute)
        this.fetchData();
    });
    this.interval = setInterval(
      async function () {
        this.checkSessionState();
      }.bind(this),
      1000 * 60
    );
  },
  updated() {
    if (this.$route.path === '/')
      this.$router.push(this.$route.fullPath.replace('/#', ''));
    this.$nextTick(function() {
      if (!this.excludedRoute) {
        document.querySelector('#main_container').innerText = '';
        document.querySelector('#main_container').style.height = '0px';
      }
    });
  },
  methods: {
    async fetchData() {
      await this.$store.dispatch('loadCurrentUser').then(() => {
        this.currentUser = this.$store.state.currentUser;
      });
      await this.checkSessionState();
    },
    async checkSessionState() {
      if (!this.excludedRoute)
        try {
            axios.defaults.headers.common["X-CSRF-Token"] = document
                .querySelector('meta[name="csrf-token"]')
                .getAttribute('content');
            const params = { user_id: this.$store.state.currentUser.id };
            const response = await axios.get('/session_expiracy_time', { params });
            if (response.data.success == 'true') {
              if (this.isSessionExpired(response.data.expiracy_time))
                this.logout();
            } else {
              this.logout();
            }
        } catch (error) {
          this.logout();
        }
    },
    isSessionExpired(expiracyTime) {
      return expiracyTime <= Date.now()/1000;
    },
    logout() {
      this.$store.dispatch('logOut');
      window.location.href = '/logout';
    },
    isPath(path) {
      return this.$route.path === path;
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

  .current-page {
    color: white !important;
    font-weight: bold;
  }
</style>
<style>
  @import '../packs/stylesheets.scss';
</style>