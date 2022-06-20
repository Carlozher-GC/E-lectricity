<template>
    <div class="upload-container">
        <br>
        <div>
            <b-alert :show="error !== ''" variant="danger">{{ error }}</b-alert>
        </div>
        <br>
        <div v-if="invoice">
            <b-card :title="`Factura Nº ${invoice.invoice_number}`">
                <b-container>
                    <div>
                        <div>
                            <b-nav tabs fill>
                                <b-nav-item :active="currentSection == 0" @click="currentSection = 0">
                                    Información general
                                </b-nav-item>
                                <b-nav-item :active="currentSection == 1" @click="currentSection = 1">
                                    Consumo de energía
                                </b-nav-item>
                                <b-nav-item :active="currentSection == 2" @click="currentSection = 2">
                                    Precio
                                </b-nav-item>
                                <b-nav-item :active="currentSection == 3" @click="currentSection = 3">
                                    Desglose de costes
                                </b-nav-item>
                                <b-nav-item :active="currentSection == 4" @click="currentSection = 4">
                                    Impuestos
                                </b-nav-item>
                            </b-nav>
                        </div>
                        <div v-for="(section, index) of fieldsBySection" :key="index">
                            <b-row v-if="currentSection == index">
                                <b-col cols="6" v-for="field in section" :key="field" class="invoice-field">
                                    <b-row>
                                        <b-col cols="6">
                                            <strong class="field-name">{{ fieldsInSpanish[field] }}:</strong>
                                        </b-col>
                                        <b-col cols="6">
                                            <b-input-group>
                                                <b-form-input 
                                                    :type="determineFieldType(field)"
                                                    v-model="invoice[field]"
                                                >
                                                </b-form-input>
                                                <b-input-group-append is-text v-if="determineFieldUnit(field) !== null">
                                                    {{ determineFieldUnit(field) }}
                                                </b-input-group-append>
                                            </b-input-group>
                                        </b-col>
                                    </b-row>
                                </b-col>
                            </b-row>
                        </div>
                    </div>
                    <b-row style="padding-top: 20px; text-align: center">
                        <b-col>
                            <b-button
                                @click="updateInvoice()"
                                class="confirm-button upload-file-button"
                                style="background-color: purple"
                            >
                                Confirmar cambios
                            </b-button>
                        </b-col>
                        <b-col>
                            <b-button 
                                @click="$router.push({ name: 'InvoicesIndex', params: { id: invoice.contract_id } })"
                                class="confirm-button upload-file-button"
                                style="background-color: purple"
                            >
                                Volver
                            </b-button>
                        </b-col>
                    </b-row>
                </b-container>
            </b-card>
        </div>
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
            invoice: null,
            fieldsByType: null,
            fieldsByUnit: null,
            fieldsBySection: null,
            currentSection: 0,
            fieldsInSpanish: null,
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
                    this.invoice.invoice_release_date = this.formatDate(new Date(this.invoice.invoice_release_date));
                    this.invoice.start_billing_date = this.formatDate(new Date(this.invoice.start_billing_date));
                    this.invoice.end_billing_date = this.formatDate(new Date(this.invoice.end_billing_date));
                    this.fieldsByType = response.data.fields_by_type;
                    this.fieldsByUnit = response.data.fields_by_unit;
                    this.fieldsBySection = response.data.fields_by_section;
                    this.fieldsInSpanish = response.data.fields_in_spanish;
                } else {
                    this.error = response.data.reason.message;
                }
            } catch (error) {
                this.error = error;
            }
        },
        async updateInvoice() {
            this.error = '';
            try {
                axios.defaults.headers.common["X-CSRF-Token"] = document
                    .querySelector('meta[name="csrf-token"]')
                    .getAttribute('content');
                const response = await axios.patch(`/invoices/${this.$route.params.id}`);
                if (response.data.success == 'true') {
                    this.$router.push({ name: 'InvoicesIndex', params: { id: invoice.contract_id } });
                } else {
                    this.error = `${response.data.reason.message}: ${response.data.details}`;
                }
            } catch (error) {
                this.error = error;
            }
        },
        determineFieldType(field) {
            for (const [type, fields] of Object.entries(this.fieldsByType)) {
                if (fields.indexOf(field) > -1) {
                    return type;
                }
            }
            return 'text';
        },
        determineFieldUnit(field) {
            for (const [unit, fields] of Object.entries(this.fieldsByUnit)) {
                if (fields.indexOf(field) > -1) {
                    return unit;
                }
            } 
            return null;
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

    h4 {
        color: purple;    
    }

    a {
        color: purple;
    }

    a:hover {
        color: rgb(163, 69, 163);
    }

    .upload-container {
        color: purple;
        padding-left: 10%;
        padding-right: 10%;
    }

    .upload-file-button {
        max-width: 60%;
    }

    .confirm-button {
        padding: 0px !important;
        vertical-align: middle;
        background-color: purple;
        border-color: transparent;
        color: white;
        height: 48px !important;
        text-transform: none !important;
        border-radius: 28px !important;
        width: 50%;
    }

    .invoice-field {
        padding-top: 20px;
    }

    .field-name {
        color: black;
        font-size: 0.82em;
    }
</style>