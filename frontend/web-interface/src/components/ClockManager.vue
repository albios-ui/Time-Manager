<template>
    <div class="flex">
    <h1 class="m-4 text-3xl font-bold text-center">
        Clock Manager
    </h1>
    <Clock :status=status @updateStatus="updateStatus" />
    
    <!--  TIME HISTORY
        <h3>Time</h3>
        <div class="" v-for="(clock, index) in clocks" :key="index"> 
            <p>{{clock.start}}</p>
        </div>
     -->
    </div>
</template>

<script>
import axios from 'axios';
import Clock from './clock/Clock.vue'

export default {
  name: 'clock',
  components: {
    Clock
  },
  data() {
        return {
            clock: {
                start: null,
                status: null
            },
            clocks: [
            ],
            status: false
        }
    },
    mounted() {
        this.update()
    },
    methods: {
        update() {
            axios
                .get('http://localhost:4000/api/clocks/1')
                .then(response => {
                    console.log(response.data.data)
                    this.clocks = response.data.data
                    if (this.clocks.length > 0) {
                        this.status = this.clocks[0].status
                    }
                })
                .catch(error => {
                    console.log(error)
                })
        },
        updateStatus() {
            this.status = this.status ? false : true;
        }
    }
};
</script>