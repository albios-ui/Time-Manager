<script setup>
import { RouterView } from 'vue-router'
</script>

<template>
    <div class="flex">
        <RouterView />
    </div>
</template>

<script>
import AdminNav from './nav/AdminNav.vue'

export default {
    name:'admin',
    components: {
        AdminNav
    },
}
</script>