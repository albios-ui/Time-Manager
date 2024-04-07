<script setup>
import { RouterView } from 'vue-router'
import SideBar from './components/nav/AdminNav.vue'

</script>

<template>
  <div class="flex">
    <SideBar />
    <RouterView />
  </div>
</template>

<style scoped>

</style>
