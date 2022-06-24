<template>
    <div class="upload-container">
        <br>
        <b-card title="Subir factura" v-if="!invoiceUploaded" class="upload-container">
            <b-alert :show="error !== ''" variant="danger">{{ error }}</b-alert>
            <br>
            <b-card-text style="color: black">
                Seleccione el contrato para el que quiera subir la factura.
            </b-card-text>
            <div class="select-contract">
                <multiselect
                    v-model="contract"
                    :options="contracts"
                    label="name"
                    track-by="name"
                    :searchable="false"
                    :show-labels="false"
                    placeholder="Selecciona un contrato"
                />
                <br>
            </div>
            <div v-if="contract !== null">
                <hr><br>
                <b-card-text style="color: black">
                    Seleccione o suelte una factura en formato PDF o JSON y a continuación
                    haga click en "Confirmar selección" para revisar la factura antes de subirla.
                </b-card-text>
                <b-form-file
                    v-model="invoice"
                    :state="Boolean(invoice)"
                    accept=".pdf, .json"
                    placeholder="Elige una factura o suéltala aquí..."
                    drop-placeholder="Suelta una factura aquí..."
                    class="upload-file-input"
                ></b-form-file>
                <b-button 
                    @click="readInvoice" 
                    class="confirm-button upload-file-input"
                    style="background-color: purple"
                    :disabled="invoice === null"
                >Confirmar selección</b-button>
            </div>
        </b-card>
        <b-card v-else>
            <b-card-title>
                <b-row>
                    <b-col cols="2">
                        <b-button class="back-button" @click="resetForm()"><b-icon icon="arrow-left"></b-icon></b-button>
                    </b-col>
                    <b-col cols="8">
                        <p>Revisar factura</p>
                    </b-col>
                    <b-col cols="2">
                        &nbsp;
                    </b-col>
                </b-row>
                <hr>
            </b-card-title>
            <b-alert :show="error !== ''" variant="danger">{{ error }}</b-alert>
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
                                                v-model="parsedInvoice[field]"
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
                            @click="uploadInvoice"
                            class="confirm-button upload-file-button"
                            style="background-color: purple"
                        >
                            Subir factura
                        </b-button>
                    </b-col>
                    <b-col>
                        <b-button 
                            @click="resetForm"
                            class="confirm-button upload-file-button"
                            style="background-color: purple"
                        >
                            Cancelar
                        </b-button>
                    </b-col>
                </b-row>
            </b-container>

        </b-card>
    </div>
</template>

<script>
import axios from "axios";
import Multiselect from "vue-multiselect";

export default {
    components: {
        Multiselect
    },
    data() {
        return {
            invoiceUploaded: false,
            invoice: null,
            contract: null,
            contracts: [],
            parsedInvoice: null,
            error: '',
            fieldsByType: null,
            fieldsByUnit: null,
            fieldsBySection: null,
            currentSection: 0,
            fieldsInSpanish: null,
        }
    },
    mounted() {
        this.fetchData();
    },
    methods: {
        async readInvoice() {
            this.error = '';
            try {
                const formData = new FormData();
                formData.append('invoice', this.invoice);
                axios.defaults.headers.common["X-CSRF-Token"] = document
                    .querySelector('meta[name="csrf-token"]')
                    .getAttribute('content');
                const config = { 
                    headers: { 'Content-Type': 'multipart/form-data' }
                };
                const response = await axios.post('/read_invoice', formData, config);
                if (response.data.success == 'true') {
                    this.parsedInvoice = response.data.invoice;
                    this.fieldsByType = response.data.fields_by_type;
                    this.fieldsByUnit = response.data.fields_by_unit;
                    this.fieldsBySection = response.data.fields_by_section;
                    this.fieldsInSpanish = response.data.fields_in_spanish;
                    this.invoiceUploaded = true;
                } else {
                    this.invoice = null;
                    this.invoiceUploaded = false;
                    this.error = response.data.reason.message + ':\n' + response.data.details;
                }
            } catch (error) {
                this.invoice = null;
                this.invoiceUploaded = false;
                this.error = error;
            }
        },
        async uploadInvoice() {
            this.error = '';
            try {
                axios.defaults.headers.common["X-CSRF-Token"] = document
                    .querySelector('meta[name="csrf-token"]')
                    .getAttribute('content');
                const params = { invoice: this.parsedInvoice, contract_id: this.contract.id };
                const response = await axios.post('/upload_invoice', params);
                if (response.data.success == 'true') {
                    this.$router.push(
                        { name: 'ShowInvoice', params: { id: response.data.invoice_id } }
                    );
                } else {
                    this.error = response.data.reason.message + ':\n' + response.data.details;
                    window.scrollTo(0,0);
                }
            } catch (error) {
                this.error = error;
                window.scrollTo(0,0);
            }
        },
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
                    if (this.$route.params.contract_id)
                        this.contract = this.contracts.find(
                            (contract) => this.$route.params.contract_id == contract.id
                        );
                } else {
                    this.error = response.data.reason.message;
                }
            } catch (error) {
                this.error = error;
            }
        },
        resetForm() {
            this.error = '';
            this.invoice = null;
            this.invoiceUploaded = false;
            this.parsedInvoice = null;
            this.contract = null;
            window.scrollTo(0,0);
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
        }
    }
}
</script>

<style scoped>

    a {
        color: purple;
    }

    a:hover {
        color: rgb(163, 69, 163);
    }

    .upload-container {
        color: purple;
        padding-left: 15%;
        padding-right: 15%;
    }

    .upload-file-input {
        padding-top: 5%;
        width: 70%;
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

    .back-button {
        background-color: purple;
        margin-left: 0px;
    }

    .back-button:focus {
        background-color: rgb(177, 36, 177);
    }

    .back-button:hover {
        background-color: rgb(177, 36, 177);
    }

    .select-contract {
        max-width: 70%;
        margin: auto;
    }
</style>
<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>