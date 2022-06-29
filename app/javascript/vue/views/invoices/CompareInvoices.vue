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
                        @input="changeContract"
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
                        <p class="gray-label slider-label">
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
                        <p class="gray-label slider-label">
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
                    <b-col cols="12" class="compact-slider">
                        <br>
                        <p class="gray-label slider-label">
                            Consumo de energía
                            <br>
                        </p>
                        <vue-slider
                            id="energy-consumption-filter"
                            v-model="currentFilter.consumedEnergyRange"
                            :min="0"
                            :max="300000"
                            :min-range="5000"
                            :tooltip-placement="['bottom', 'top']"
                            :enable-cross="false"
                            :tooltip="'always'"
                            :use-keyboard="false"
                        >
                            <template v-slot:tooltip="{ value, focus }">
                                <div :class="['custom-tooltip', { focus }]">
                                    {{ `${value} kWh` }}
                                </div>
                            </template>
                        </vue-slider>
                    </b-col>
                    <b-col cols="12" class="compact-slider">
                        <br>
                        <p class="gray-label slider-label">
                            Coste total
                            <br>
                        </p>
                        <vue-slider
                            id="total-price-filter"
                            v-model="currentFilter.totalPriceRange"
                            :min="0"
                            :max="1000"
                            :min-range="20"
                            :tooltip-placement="['bottom', 'top']"
                            :enable-cross="false"
                            :tooltip="'always'"
                            :use-keyboard="false"
                        >
                            <template v-slot:tooltip="{ value, focus }">
                                <div :class="['custom-tooltip', { focus }]">
                                    {{ `${value} €` }}
                                </div>
                            </template>
                        </vue-slider>
                    </b-col>
                    <b-col cols="12" class="compact-slider">
                        <br>
                        <p class="gray-label slider-label">
                            Coste energía consumida
                            <br>
                        </p>
                        <vue-slider
                            id="consumed-energy-price-filter"
                            v-model="currentFilter.consumedEnergyPriceRange"
                            :min="0"
                            :max="800"
                            :min-range="15"
                            :tooltip-placement="['bottom', 'top']"
                            :enable-cross="false"
                            :tooltip="'always'"
                            :use-keyboard="false"
                        >
                            <template v-slot:tooltip="{ value, focus }">
                                <div :class="['custom-tooltip', { focus }]">
                                    {{ `${value} €` }}
                                </div>
                            </template>
                        </vue-slider>
                    </b-col>
                    <b-col cols="12" class="compact-slider">
                        <br>
                        <p class="gray-label slider-label">
                            Coste potencia contratada
                            <br>
                        </p>
                        <vue-slider
                            id="contracted-power-price-filter"
                            v-model="currentFilter.contractedPowerPriceRange"
                            :min="0"
                            :max="500"
                            :min-range="10"
                            :tooltip-placement="['bottom', 'top']"
                            :enable-cross="false"
                            :tooltip="'always'"
                            :use-keyboard="false"
                        >
                            <template v-slot:tooltip="{ value, focus }">
                                <div :class="['custom-tooltip', { focus }]">
                                    {{ `${value} €` }}
                                </div>
                            </template>
                        </vue-slider>
                    </b-col>
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
                        @click="resetFilter"
                    >Resetear filtro</b-button>
                </b-col>
            </b-row>
        </div>
        <div class="display-container">
            <div class="display-header">
                <h3 style="margin-top: 20px">
                    Comparando por {{ 
                        chartOptions.field.label + ` (${this.determineFieldUnit(chartOptions.field.name)})`
                    }}
                </h3>
            </div>
            <div class="charts-container">
                <div>
                    <b-alert :show="error !== ''" variant="danger" dismissible>{{ error }}</b-alert>
                </div>
                <div v-if="emptyContract" class="invoices-missing">
                    No se encontró ninguna factura que mostrar.
                </div>
                <div v-else style="height: 98%">
                    <b-overlay :show="loadingInvoices" rounded="sm" style="height: 98%">
                        <div style="height: 98%">
                            <BarChart
                                :labels="months"
                                :datasets="chartData"
                                style="height: 98%"
                            />
                        </div>
                    </b-overlay>
                </div>
            </div>
            <div class="display-footer">
                <b-row style="margin: 0 !important">
                    <b-col cols="4"></b-col>
                    <b-col cols="3" class="chart-pagination">
                        <p
                            class="h4 mb-2 btn show-button page-button"
                            :style="
                                nextChartPageEnabled() ?
                                'color: purple' : 'color: gray; border-color: white !important'
                            "
                            @click="nextChartPage()"
                        >
                            <b-icon
                                icon="arrow-left-circle"
                            ></b-icon>
                        </p>
                        <b style="font-size: 1.4rem; color: purple">
                            {{ availableYears[currentYearIndex] }}
                        </b>
                        <p
                            class="h4 mb-2 btn show-button page-button"
                            :style="
                                previousChartPageEnabled() ?
                                'color: purple' : 'color: gray; border-color: white !important'
                            "
                            @click="previousChartPage()"
                        >
                            <b-icon
                                icon="arrow-right-circle"
                            ></b-icon>
                        </p>
                    </b-col>
                    <b-col cols="5">
                        <multiselect
                            v-model="chartOptions.field"
                            :options="filterableFields"
                            open-direction="top"
                            label="label"
                            track-by="name"
                            :searchable="false"
                            :show-labels="false"
                            placeholder="Seleccionar opción"
                            style="width: 60%"
                        />
                    </b-col>
                </b-row>
            </div>
        </div>
    </div>
</template>

<script>
import axios from 'axios';
import Multiselect from "vue-multiselect";
import VueSlider from 'vue-slider-component';
import BarChart from '../../components/BarChart.vue';

export default {
    components: {
        Multiselect,
        VueSlider,
        BarChart,
    },
    data() {
        return {
            error: '',
            filterSection: 'user',
            currentFilter: null,
            filters: [],
            currentDataset: null,
            contracts: null,
            contract: null,
            loadingInvoices: false,
            invoices: [],
            userCountries: [],
            isLoadingCountries: false,
            contractCities: [],
            isLoadingCities: false,
            contractCompanies: [],
            isLoadingCompanies: false,
            months: [],
            fieldsByUnit: {},
            availableYears: [],
            currentYearIndex: 0,
            chartOptions: { 
                field: { name: 'total_price', label: 'Precio total' }
            },
            filterableFields: [
                { name: 'total_price', label: 'Precio total' }, 
                { name: 'current_energy_consumption', label: 'Energía consumida' }, 
                { name: 'contracted_power_price', label: 'Coste potencia contratada' },
                { name: 'consumed_energy_price', label: 'Coste energía consumida' }
            ],
        }
    },
    mounted() {
        this.currentFilter = this.newFilter();
        this.fetchData();
    },
    computed: {
        chartData: function() {
            const field = this.chartOptions.field.name;
            const year = this.availableYears[this.currentYearIndex]
            
            const datasets = [ 
                {
                    label: this.contract.name,
                    backgroundColor: '#800080',
                    borderColor: '#9932CC',
                    tension: 0.4,
                    fill: false,
                    data: this.pluckCurrentYearInvoicesBy(field)
                }
            ];
            if (this.currentDataset)
                datasets.push({
                    label: 'Contratos filtrados',
                    backgroundColor: '#659CD7',
                    borderColor: '#618FC1',
                    tension: 0.4,
                    fill: false,
                    data: this.currentDataset[year][field]
                });
            
            return datasets;
        },
        emptyContract: function () {
            return !this.loadingInvoices && (!this.invoices || this.invoices.length < 1)
        }
    },
    methods: {
        async fetchData() {
            axios.defaults.headers.common["X-CSRF-Token"] = document
                .querySelector('meta[name="csrf-token"]')
                .getAttribute('content');
            await this.fetchContracts();
            this.loadingInvoices = true;
            if (this.contract) this.fetchInvoices();
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
        async fetchInvoices() {
            try {
                const params = { contract_id: this.contract.id };
                const response = await axios.get('/invoices', { params });
                if (response.data.success == 'true') {
                    this.invoices = response.data.invoices;
                    this.fieldsByUnit = response.data.fields_by_unit;
                    this.months = response.data.months;
                    this.pluckAvailableYears().forEach(year => this.availableYears.push(year));
                    this.availableYears.sort((year1, year2) => {
                        if (parseInt(year1) < parseInt(year2)) return 1;
                        if (parseInt(year1) > parseInt(year2)) return -1;
                        return 0;
                    });
                } else {
                    this.error = response.data.reason.message;
                }
            } catch (error) {
                this.error = error;
            }
            this.loadingInvoices = false;
        },
        async updateCurrentFilter() {
            this.loadingInvoices = true;
            try {
                const params = { filter: this.currentFilter, years: this.availableYears };
                const response = await axios.get('/invoices_dataset', { params });
                if (response.data.success == 'true') {
                    this.currentDataset = response.data.dataset;
                } else {
                    this.error = response.data.reason.message;
                }
            } catch (error) {
                this.error = error;
            }
            this.loadingInvoices = false;
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
        pluckCurrentYearInvoicesBy(field) {
            const currentYear = this.availableYears[this.currentYearIndex];
            const currentYearInvoices = new Array(11).fill(NaN);
            this.invoices.forEach((invoice) => {
                const releaseDate = new Date(invoice.invoice_release_date);
                if (releaseDate.getFullYear() === currentYear) 
                    currentYearInvoices[releaseDate.getMonth()] = invoice[field];
            });
            return currentYearInvoices;
        },
        pluckAvailableYears() {
            return new Set(this.invoices.map(
                invoice => new Date(invoice['invoice_release_date']).getFullYear()
            ));
        },
        changeContract(contract, id) {
            this.loadingInvoices = true;
            this.contract = contract;
            this.fetchInvoices();
        },
        nextChartPage() {
            if (this.nextChartPageEnabled()) {
                this.currentYearIndex++;
            }
        },
        previousChartPage() {
            if (this.previousChartPageEnabled()) {
                this.currentYearIndex--;
            }
        },
        nextChartPageEnabled() {
            return this.currentYearIndex < this.availableYears.length - 1;
        },
        previousChartPageEnabled() {
            return this.currentYearIndex > 0;
        },
        resetFilter() {
            this.currentFilter = this.newFilter();
        },
        newFilter() {
            return {
                ageRange: [18, 130],
                userCountries: [],
                contractCompanies: [],
                contractCities: [],
                startDate: null,
                endDate: null,
                surfaceRange: [0, 500],
                consumedEnergyRange: [0, 300000],
                totalPriceRange: [0, 1000],
                contractedPowerPriceRange: [0, 500],
                consumedEnergyPriceRange: [0, 800]
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
        determineFieldUnit(field) {
            for (const [unit, fields] of Object.entries(this.fieldsByUnit)) {
                if (fields.indexOf(field) > -1) {
                    return unit;
                }
            } 
            return '';
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
        border-right: 2px solid rgba(0,0,0,.1);
        border-bottom: 0!important;
        order: 0;
        flex: 0 0 30%;
        max-width: 30%;
        width: 100%;
        padding-right: 15px;
        padding-left: 15px;
    }

    .display-container {
        max-width: 70%;
        width: 100%;
        color: purple;
    }

    .display-header {
        width: 100%;
        position: sticky;
        z-index: 1;
        border-bottom: 2px solid rgba(0,0,0,.1);
        height: 75px;
    }

    .display-footer {
        border-top: 2px solid rgba(0,0,0,.1);
        position: absolute;
        bottom: 15px;
        left: 30%;
        width: 100%;
        max-width: 70%;
        height: 75px;
        margin: 0;
        z-index: 1;
        padding-top: 10px;
    }

    .charts-container {
        width: 100%;
        height: calc(100% - 150px);
        margin: auto;
        overflow-y: scroll;
        z-index: 0;
        padding-right: 15px;
        padding-left: 15px;
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

    .slider-label {
        margin-left: -8%; 
        margin-bottom: 20px;
    }

    .invoices-missing {
        color: red;
        position: absolute;
        bottom: calc((100% - 5px)/2);
        right: calc(70%/3);
    }
</style>
<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>