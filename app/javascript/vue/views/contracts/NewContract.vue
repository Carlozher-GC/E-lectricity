<template>
    <div>
        <div>
            <b-alert :show="error !== ''" variant="danger">{{ error }}</b-alert>
        </div>
        <div>
            <br>
            <h1 style="color: purple">Añadir un contrato</h1>
            <br>
        </div>
        <div>
            <b-form @reset="resetForm">
                <b-card-group style="text-align: left" deck>
                    <b-card>
                        <b-card-title style="color: purple; text-align: center !important">
                            Información sobre el contrato
                            <hr>
                        </b-card-title>
                        <b-card-body>
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
                            <b-row>
                                <b-col cols="6">
                                    <b-form-group
                                        label="Fecha de inicio:"
                                        label-for="start-date"
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
                                        description="Si el contrato sigue vigente, no es necesario que rellenes este campo ahora."
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

                            <b-form-group
                                label="Nombre de la compañía:" label-for="company-name">
                                <b-form-input
                                    id="company-name"
                                    v-model="contract.company_name"
                                    placeholder="Introduce el nombre de la compañía que aparece en el contrato"
                                    required
                                />
                            </b-form-group>
                        </b-card-body>
                    </b-card>
                    <b-card>
                        <b-card-title style="color: purple; text-align: center !important">
                            Información sobre el edificio o vivienda
                            <hr>
                        </b-card-title>
                        <b-card-body>
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
                                <b-col cols="8">
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
                                <b-col cols="4">
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
                            </b-row>
                            <b-row>
                                <b-col cols="5">
                                    <b-form-group
                                        label="Superficie:" label-for="building-surface">
                                        <b-form-input
                                            id="building-surface"
                                            type='number'
                                            v-model="contract.building_surface"
                                            placeholder="Superficie (en m2)"
                                            required
                                        />
                                    </b-form-group>
                                </b-col>
                                <b-col cols="7" style="text-align: center !important">
                                    <b-button
                                        @click="addContract()"
                                        class="btn-purple form-button"
                                        style="margin-top: 30px !important"
                                    >Añadir contrato</b-button>
                                    <b-button type="reset" variant="danger form-button">Reset</b-button>
                                </b-col>
                            </b-row>
                        </b-card-body>
                    </b-card>
                </b-card-group>
            </b-form>
        </div>
    </div>
</template>

<script>
import axios from "axios";

export default {
    data() {
        return {
            contract: {
                name: null,
                start_date: null,
                end_date: null,
                company_name: null,
                building_address: null,
                building_number: null,
                building_postal_code: null,
                building_city: null,
                building_surface: null,
            },
            error: ''
        }
    },
    methods: {
        async addContract() {
            this.error = '';
            try {
                axios.defaults.headers.common["X-CSRF-Token"] = document
                    .querySelector('meta[name="csrf-token"]')
                    .getAttribute('content');
                const params = { contract: this.contract };
                const response = await axios.post('/add_contract', params);
                if (response.data.success == 'true') {
                    this.$router.push({ name: 'ContractsIndex' });
                } else {
                    this.error = response.data.reason.message + ':\n' + response.data.details;
                    window.scrollTo(0,0);
                }
            } catch (error) {
                this.error = error;
                window.scrollTo(0,0);
            }
        },
        resetForm() {
            this.contract = {
                name: null,
                start_date: null,
                end_date: null,
                company_name: null,
                building_address: null,
                building_number: null,
                building_postal_code: null,
                building_city: null,
                building_surface: null,
            }
        }
    }
}
</script>
<style>
    @import '../../../packs/stylesheets.scss';
</style>