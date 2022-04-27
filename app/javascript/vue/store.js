import Vue from "vue";
import Vuex from "vuex";
import axios from "axios";

Vue.use(Vuex);

export default new Vuex.Store({
    state: {
        vueRoutes: [
            '/profile',
            '/upload_invoice',
            '/invoices'
        ],
        currentUser: {}
    },
    getters: {

    },
    mutations: {
        SAVE_CURRENT_USER(state, currentUser) {
            state.currentUser = currentUser;
        }
    },
    actions: {
        async loadCurrentUser({ commit }) {
            axios.defaults.headers.common["X-CSRF-Token"] = document
                    .querySelector('meta[name="csrf-token"]')
                    .getAttribute('content');
            await axios.get('/current_user').then((response) => {
                return commit('SAVE_CURRENT_USER', response.data);
            }).catch(() => {
                return commit('SAVE_CURRENT_USER', {});
            });
        }
    }
});