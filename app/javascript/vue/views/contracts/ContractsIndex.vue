<template>
    <div class="padded-main-container">
        <div>
            <b-alert :show="error !== ''" variant="danger">{{ error }}</b-alert>
        </div>
        <table class="table borderless">
            <thead>
                <tr>
                    <th class="page-header">
                        <h1>Mis contratos</h1>
                    </th>
                </tr>
            </thead>
        </table>
        <div v-if="contracts.length <= 0">
            <br>
            <b-card>
                <b-card-text>
                    <br>
                    Parece que todavía no tienes ningún contrato.
                    <br><br>
                    <b-button
                        class="btn-purple"
                        :to="{ name: 'NewContract' }"
                    >Añadir contrato</b-button>
                </b-card-text>
            </b-card>
        </div>
        <div v-else>
            <b-row>
                <b-col
                    v-for="(contract, index) in this.contracts"
                    :key="index"
                    cols="6"
                    style="margin-bottom: 15px"
                >
                    <b-card
                        style="width: 100%; height: 331px; max-width: 100%; max-height: 331px"
                        no-body
                        class="overflow-hidden"
                    >
                        <b-row no-gutters style="height: 100%">
                            <b-col md="6" v-if="loadingImages">
                                <b-skeleton-img animation="fade" no-aspect height="331" width="331" />
                            </b-col>
                            <b-col md="6" v-else-if="contract.images && contract.images.length > 0">
                                <b-carousel
                                    style="text-shadow: 0px 0px 2px #000"
                                    fade
                                    indicators
                                    img-width="331"
                                    img-height="331"
                                >
                                    <b-carousel-slide
                                        v-for="(image, i) in contract.images"
                                        :key="i"
                                        :img-src="image"
                                        class="sized-image"
                                    />
                                </b-carousel>
                            </b-col>
                            <b-col md="6" v-else>
                                <div
                                    class="btn show-button"
                                    style="height: 100%; width: 100%"
                                    v-b-modal="`add-image-modal-${index}`"
                                >
                                    <p class="add-image">
                                    Añade una imagen del edificio haciendo click aquí
                                    <b-icon
                                        icon="plus-circle-fill"
                                        aria-hidden="true"
                                        style="color: purple"
                                    ></b-icon>
                                    </p>
                                </div>
                                <b-modal :id="`add-image-modal-${index}`" centered title="Añadir imagen">
                                    Elige una imagen para el contrato: {{ contract.name }}
                                    <br><br>
                                    <b-form-file
                                        v-model="image"
                                        :state="Boolean(image)"
                                        accept=".png, .jpg"
                                        placeholder="Elige una imagen o suéltala aquí..."
                                        drop-placeholder="Suelta una imagen del edificio aquí..."
                                        class="upload-file-input"
                                    ></b-form-file>
                                    <br>
                                    <template #modal-footer="{ cancel }">
                                        <b-button
                                            class="btn-purple"
                                            :disabled="image === null"
                                            @click="uploadImage(contract.id, `add-image-modal-${index}`)">
                                            Subir imagen
                                        </b-button>
                                        <b-button variant="secondary" @click="cancel()">
                                            Cancelar
                                        </b-button>
                                    </template>
                                </b-modal>
                            </b-col>
                            <b-col md="6">
                                <b-card-title style="color: purple; padding-top: 13px">
                                    {{ `${contract.name} (${contract.building_surface} m2)` }}
                                    <hr />
                                </b-card-title>
                                <b-card-text style="text-align: left; margin: 10px">
                                    <p>
                                        Contrato con {{ contract.company_name }} desde 
                                        {{ formatDate(new Date(contract.start_date)) }} 
                                        {{ contract.end_date ? `hasta ${formatDate(new Date(contract.end_date))}` : '' }}
                                    </p>
                                    <p>
                                        {{ `${contract.building_address}, ${contract.building_number}` }}
                                        <br>
                                        {{ `${contract.building_city}, ${contract.building_postal_code}` }}
                                    </p>
                                </b-card-text>
                                <div style="margin: 10px; height: 100%;">
                                    <div class="contract-controls">
                                        <hr>
                                        <b-button
                                            class="btn-purple"
                                            :to="{ name: 'InvoicesIndex', params: { id: contract.id } }"
                                        >Ver facturas</b-button>
                                        <router-link
                                            :to="{ name: 'EditContract', params: { id: contract.id } }"
                                            class="btn show-button"
                                        >
                                            <b-icon
                                                icon="pencil-square"
                                                aria-hidden="true"
                                                style="color: purple"
                                            ></b-icon>
                                        </router-link>
                                    </div>
                                </div>
                            </b-col>
                        </b-row>
                    </b-card>
                </b-col>
            </b-row>
        </div>
    </div>
</template>

<script>
import axios from "axios";

export default {
    data() {
        return {
            contracts: [],
            image: null,
            loadingImages: false,
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
                const response = await axios.get('/contracts');
                if (response.data.success == 'true') {
                    this.contracts = response.data.contracts;
                    this.loadingImages = true;
                    this.fetchImages();
                } else {
                    this.error = response.data.reason.message;
                }
            } catch (error) {
                this.error = error;
            }
        },
        async uploadImage(contractID, modalID) {
            try {
                const formData = new FormData();
                formData.append('image', this.image);
                axios.defaults.headers.common["X-CSRF-Token"] = document
                    .querySelector('meta[name="csrf-token"]')
                    .getAttribute('content');
                const config = { 
                    headers: { 'Content-Type': 'multipart/form-data' },
                    params: { contract_id: contractID }
                };
                const response = await axios.post('/attach_image', formData, config);
                if (response.data.success === 'true') {
                    this.contracts.find(
                        (contract) => contractID === contract.id
                    ).images = [response.data.image_path];
                } else {
                    this.error = response.data.reason.message + ': ' + response.data.details;
                }
            } catch (error) {
                this.error = error;
            }
            this.$bvModal.hide(modalID);
            this.image = null;
        },
        async fetchImages() {
            axios.defaults.headers.common["X-CSRF-Token"] = document
                .querySelector('meta[name="csrf-token"]')
                .getAttribute('content');
            for (let i = 0; i < this.contracts.length; i++) {
                const params = { contract_id: this.contracts[i].id };
                await axios.get('/fetch_images', { params })
                    .then((response) => {
                        if (response.data.success == 'true') {
                            this.contracts[i].images = response.data.images_paths;
                        } else {
                            this.contracts[i].images = [];
                            this.error = 
                                `Images could not be loaded: ${response.data.reason.message}: ${response.data.details}`;
                        }
                    })
                    .catch((error) => {
                        this.error = `Images could not be loaded: ${error}`;
                    });
            }
            this.loadingImages = false;
        },
        formatDate(date) {
            const month = date.getMonth() < 9 ? `0${date.getMonth()+1}` : date.getMonth()+1;
            const day = date.getDate() <= 9 ? `0${date.getDate()}` : date.getDate();
            return `${day}-${month}-${date.getFullYear()}`;
        },
    }
}
</script>
<style scoped>
    .contract-controls {
        bottom: 15px;
        position: absolute;
        width: 100%;
    }

    .add-image {
        position: absolute;
        left: 5%;
        right: 5%;
        top: 40%;
        bottom: 40%;
    }

    .upload-file-button {
        max-width: 70%;
    }

    .sized-image {
        object-fit: cover;
        width: 331px;
        height: 331px;
    }
</style>
