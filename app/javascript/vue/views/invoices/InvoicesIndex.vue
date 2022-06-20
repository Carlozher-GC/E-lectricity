<template>
    <div>
        <div v-if="invoices.length <= 0">
            <br>
            <b-card>
                <b-card-text>
                    <br>
                    Parece que todavía no has subido ninguna factura para este contrato.
                    <br><br>
                    <b-button
                        class="btn-purple"
                        :to="{ name: 'UploadInvoice', params: { contract_id: this.$route.params.id } }"
                    >Subir factura</b-button>
                </b-card-text>
            </b-card>
        </div>
        <div v-else>
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
                                    @click="{ 
                                        tableMode = true;
                                        missingInvoices = false;
                                    }"
                                    v-else
                                >
                                    <b-icon
                                        icon="table"
                                        style="color: purple"
                                    ></b-icon>
                                </p>
                            </div>
                            <h1>Mis facturas</h1>
                            <div class="upload-invoice-button">
                                <p
                                    class="h4 mb-2 btn show-button"
                                    @click="$router.push(
                                        { name: 'UploadInvoice', params: { contract_id: $route.params.id } })"
                                >
                                    <b-icon
                                        icon="plus-circle"
                                        style="color: purple"
                                    ></b-icon>
                                </p>
                            </div>
                        </th>
                    </tr>
                </thead>
                <div>
                    <b-alert :show="missingInvoices" variant="warning" dismissible @dismissed="missingInvoices = false">
                        Ups! Parece que faltan algunas facturas para el año {{ availableYears[currentChartPage] }}.
                        Haz click <b-link :to="{ name: 'UploadInvoice' }">aquí</b-link> para subirlas.
                    </b-alert>
                </div>
            </table>
            <div v-if="tableMode" id="table-mode">
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
                <div>
                    <b-table
                        id="invoices-table"
                        :items="invoices"
                        :fields="fields"
                        :per-page="perPage"
                        :current-page="currentTablePage"
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
                        v-model="currentTablePage"
                        :total-rows="totalRows"
                        :per-page="perPage"
                        aria-controls="invoices-table"
                        align="center"
                    ></b-pagination>
                </div>
            </div>
            <div v-else id="graphic-mode">
                <div class="filter-container">
                    <b-row style="display: flex">
                        <b-col>
                            <b-button
                                @click="{
                                    currentChartPage = 0;
                                    missingInvoices = !chartFilter.perYear;
                                    chartFilter.perYear = !chartFilter.perYear;
                                }"
                                class="outline-purple"
                                button
                            >
                                {{ chartFilter.perYear ? 'Ver todas las facturas' : 'Ver facturas por año' }}
                            </b-button>
                        </b-col>
                        <b-col>
                            <multiselect
                                v-model="chartFilter.field"
                                :options="filterableFields"
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
                <div>
                    <LineChart
                        :labels="chartLabels"
                        :datasets="chartData"
                        v-if="chartFilter.perYear"
                    />
                    <BarChart
                        :labels="chartLabels"
                        :datasets="chartData"
                        v-else
                    />
                </div>
                <div class="chart-pagination">
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
                        {{ 
                            chartFilter.perYear
                            ? availableYears[currentChartPage]
                            : Math.ceil(invoices.length/maxInvoicesPerChart) - currentChartPage
                        }}
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
                </div>
            </div>
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
            fieldsByUnit: {},
            availableYears: [],
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
            tableMode: false,
            filter: {
                search: '',
                startDate: undefined,
                endDate: undefined,
                consumedEnergyRange: [0, Number.MAX_VALUE],
                totalPriceRange: [0, Number.MAX_VALUE],
            },
            chartFilter: {
                field: { name: 'total_price', label: 'Precio total' },
                perYear: false,
            },
            filterableFields: [
                { name: 'total_price', label: 'Precio total' }, 
                { name: 'current_energy_consumption', label: 'Energía consumida' }
            ],
            showAdvancedFilters: false,
            perPage: 10,
            currentTablePage: 1,
            totalRows: 0,
            sortBy: 'invoice_release_date',
            sortDesc: true,
            months: [],
            currentChartPage: 0,
            maxInvoicesPerChart: 12,
            missingInvoices: false,
        }
    },
    computed: {
        chartData: function() {
            const field = this.chartFilter.field.name;
            const label = this.chartFilter.field.label + ` (${this.determineFieldUnit(field)})`;
            const data = this.chartFilter.perYear
                ? this.pluckCurrentYearInvoicesBy(field)
                : this.pluckInvoicesBy(field).reverse();
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
        chartLabels: function() {
            if (this.chartFilter.perYear)
                return this.months;
            else
                return this.pluckInvoicesBy('invoice_release_date').map(
                    (date) => this.formatDate(new Date(date))
                ).reverse();
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
                const params = { contract_id: this.$route.params.id };
                const response = await axios.get('/invoices', { params });
                if (response.data.success == 'true') {
                    this.invoices = response.data.invoices;
                    this.invoices.sort(this.compareInvoicesDates);
                    this.fieldsByUnit = response.data.fields_by_unit;
                    this.filter.consumedEnergyRange[1] = this.findInvoicesMaxField('current_energy_consumption');
                    this.filter.totalPriceRange[1] = this.findInvoicesMaxField('total_price');
                    this.months = response.data.months;
                    this.pluckAvailableYears().forEach(year => this.availableYears.push(year));
                } else {
                    this.error = response.data.reason.message;
                }
            } catch (error) {
                this.error = error;
            }
        },
        compareInvoicesDates(invoice1, invoice2) {
            const date1 = new Date(invoice1.invoice_release_date);
            const date2 = new Date(invoice2.invoice_release_date);

            if (date1 === date2) return 0;

            return date1 > date2 ? -1 : 1;
        },
        onFiltered(filteredItems) {
            this.totalRows = filteredItems.length;
            this.currentTablePage = 1;
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
            const month = date.getMonth() < 9 ? `0${date.getMonth()+1}` : date.getMonth()+1;
            const day = date.getDate() <= 9 ? `0${date.getDate()}` : date.getDate();
            return `${day}-${month}-${date.getFullYear()}`;
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
            const startIndex = this.currentChartPage * this.maxInvoicesPerChart;
            const finalIndex = startIndex + this.maxInvoicesPerChart;
            return this.invoices.slice(startIndex, finalIndex).map(invoice => invoice[field]);
        },
        pluckCurrentYearInvoicesBy(field) {
            const currentYear = this.availableYears[this.currentChartPage];
            const currentYearInvoices = [];
            currentYearInvoices[11] = NaN;
            currentYearInvoices.fill(NaN);
            this.invoices.forEach((invoice) => {
                const releaseDate = new Date(invoice.invoice_release_date);
                if (releaseDate.getFullYear() === currentYear) 
                    currentYearInvoices[releaseDate.getMonth()-1] = invoice[field];
            });
            if (currentYearInvoices.some((value) => Number.isNaN(value)))
                this.missingInvoices = true;
            return currentYearInvoices;
        },
        pluckAvailableYears() {
            return new Set(this.invoices.map(
                invoice => new Date(invoice['invoice_release_date']).getFullYear()
            ));
        },
        nextChartPage() {
            if (this.nextChartPageEnabled()) {
                this.currentChartPage++;
            }
        },
        previousChartPage() {
            if (this.previousChartPageEnabled()) {
                this.currentChartPage--;
            }
        },
        nextChartPageEnabled() {
            return this.chartFilter.perYear
                ? this.currentChartPage < this.availableYears.length - 1
                : this.currentChartPage < Math.ceil(this.invoices.length/this.maxInvoicesPerChart) - 1;
        },
        previousChartPageEnabled() {
            return this.currentChartPage > 0;
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

    .switch-mode {
        position: absolute;
        left: 7%;
        top: 80px;
        display: flex;
    }

    .upload-invoice-button {
        position: absolute;
        right: 7%;
        top: 80px;
        display: flex;
    }

    .page-button {
        margin-bottom: 0px;
        margin-left: 10px;
        margin-right: 10px;
    }
</style>
<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>