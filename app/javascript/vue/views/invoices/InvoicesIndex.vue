<template>
    <div>
        <div>
            <b-alert :show="error !== ''" variant="danger">{{ error }}</b-alert>
        </div>
        <table class="table borderless">
            <thead>
                <tr>
                    <th class="page-header">
                        <div class="switch-mode">
                            <p
                                class="h4 mb-2 btn show-button"
                                @click="tableMode = false"
                                v-if="tableMode"
                            >
                                <b-icon
                                    icon="graph-up"
                                    style="color: purple"
                                ></b-icon>
                            </p>
                            <p
                                class="h4 mb-2 btn show-button"
                                @click="tableMode = true"
                                v-else
                            >
                                <b-icon
                                    icon="table"
                                    style="color: purple"
                                ></b-icon>
                            </p>
                        </div>
                        <h1 style="color: purple">Mis facturas</h1>
                    </th>
                </tr>
            </thead>
        </table>
        <div class="filter-container">
            <b-row>
                <b-col cols="3" style="display: inline">
                    <b-form-datepicker
                        id="start-date"
                        v-model="filter.startDate"
                        today-button
                        reset-button
                        close-button
                        value-as-date
                        placeholder="Fecha inicial"
                        locale="es"
                    ></b-form-datepicker>
                </b-col>
                <b-col cols="3">
                    <b-form-datepicker
                        id="end-date"
                        v-model="filter.endDate"
                        today-button
                        reset-button
                        close-button
                        value-as-date
                        placeholder="Fecha final"
                        locale="es"
                    ></b-form-datepicker>
                </b-col>
                <b-col cols="4">
                    <b-form-group label-size="md" label-for="filterInput" class="mb-0">
                        <b-input-group size="md">
                            <b-form-input
                                v-model="filter.search"
                                type="search"
                                id="filterInput"
                                placeholder="Type to Search"
                            ></b-form-input>
                        </b-input-group>
                    </b-form-group>
                </b-col>
                <b-col cols="2">
                    <b-form-group>
                        <b-button
                        class="outline-purple"
                        :disabled="!filter"
                        @click="clearFilters"
                        >Clear filters</b-button>
                    </b-form-group>
                </b-col>
            </b-row>
            <b-row style="display: block">
                <p
                    v-if="!showAdvancedFilters"
                    @click="showAdvancedFilters = true"
                    class="underlinable-text"
                >Mostrar filtros avanzados</p>
                <b-card v-if="showAdvancedFilters" class="advanced-filters">
                    <b-row>
                        <b-col cols="6" class="compact-slider">
                            <b>Rango de energía consumida</b>
                            <br><br>
                            <vue-slider
                                id="consumed-energy-filter"
                                v-model="filter.consumedEnergyRange"
                                :min="0"
                                :max="findInvoicesMaxField('current_energy_consumption')"
                                :min-range="findInvoicesMaxField('current_energy_consumption')*5/100"
                                :tooltip-placement="['bottom', 'top']"
                                :enable-cross="false"
                                :tooltip="'active'"
                                :use-keyboard="false"
                            >
                                <template v-slot:tooltip="{ value, focus }">
                                    <div :class="['custom-tooltip', { focus }]">
                                        {{ `${value} ${determineFieldUnit('current_energy_consumption')}` }}
                                    </div>
                                </template>
                            </vue-slider>
                            <br>
                        </b-col>
                        <b-col cols="6" class="compact-slider">
                            <b>Rango del precio de la factura</b>
                            <br><br>
                            <vue-slider
                                id="consumed-energy-filter"
                                v-model="filter.totalPriceRange"
                                :min="0"
                                :max="findInvoicesMaxField('total_price')"
                                :min-range="findInvoicesMaxField('total_price')*5/100"
                                :tooltip-placement="['bottom', 'top']"
                                :enable-cross="false"
                                :tooltip="'active'"
                                :use-keyboard="false"
                            >
                                <template v-slot:tooltip="{ value, focus }">
                                    <div :class="['custom-tooltip', { focus }]">
                                        {{ `${value} ${determineFieldUnit('total_price')}` }}
                                    </div>
                                </template>
                            </vue-slider>
                            <br>
                        </b-col>
                    </b-row>
                </b-card>
                <p
                    v-if="showAdvancedFilters"
                    @click="showAdvancedFilters = false"
                    class="underlinable-text"
                    style="padding-top: 10px"
                >Ocultar filtros avanzados</p>
            </b-row>
        </div>
        <div v-if="tableMode">
            <b-table
                id="invoices-table"
                :items="invoices"
                :fields="fields"
                :per-page="perPage"
                :current-page="currentPage"
                :sort-by.sync="sortBy"
                :sort-desc.sync="sortDesc"
                :filter="filter"
                :filter-function="invoicesFilters"
                @filtered="onFiltered"
                sort-icon-left
                striped
                responsive
                thead-class="table-header"
            >
                <template v-slot:cell(show_invoice)="row">
                    <router-link
                        :to="{ name: 'ShowInvoice', params: { id: row.item.id } }"
                        tag="button"
                        class="btn show-button"
                    >
                        <b-icon
                            icon="eye-fill"
                            aria-hidden="true"
                            style="color: purple"
                        ></b-icon>
                    </router-link>
                </template>
            </b-table>
            <b-pagination
                v-model="currentPage"
                :total-rows="totalRows"
                :per-page="perPage"
                aria-controls="invoices-table"
                align="center"
            ></b-pagination>
        </div>
        <div v-else>
            <LineChart
                :labels="graphicLabels"
                :datasets="graphicData"
                v-if="graphicsFilter.perYear"
            />
            <BarChart
                :labels="graphicLabels"
                :datasets="graphicData"
                v-else
            />
        </div>
    </div>
</template>

<script>
import axios from 'axios';
import Multiselect from "vue-multiselect";
import VueSlider from 'vue-slider-component';
import LineChart from '../../components/LineChart.vue';
import BarChart from '../../components/BarChart.vue';

export default {
    components: {
        Multiselect,
        VueSlider,
        LineChart,
        BarChart,
    },
    data() {
        return {
            invoices: [],
            fieldsByUnit: null,
            user: {},
            error: '',
            fields: [
                { key: 'invoice_number', label: 'Nº Factura', sortable: true },
                { key: 'invoice_reference', label: 'Nº Referencia', sortable: true },
                {
                    key: 'current_energy_consumption',
                    label: 'Energía consumida',
                    sortable: true,
                    formatter: (value, field, _item) => {
                        return `${value} ${this.determineFieldUnit(field)}`.trim();
                    }
                },
                { 
                    key: 'total_price',
                    label: 'Precio total',
                    sortable: true,
                    formatter: (value, field, _item) => {
                        return `${value} ${this.determineFieldUnit(field)}`.trim();
                    }
                },
                
                {
                    key: 'invoice_release_date',
                    label: 'Fecha',
                    sortable: true,
                    formatter: (date, _field, _item) => {
                        return this.formatDate(new Date(date));
                    }
                },
                { key: 'show_invoice', label: '', sortable: false }
            ],
            tableMode: true,
            filter: {
                search: '',
                startDate: undefined,
                endDate: undefined,
                consumedEnergyRange: [0, Number.MAX_VALUE],
                totalPriceRange: [0, Number.MAX_VALUE],
            },
            graphicsFilter: {
                field: 'total_price',
                perYear: true,
            },
            showAdvancedFilters: false,
            perPage: 10,
            currentPage: 1,
            totalRows: 0,
            sortBy: 'invoice_release_date',
            sortDesc: true,
            months: [],
        }
    },
    computed: {
        graphicData: function() {
            const field = this.graphicsFilter.field;
            const label = this.formatFieldName(field);
            const data = this.pluckInvoicesBy(field);
            return [
                {
                    label: label,
                    backgroundColor: '#800080',
                    borderColor: '#9932CC',
                    tension: 0.4,
                    fill: false,
                    data: data
                }
            ];  
        },
        graphicLabels: function() {
            return this.months;
        }
    },
    mounted() {
        this.fetchData();
    },
    methods: {
        async fetchData() {
            this.error = '';
            this.user = this.user = this.$store.state.currentUser;
            try {
                axios.defaults.headers.common["X-CSRF-Token"] = document
                    .querySelector('meta[name="csrf-token"]')
                    .getAttribute('content');
                const response = await axios.get('/invoices');
                if (response.data.success == 'true') {
                    this.invoices = response.data.invoices;
                    this.invoices.sort(this.compareInvoicesDates);
                    this.fieldsByUnit = response.data.fields_by_unit;
                    this.filter.consumedEnergyRange[1] = this.findInvoicesMaxField('current_energy_consumption');
                    this.filter.totalPriceRange[1] = this.findInvoicesMaxField('total_price');
                    this.months = response.data.months;
                } else {
                    this.error = response.data.error;
                }
            } catch (error) {
                this.error = error;
            }
        },
        compareInvoicesDates(invoice1, invoice2) {
            const date1 = new Date(invoice1.invoice_release_date);
            const date2 = new Date(invoice2.invoice_release_date);

            if (date1 === date2) return 0;

            return date1 > date2 ? 1 : -1;
        },
        onFiltered(filteredItems) {
            this.totalRows = filteredItems.length;
            this.currentPage = 1;
        },
        invoicesFilters(item, filter) {
            const searchMatches = Object.keys(item).some(
                (key) => item[key].toString().toLowerCase().indexOf(filter.search.toLowerCase()) > -1
            );

            const releaseDateMatches = 
                new Date(item.invoice_release_date) > (filter.startDate || new Date('1970'))
                && new Date(item.invoice_release_date) < (filter.endDate || new Date());

            const consumedEngeryMatches = this.inRange(parseInt(item.current_energy_consumption), filter.consumedEnergyRange);

            const totalPriceMatches = this.inRange(parseInt(item.total_price), filter.totalPriceRange);
            
            return searchMatches && releaseDateMatches && consumedEngeryMatches && totalPriceMatches;
        },
        clearFilters() {
            this.filter = { 
                search: '',
                startDate: undefined,
                endDate: undefined,
                consumedEnergyRange: [0, this.findInvoicesMaxField('current_energy_consumption')],
                totalPriceRange: [0, this.findInvoicesMaxField('total_price')],
            };
        },
        determineFieldUnit(field) {
            for (const [unit, fields] of Object.entries(this.fieldsByUnit)) {
                if (fields.indexOf(field) > -1) {
                    return unit;
                }
            } 
            return '';
        },
        formatDate(date) {
            return `${date.getDay()}-${date.getMonth()}-${date.getFullYear()}`;
        },
        findInvoicesMaxField(field) {
            return Math.max(...this.invoices.map(invoice => parseInt(invoice[field])));
        },
        inRange(value, range) {
            return value >= range[0] && value <= range[1];
        },
        formatFieldName(name) {
            if (name.indexOf('_') >= 0) {
                let formattedName = '';
                for (const string of name.split('_')) {
                    const firstChar = string.charAt(0).toUpperCase();
                    const remainingString = string.length > 1 ? string.substring(1) : '';
                    formattedName +=  firstChar + remainingString + ' ';
                }
                return formattedName.trim();
            }
            return name.charAt(0).toUpperCase() + name.substring(1);
        },
        pluckInvoicesBy(field) {
            return this.invoices.map(invoice => invoice[field]);
        }
    }
}
</script>

<style>
    @import '../../../packs/stylesheets.scss';

    .custom-tooltip {
        transform: translateY(5px);
        white-space: nowrap;
    }

    .compact-slider {
        padding-left: 3% !important;
        padding-right: 3% !important;
    }

    .page-header {
        display: flex;
        align-items: center;
        justify-content: center;
        border: 0;
    }

    .switch-mode {
        position: absolute;
        left: 7%;
        top: 80px;
        display: flex;
    }
</style>