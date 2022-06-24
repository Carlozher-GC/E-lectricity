<template>
    <div class="compare-invoices-container">
        <div
            class="filters-sidebar"
            v-if="currentFilter"
        >
            <b-row class="filters-header">
                <b-col cols="12">
                    <br>
                    <p class="filter-label">Mi contrato</p>
                    <multiselect
                        v-model="contract"
                        :options="contracts || []"
                        label="name"
                        track-by="name"
                        :searchable="false"
                        :show-labels="false"
                        placeholder="Selecciona un contrato"
                        :allow-empty="false"
                        :loading="contracts === null"
                    />
                    <br>
                </b-col>
                <b-col cols="12">
                    <b-nav tabs fill>
                        <b-nav-item :active="filterSection == 'user'" @click="filterSection = 'user'">
                            Filtros de usuario
                        </b-nav-item>
                        <b-nav-item :active="filterSection == 'contract'" @click="filterSection = 'contract'">
                            Filtros de contrato
                        </b-nav-item>
                        <b-nav-item :active="filterSection == 'invoice'" @click="filterSection = 'invoice'">
                            Filtros de factura
                        </b-nav-item>
                    </b-nav>
                    <br>
                </b-col>
            </b-row>
            <div class="filters-inputs">
                <b-row v-if="filterSection === 'user'" class="filter-inputs-row">
                    <b-col cols="12">
                        <label class="gray-label" for="user-countries">
                            Países de origen de l@s propietari@s
                        </label>
                        <multiselect
                            id="user-countries"
                            v-model="currentFilter.userCountries"
                            placeholder="Escribe para buscar un país"
                            open-direction="bottom"
                            :options="userCountries"
                            :multiple="true"
                            :searchable="true"
                            :loading="isLoadingCountries"
                            :internal-search="false"
                            :clear-on-select="false"
                            :close-on-select="false"
                            :options-limit="300"
                            :limit="3"
                            :limit-text="countriesLimitText"
                            :max-height="600"
                            :show-no-results="false"
                            :hide-selected="true"
                            @search-change="findUserCountries"
                        >
                            <template slot="tag" slot-scope="{ option, remove }">
                                <span class="custom-tag">
                                    <span>{{ option }}</span>
                                    <span class="custom-remove" @click="remove(option)">❌</span>
                                </span>
                            </template>
                            <template slot="clear" slot-scope="props">
                                <div
                                    class="multiselect-clear"
                                    v-if="currentFilter.userCountries.length"
                                    @mousedown.prevent.stop="clearUserCountries(props.search)"
                                />
                            </template>
                            <span slot="noResult">Sin resultados, prueba a cambiar la búsqueda.</span>
                        </multiselect>
                    </b-col>
                    <b-col cols="12" class="compact-slider">
                        <br>
                        <p class="gray-label" style="margin-left: -8%; margin-bottom: 20px;">
                            Edad del propietari@
                            <br>
                        </p>
                        <vue-slider
                            id="age-range-filter"
                            v-model="currentFilter.ageRange"
                            :min="18"
                            :max="130"
                            :min-range="5"
                            :tooltip-placement="['bottom', 'top']"
                            :enable-cross="false"
                            :tooltip="'always'"
                            :use-keyboard="false"
                        >
                            <template v-slot:tooltip="{ value, focus }">
                                <div :class="['custom-tooltip', { focus }]">
                                    {{ `${value} años` }}
                                </div>
                            </template>
                        </vue-slider>
                    </b-col>
                </b-row>
                <b-row v-else-if="filterSection === 'contract'" class="filter-inputs-row">
                    <b-col cols="12">
                        <p class="filter-label" style="font-size: .875rem">Contratos entre</p>
                        <b-row>
                            <b-col cols="6" style="display: inline">
                                <b-form-datepicker
                                    id="start-date"
                                    v-model="currentFilter.startDate"
                                    today-button
                                    reset-button
                                    close-button
                                    value-as-date
                                    placeholder="Fecha inicial"
                                    locale="es"
                                ></b-form-datepicker>
                            </b-col>
                            <b-col cols="6">
                                <b-form-datepicker
                                    id="end-date"
                                    v-model="currentFilter.endDate"
                                    today-button
                                    reset-button
                                    close-button
                                    value-as-date
                                    placeholder="Fecha final"
                                    locale="es"
                                ></b-form-datepicker>
                            </b-col>
                        </b-row>
                        <br>
                    </b-col>
                    <b-col cols="12">
                        <label class="gray-label" for="contracts-companies">
                            Compañías
                        </label>
                        <multiselect
                            id="contracts-companies"
                            v-model="currentFilter.contractCompanies"
                            placeholder="Escribe para buscar una compañía"
                            open-direction="bottom"
                            :options="contractCompanies"
                            :multiple="true"
                            :searchable="true"
                            :loading="isLoadingCompanies"
                            :internal-search="false"
                            :clear-on-select="false"
                            :close-on-select="false"
                            :options-limit="300"
                            :limit="3"
                            :limit-text="companiesLimitText"
                            :max-height="600"
                            :show-no-results="false"
                            :hide-selected="true"
                            @search-change="findContractCompanies"
                        >
                            <template slot="tag" slot-scope="{ option, remove }">
                                <span class="custom-tag">
                                    <span>{{ option }}</span>
                                    <span class="custom-remove" @click="remove(option)">❌</span>
                                </span>
                            </template>
                            <template slot="clear" slot-scope="props">
                                <div
                                    class="multiselect-clear"
                                    v-if="currentFilter.contractCompanies.length"
                                    @mousedown.prevent.stop="clearContractCompanies(props.search)"
                                />
                            </template>
                            <span slot="noResult">Sin resultados, prueba a cambiar la búsqueda.</span>
                        </multiselect>
                    </b-col>
                    <b-col cols="12">
                        <label class="gray-label" for="contracts-cities">
                            Localización del edificio
                        </label>
                        <multiselect
                            id="contracts-cities"
                            v-model="currentFilter.contractCities"
                            placeholder="Escribe para buscar una ciudad"
                            open-direction="bottom"
                            :options="contractCities"
                            :multiple="true"
                            :searchable="true"
                            :loading="isLoadingCities"
                            :internal-search="false"
                            :clear-on-select="false"
                            :close-on-select="false"
                            :options-limit="300"
                            :limit="3"
                            :limit-text="citiesLimitText"
                            :max-height="600"
                            :show-no-results="false"
                            :hide-selected="true"
                            @search-change="findContractCities"
                        >
                            <template slot="tag" slot-scope="{ option, remove }">
                                <span class="custom-tag">
                                    <span>{{ option }}</span>
                                    <span class="custom-remove" @click="remove(option)">❌</span>
                                </span>
                            </template>
                            <template slot="clear" slot-scope="props">
                                <div
                                    class="multiselect-clear"
                                    v-if="currentFilter.contractCities.length"
                                    @mousedown.prevent.stop="clearContractCities(props.search)"
                                />
                            </template>
                            <span slot="noResult">Sin resultados, prueba a cambiar la búsqueda.</span>
                        </multiselect>
                    </b-col>
                    <b-col cols="12" class="compact-slider">
                        <br>
                        <p class="gray-label" style="margin-left: -8%; margin-bottom: 20px;">
                            Superficie del edificio
                            <br>
                        </p>
                        <vue-slider
                            id="age-range-filter"
                            v-model="currentFilter.surfaceRange"
                            :min="0"
                            :max="500"
                            :min-range="20"
                            :tooltip-placement="['bottom', 'top']"
                            :enable-cross="false"
                            :tooltip="'always'"
                            :use-keyboard="false"
                        >
                            <template v-slot:tooltip="{ value, focus }">
                                <div :class="['custom-tooltip', { focus }]">
                                    {{ `${value} m2` }}
                                </div>
                            </template>
                        </vue-slider>
                    </b-col>
                </b-row>
                <b-row v-else class="filter-inputs-row">

                </b-row>
            </div>
            <b-row class="filters-controls">
                <b-col cols="12">
                    <br>
                    <hr>
                    <b-button
                        class="outline-purple"
                        @click="updateCurrentFilter"
                    >Actualizar filtro</b-button>
                    <b-button
                        class="outline-purple"
                        @click="addFilter"
                    >Añadir filtro</b-button>
                </b-col>
            </b-row>
        </div>
        <div class="charts-container">
            <div>
                <b-alert :show="error !== ''" variant="danger">{{ error }}</b-alert>
            </div>
        </div>
    </div>
</template>

<script>
import axios from 'axios';
import Multiselect from "vue-multiselect";
import VueSlider from 'vue-slider-component';
import LineChart from '../../components/LineChart.vue';

export default {
    components: {
        Multiselect,
        VueSlider,
        LineChart,
    },
    data() {
        return {
            error: '',
            filterSection: 'user',
            currentFilter: null,
            filters: [],
            contracts: null,
            contract: null,
            userCountries: [],
            isLoadingCountries: false,
            contractCities: [],
            isLoadingCities: false,
            contractCompanies: [],
            isLoadingCompanies: false,
        }
    },
    mounted() {
        this.currentFilter = this.newFilter();
        this.fetchData();
    },
    methods: {
        async fetchData() {
            axios.defaults.headers.common["X-CSRF-Token"] = document
                .querySelector('meta[name="csrf-token"]')
                .getAttribute('content');
            this.fetchContracts();
        },
        async fetchContracts() {
            try {    
                const response = await axios.get('/contracts');
                this.contracts = response.data.contracts;
                this.contract = this.contracts[0];
            } catch (error) {
                this.error = error;
            }
        },
        async findUserCountries(query) {
            if (query === '') return;
            this.isLoadingCountries = true
            axios.get('/user_countries', { params: { query } })
                .then(response => {
                    this.userCountries = response.data.countries;
                    this.isLoadingCountries = false;
                })
                .catch(error => {
                    this.error = error;
                    this.userCountries = [];
                    this.isLoadingCountries = false;
                });
        },
        async findContractCompanies(query) {
            if (query === '') return;
            this.isLoadingCompanies = true
            axios.get('/contract_companies', { params: { query } })
                .then(response => {
                    this.contractCompanies = response.data.companies;
                    this.isLoadingCompanies = false;
                })
                .catch(error => {
                    this.error = error;
                    this.contractCompanies = [];
                    this.isLoadingCompanies = false;
                });
        },
        async findContractCities(query) {
            if (query === '') return;
            this.isLoadingCities = true
            axios.get('/contract_cities', { params: { query } })
                .then(response => {
                    this.contractCities = response.data.cities;
                    this.isLoadingCities = false;
                })
                .catch(error => {
                    this.error = error;
                    this.contractCities = [];
                    this.isLoadingCities = false;
                });
        },
        updateCurrentFilter() {

        },
        addFilter() {

        },
        newFilter() {
            return {
                ageRange: [18, 130],
                userCountries: [],
                contractCompanies: [],
                contractCities: [],
                startDate: null,
                endDate: null,
                surfaceRange: [0, 500]
            }
        },
        clearUserCountries() {
            this.currentFilter.userCountries = [];
        },
        clearContractCompanies() {
            this.currentFilter.contractCompanies = [];
        },
        clearContractCities() {
            this.currentFilter.contractCities = [];
        },
        countriesLimitText(count) {
            return `y ${count} países más`;
        },
        companiesLimitText(count) {
            return `y ${count} compañías más`;
        },
        citiesLimitText(count) {
            return `y ${count} ciudades más`;
        },
    }
}
</script>

<style scoped>
    a {
        color: purple;
        font-size: 0.875rem;
        padding: 0.5rem 0.5rem !important;
    }

    a:hover {
        color: rgb(163, 69, 163);
        font-size: 0.875rem;
        padding: 0.5rem 0.5rem !important;
    }

    .compare-invoices-container {
        display: flex;
        flex-wrap: wrap;
    }

    .compare-invoices-title {
        width: 100%;
    }

    .filters-sidebar {
        color: purple;
        position: sticky;
        top: 4rem;
        z-index: 1;
        height: calc(100vh - 4rem);
        border-right: 1px solid rgba(0,0,0,.1);
        border-bottom: 0!important;
        order: 0;
        flex: 0 0 30%;
        max-width: 30%;
        width: 100%;
        padding-right: 15px;
        padding-left: 15px;
    }

    .charts-container {
        width: 70%;
    }

    .compact-slider {
        padding: 0 10% 10% 10% !important;
    }

    .custom-tooltip {
        transform: translateY(5px);
        white-space: nowrap;
        font-size: .875rem;
    }

    .filter-label {
        color: purple;
        padding-bottom: 5px;
    }

    .filters-header {
        height: 210px;
        z-index: 1;
    }

    .filters-inputs {
        width: 100%;
        height: calc(100% - 320px);
        overflow-y: scroll;
        z-index: 0;
    }

    .filters-controls {
        position: absolute;
        bottom: 15px;
        right: 0;
        width: 100%;
        height: 110px;
        margin: 0;
        z-index: 1;
    }

    .filter-inputs-row {
        margin-right: auto;
    }
</style>
<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>