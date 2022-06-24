<template>
    <div class="padded-main-container">
        <br>
        <div>
            <b-alert :show="error !== ''" variant="danger">{{ error }}</b-alert>
        </div>
        <br>
        <b-card
            style="color: purple; width: 60%; margin: auto"
            v-if="user"
        >
            <b-card-title>
                <h4>Perfil de {{ user.username }}</h4>
                <hr>
            </b-card-title>
            <b-card-body>
                <b-row>
                    <b-col cols="6">
                        <p>Nombre:</p>
                        <b-form-input
                            id="first-name"
                            type="text"
                            v-model="user.first_name"
                            disabled
                        />
                    </b-col>
                    <b-col cols="6">
                        <p>Apellidos:</p>
                        <b-form-input
                            id="last-name"
                            type="text"
                            v-model="user.last_name"
                            disabled
                        />
                    </b-col>
                </b-row>
                <br>
                <b-row>
                    <b-col cols="6">
                        <p>Email:</p>
                        <b-form-input
                            id="email"
                            type="text"
                            v-model="user.email"
                            disabled
                        />
                    </b-col>
                    <b-col cols="6">
                        <p>Teléfono:</p>
                        <b-form-input
                            id="phone"
                            type="text"
                            v-model="user.phone"
                            disabled
                        />
                    </b-col>
                </b-row>
                <br>
                <b-row style="display: block">
                    <b-col cols="6" style="margin: auto">
                        <p style="text-align: center">Fecha de nacimiento:</p>
                        <b-form-input
                            id="email"
                            type="date"
                            v-model="user.birthday"
                            disabled
                        />
                    </b-col>
                </b-row>
            </b-card-body>
        </b-card>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    data() {
        return {
            user: null,
            error: ''
        }
    },
    mounted() {
        this.fetchData();
    },
    methods: {
        async fetchData() {
            axios.defaults.headers.common["X-CSRF-Token"] = document
                .querySelector('meta[name="csrf-token"]')
                .getAttribute('content');
            try {    
                const response = await axios.get('/current_user');
                this.user = response.data;
                this.user.birthday = this.formatDate(new Date(this.user.birthday));
            } catch (error) {
                this.error = error;
            }
        },
        formatDate(date) {
            const month = date.getMonth() < 9 ? `0${date.getMonth()+1}` : date.getMonth()+1;
            const day = date.getDate() <= 9 ? `0${date.getDate()}` : date.getDate();
            return `${date.getFullYear()}-${month}-${day}`;
        },
    }
}
</script>

<style scoped>
    p {
        text-align: left;
    }
</style>