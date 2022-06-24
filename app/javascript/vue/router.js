import Vue from 'vue';
import VueRouter from 'vue-router';

import UserProfile from './views/users/UserProfile.vue';
import ContractsIndex from './views/contracts/ContractsIndex.vue';
import NewContract from './views/contracts/NewContract.vue';
import EditContract from './views/contracts/EditContract.vue';
import UploadInvoice from './views/invoices/UploadInvoice.vue';
import InvoicesIndex from './views/invoices/InvoicesIndex.vue';
import ShowInvoice from './views/invoices/ShowInvoice.vue';
import CompareInvoices from './views/invoices/CompareInvoices.vue';

Vue.use(VueRouter);

const router = new VueRouter({
    mode: 'history',
    base: '#',
    routes: [
        { path: '/profile', component: UserProfile, name: 'UserProfile' },
        { path: '/contracts', component: ContractsIndex, name: 'ContractsIndex' },
        { path: '/add_contract', component: NewContract, name: 'NewContract' },
        { path: '/contracts/:id', component: EditContract, name: 'EditContract' },
        { path: '/upload_invoice', component: UploadInvoice, name: 'UploadInvoice' },
        { path: '/contract/:id/invoices/', component: InvoicesIndex, name: 'InvoicesIndex' },
        { path: '/invoice/:id', component: ShowInvoice, name: 'ShowInvoice' },
        { path: '/compare_invoices', component: CompareInvoices, name: 'CompareInvoices' }
    ]
});

export default router;