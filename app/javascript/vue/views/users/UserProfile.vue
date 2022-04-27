<template>
    <div>
        <br>
        <h2 style="color: purple">User profile</h2>
        <hr>
        {{ user }}
    </div>
</template>

<script>

export default {
    components: {
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