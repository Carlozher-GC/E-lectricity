import Vue from "vue";
import Vuex from "vuex";
import axios from "axios";

Vue.use(Vuex);

export default new Vuex.Store({
    state: {
        vueRoutes: [
            '/profile',
            '/upload_invoice'
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
            await axios.get('/current_user').then((response) => {
                return commit('SAVE_CURRENT_USER', response.data);
            }).catch(() => {
                return commit('SAVE_CURRENT_USER', {});
            });
        }
    }
});