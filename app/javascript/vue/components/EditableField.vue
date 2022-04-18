<template>
    <div class="editable-field">
        <strong>{{ displayName }}:</strong>
        <b-input-group>
            <b-input-group-append is-text :title="'Edit ' + displayName">
                <b-icon icon="pencil-square"></b-icon>
            </b-input-group-append>
            <b-form-input 
                :type="type"
                v-model="value"
                :id="name"
                @input="handleInput"
                class="editable-input"
            >
            </b-form-input>
        </b-input-group>
    </div>
</template>

<script>
export default {
    name: 'EditableField',
    props: ['value', 'name', 'type'],
    data() {
        return {
            types: [
                'text',
                'number',
                'email',
                'password',
                'search',
                'url',
                'tel',
                'date',
                'time',
                'range',
                'color'
            ],
            displayName: ''
        }
    },
    mounted() {
        if (this.types.indexOf(this.type) < 0) this.type = 'text';
        this.displayName = this.formatName(this.name);
    },
    methods: {
        handleInput(e) {
            this.$emit('input', this.value);
        },
        formatName(name) {
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
    .editable-field {
        width: 300px;
        height: 30px;
    }

    .editable-input {
        width: 180px;
    }
</style>