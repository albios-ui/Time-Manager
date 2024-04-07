<script setup>
import { NButton } from 'naive-ui'
</script>

<template>
    <n-button 
        class="text-xl p-5"
        :class="[status ? 'bg-red-500' : 'bg-green-500']"
        @click="addTime ();">
        {{ status ? 'Stop' : 'Start' }}
    </n-button>
</template>

<script>
import axios from 'axios'

export default {
    props: {
        status: Boolean
    },
    data() {
        return {
            start: ''
        };
    },
    emits: ["updateStatus"],
    methods: {
        update() {
            this.$emit('updateStatus');
        },
        addTime() {
            axios
                .post('http://localhost:4000/api/clocks/1')
                .then(response => {
                    console.log(response.data.data)
                    this.update();
                })
                .catch(error => {
                    console.log(error)
                })
        }
    },
};

</script>