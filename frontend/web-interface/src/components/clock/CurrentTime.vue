<template>
    <div id="app">
    <p>{{currentDateTime()}}</p>

  </div>
</template>

<script>
import moment from 'moment'

export default {
  methods: {
    currentDateTime() {
      return moment().format('YYYY-MM-DD H:mm:ss')
    },
  }
};
</script>