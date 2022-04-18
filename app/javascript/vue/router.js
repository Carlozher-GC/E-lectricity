import Vue from 'vue';
import VueRouter from 'vue-router';

import UserProfile from './views/UserProfile.vue';
import UploadInvoice from './views/UploadInvoice.vue';

Vue.use(VueRouter);

const router = new VueRouter({
    mode: 'history',
    base: '#',
    routes: [
        { path: '/profile', component: UserProfile, name: 'UserProfile' },
        { path: '/upload_invoice', component: UploadInvoice, name: 'UploadInvoice'}
    ]
});

export default router;