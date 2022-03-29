import Vue from 'vue';
import VueRouter from 'vue-router';

import UserProfile from './views/UserProfile.vue';

Vue.use(VueRouter);

const router = new VueRouter({
    mode: 'history',
    base: '#',
    routes: [
        { path: '/profile', component: UserProfile, name: 'UserProfile' },
    ]
});

export default router;