<template>
    <div>
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
            invoice:{},
            error: ''
        }
    },
    mounted() {
        this.fetchData();
    },
    methods: {
        async fetchData() {
            this.user = this.$store.state.currentUser;
            try {
                axios.defaults.headers.common["X-CSRF-Token"] = document
                    .querySelector('meta[name="csrf-token"]')
                    .getAttribute('content');
                const response = await axios.get(`/invoices/${this.$route.params.id}`);
                if (response.data.success == 'true') {
                    this.invoice = response.data.invoice;
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