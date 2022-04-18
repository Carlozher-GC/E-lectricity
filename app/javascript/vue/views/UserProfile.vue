<template>
    <div>
        <br>
        <h2 style="color: purple">User profile</h2>
        <hr>
        {{ user }}
    </div>
</template>

<script>
import EditableField from '../components/EditableField.vue';

export default {
    components: {
        EditableField
    },
    data() {
        return {
            user: {},
        }
    },
    mounted() {
        this.user = this.$store.state.currentUser;
    }
}
</script>


<style scoped>
</style>