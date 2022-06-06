import Vue from 'vue';
import VueRouter from 'vue-router';

import UserProfile from './views/users/UserProfile.vue';
import UploadInvoice from './views/invoices/UploadInvoice.vue';
import InvoicesIndex from './views/invoices/InvoicesIndex.vue';
import ShowInvoice from './views/invoices/ShowInvoice.vue';

Vue.use(VueRouter);

const router = new VueRouter({
    mode: 'history',
    base: '#',
    routes: [
        { path: '/profile', component: UserProfile, name: 'UserProfile' },
        { path: '/upload_invoice', component: UploadInvoice, name: 'UploadInvoice' },
        { path: '/invoices', component: InvoicesIndex, name: 'InvoicesIndex' },
        { path: '/invoice/:id', component: ShowInvoice, name: 'ShowInvoice' }
    ]
});

export default router;