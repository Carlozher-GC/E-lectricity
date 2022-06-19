<template>
    <div>
        <br>
        <h1 style="color: purple">Editar contrato</h1>
        <div>
            <b-alert :show="error !== ''" variant="danger">{{ error }}</b-alert>
        </div>
        <br>
        <div v-if="contract">
            <b-card
                class="overflow-hidden"
                style="width: 97%; margin: auto"
                no-body
            >
                <b-row no-gutters style="height: 100%">
                    <b-col md="7">
                        <b-card-body style="text-align: left;">
                            <b-row>
                                <b-col cols="8">
                                    <b-form-group
                                        label="Nombre del contrato:"
                                        label-for="name"
                                        description="El nombre debe ser único. Escoge uno que identifique fácilmente el contrato."
                                    >
                                        <b-form-input
                                            id="name"
                                            v-model="contract.name"
                                            placeholder="Introduce un nombre para el contrato nuevo"
                                            required
                                        />
                                    </b-form-group>
                                </b-col>
                                <b-col cols="4">
                                    <b-form-group
                                        label="Nombre de la compañía:" label-for="company-name">
                                        <b-form-input
                                            id="company-name"
                                            v-model="contract.company_name"
                                            placeholder="Introduce el nombre de la compañía que aparece en el contrato"
                                            required
                                        />
                                    </b-form-group>
                                </b-col>
                            </b-row>
                            <b-row>
                                <b-col cols="6">
                                    <b-form-group
                                        label="Fecha de inicio:"
                                        label-for="start-date"
                                        style="margin-bottom: 0"
                                    >
                                        <b-form-input
                                            id="start-date"
                                            type="date"
                                            v-model="contract.start_date"
                                            placeholder="Introduce la fecha de inicio del contrato"
                                            required
                                        />
                                    </b-form-group>
                                </b-col>
                                <b-col cols="6">
                                    <b-form-group
                                        label="Fecha de finalización:"
                                        label-for="end-date"
                                        description="Si el contrato sigue vigente, este campo no es obligatorio."
                                        style="margin-bottom: 0"
                                    >
                                        <b-form-input
                                            id="end-date"
                                            type="date"
                                            v-model="contract.end_date"
                                            placeholder="Introduce la fecha de finalización del contrato"
                                        />
                                    </b-form-group>
                                </b-col>
                            </b-row>
                            <hr>
                            <b-row>
                                <b-col cols="9">
                                    <b-form-group
                                        label="Dirección:"
                                        label-for="building-address"
                                    >
                                        <b-form-input
                                            id="building-address"
                                            v-model="contract.building_address"
                                            placeholder="Introduce la dirección de edificio o vivienda"
                                            required
                                        />
                                    </b-form-group>
                                </b-col>

                                <b-col cols="3">
                                    <b-form-group
                                        label="Nº:"
                                        label-for="building-number"
                                    >
                                        <b-form-input
                                            id="building-address"
                                            v-model="contract.building_number"
                                            placeholder="Número"
                                            required
                                        />
                                    </b-form-group>
                                </b-col>
                            </b-row>
                            <b-row>
                                <b-col cols="6">
                                    <b-form-group
                                        label="Ciudad o población:" label-for="building-city">
                                        <b-form-input
                                            id="building-city"
                                            v-model="contract.building_city"
                                            placeholder="Ciudad o población en la que se encuentra el edificio"
                                            required
                                        />
                                    </b-form-group>
                                </b-col>
                                <b-col cols="3">
                                    <b-form-group
                                        label="Código postal:"
                                        label-for="building-postal-code"
                                    >
                                        <b-form-input
                                            id="building-postal-code"
                                            v-model="contract.building_postal_code"
                                            placeholder="Código postal"
                                            required
                                        />
                                    </b-form-group>
                                </b-col>
                                <b-col cols="3">
                                    <b-form-group
                                        label="Superficie (m2):" label-for="building-surface">
                                        <b-form-input
                                            id="building-surface"
                                            type='number'
                                            v-model="contract.building_surface"
                                            placeholder="Superficie (en m2)"
                                            required
                                        />
                                    </b-form-group>
                                </b-col>
                            </b-row>
                            <b-row>
                                <b-col cols="6" style="text-align: center !important">
                                    <b-button
                                        @click="updateContract()"
                                        class="btn-purple form-button"
                                        style="margin-top: 30px !important"
                                    >Confirmar cambios</b-button>
                                </b-col>
                                <b-col cols="6" style="text-align: center !important">
                                    <b-button
                                        v-b-modal="'add-image-modal'"
                                        class="btn-purple form-button"
                                        style="margin-top: 30px !important"
                                    >Añadir otra imagen</b-button>
                                </b-col>
                            </b-row>
                        </b-card-body>
                    </b-col>

                    <b-col md="5" v-if="loadingImages">
                        <b-skeleton-img animation="fade" no-aspect />
                    </b-col>
                    <b-col md="5" v-else-if="contract.images && contract.images.length > 0">
                        <b-carousel
                            style="text-shadow: 0px 0px 2px #000; max-height: 100%; max-width: 100%"
                            fade
                            indicators
                        >
                            <b-carousel-slide
                                v-for="(image, i) in contract.images"
                                :key="i"
                                :img-src="image"
                            />
                        </b-carousel>
                    </b-col>
                    <b-col md="5" v-else>
                        <div
                            class="btn show-button"
                            style="height: 100%; width: 100%; text-align: center !important;"
                            v-b-modal="'add-image-modal'"
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
                    </b-col>
                </b-row>
            </b-card>
            <br>
            <b-modal id="add-image-modal" centered title="Añadir imagen">
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
                        @click="uploadImage(contract.id, 'add-image-modal')">
                        Subir imagen
                    </b-button>
                    <b-button variant="secondary" @click="cancel()">
                        Cancelar
                    </b-button>
                </template>
            </b-modal>
        </div>
    </div>
</template>

<script>
import axios from "axios";

export default {
    data() {
        return {
            contract: null,
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
                const response = await axios.get(`/contracts/${this.$route.params.id}`);
                if (response.data.success == 'true') {
                    this.contract = response.data.contract;
                    this.contract.start_date = this.formatDate(new Date(this.contract.start_date));
                    if (this.contract.end_date) this.contract.end_date = this.formatDate(new Date(this.contract.end_date));
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
                    this.contract.images.push(response.data.image_path);
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
            this.loadingImages = true;
            const params = { contract_id: this.contract.id };
            axios.get('/fetch_images', { params })
                .then((response) => {
                    if (response.data.success == 'true') {
                        this.contract.images = response.data.images_paths;
                    } else {
                        this.contract.images = [];
                        this.error = 
                            `Images could not be loaded: ${response.data.reason.message}: ${response.data.details}`;
                    }
                    this.loadingImages = false;
                })
                .catch((error) => {
                    this.error = `Images could not be loaded: ${error}`;
                });
        },
        formatDate(date) {
            const month = date.getMonth() < 9 ? `0${date.getMonth()+1}` : date.getMonth()+1;
            const day = date.getDate() <= 9 ? `0${date.getDate()}` : date.getDate();
            return `${date.getFullYear()}-${month}-${day}`;
        },
        async updateContract() {
            axios.defaults.headers.common["X-CSRF-Token"] = document
                .querySelector('meta[name="csrf-token"]')
                .getAttribute('content');
            const params = { contract: this.contract };
            try {
                const response = await axios.patch(`/contracts/${this.contract.id}`, params);
                if (response.data.success == 'true') {
                    this.$router.push({ name: 'ContractsIndex' });
                } else {
                    this.error = 
                        `Contract could not be updated: ${response.data.reason.message}: ${response.data.details}`;
                }
            } catch (error) {
                this.error = `Contract could not be updated: ${error}`;
            }
        },
    }
}
</script>
<style>
    @import '../../../packs/stylesheets.scss';

    small {
        font-size: 70% !important;
    }

    .contract-controls {
        bottom: 15px;
        position: absolute;
        width: 100%;
    }

    .add-image {
        position: absolute;
        left: 5%;
        right: 5%;
        top: 45%;
        bottom: 45%;
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
