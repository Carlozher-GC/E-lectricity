<template>
    <div>
        <div>
            <b-alert :show="error !== ''" variant="danger">{{ error }}</b-alert>
        </div>
        <h1 style="color: purple">Factura Nº {{ invoice.invoice_number }}</h1>
        Hola {{ invoice }}
        Error: {{ error }}
    </div>
</template>

<script>
import axios from 'axios';

export default {
    components: {
    },
    data() {
        return {
            user: {},
            invoice: {},
            fieldsByUnit: null,
            error: ''
        }
    },
    mounted() {
        this.fetchData();
    },
    methods: {
        async fetchData() {
            this.error = '';
            this.user = this.$store.state.currentUser;
            try {
                axios.defaults.headers.common["X-CSRF-Token"] = document
                    .querySelector('meta[name="csrf-token"]')
                    .getAttribute('content');
                const response = await axios.get(`/invoices/${this.$route.params.id}`);
                if (response.data.success == 'true') {
                    this.invoice = response.data.invoice;
                    this.fieldsByUnit = response.data.fields_by_unit;
                } else {
                    this.error = response.data.reason.message;
                }
            } catch (error) {
                this.error = error;
            }
        }
    }
}
</script>