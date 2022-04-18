<template>
    <div class="upload-container">
        <br>
        <b-card title="Subir factura" v-if="!invoiceUploaded" class="upload-container">
            <b-alert :show="error !== ''" variant="danger">{{ error }}</b-alert>
            <br>
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
        </b-card>
        <b-card title="Revisar factura" v-else>
            <b-container>
                <b-row>
                    <b-col cols="6" v-for="key in Object.keys(parsedInvoice)" :key="key" class="invoice-field">
                        <b-row>
                            <b-col cols="5">
                                <strong class="field-name">{{ formatFieldName(key) }}:</strong>
                            </b-col>
                            <b-col cols="7">
                                <b-input-group>
                                    <b-form-input 
                                        type="text"
                                        v-model="parsedInvoice[key]"
                                    >
                                    </b-form-input>
                                    <b-input-group-append is-text :title="'Edit ' + formatFieldName(key)">
                                        <b-icon icon="pencil-square"></b-icon>
                                    </b-input-group-append>
                                </b-input-group>
                            </b-col>
                        </b-row>
                    </b-col>
                </b-row>
            </b-container>
        </b-card>
    </div>
</template>

<script>
import axios from "axios";
import EditableField from '../components/EditableField.vue';

export default {
    components: {
        EditableField
    },
    data() {
        return {
            invoiceUploaded: false,
            invoice: null,
            parsedInvoice: null,
            error: ''
        }
    },
    mounted() {
        this.user = this.$store.state.currentUser;
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
        formatFieldName(name) {
            let formattedName = '';
            if (name.indexOf('_') >= 0) {
                for (const string of name.split('_')) {
                    const firstChar = string.charAt(0).toUpperCase();
                    const remainingString = string.length > 1 ? string.substring(1) : '';
                    formattedName +=  firstChar + remainingString + ' ';
                }
                return formattedName.trim();
            }
            return name;
        }
    }
}
</script>

<style scoped>
    .upload-container {
        color: purple;
        padding-left: 10%;
        padding-right: 10%;
    }

    .upload-file-input {
        padding-top: 5%;
        width: 70%;
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
        font-size: 0.7em;
    }
</style>