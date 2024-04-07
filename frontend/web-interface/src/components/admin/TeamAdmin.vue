<template>
    <!-- component -->
    <div class="grid grid-rows-3 grid-flow-col gap-4">
        <!-- Table -->
        <div class="max-w-xl bg-white shadow-lg rounded-sm border border-gray-200 mt-8 ml-8">

            <header class="px-5 py-4 border-b border-gray-100">
                <h2 class="font-semibold text-gray-800">Manager 1</h2>
            </header>
            <div class="p-3">
                <table class="table-auto w-full">
                    <thead class="text-xs font-semibold uppercase text-gray-400 bg-gray-50">
                        <tr>
                            <th class="p-2">
                                <div class="font-semibold text-left">Name</div>
                            </th>
                            <th class="p-2">
                                <div class="font-semibold text-left">Email</div>
                            </th>
                            <!-- Ne sait pas quoi mettre -->
                            <th class="p-2">
                                <div class="font-semibold text-center">Info</div>
                            </th>
                        </tr>
                    </thead>
                    <tbody class="text-sm divide-y divide-gray-100">
                        <tr>
                            <td class="p-2">
                                <div class="flex items-center">
                                    <div class="font-medium text-gray-800">Alex Shatov</div>
                                </div>
                            </td>
                            <td class="p-2">
                                <div class="text-left">alexshatov@gmail.com</div>
                            </td>
                            <td class="p-2">
                                <div class="text-lg text-center">??</div>
                            </td>
                        </tr>
                        <tr>
                            <td class="p-2">
                                <div class="flex items-center">
                                    <div class="font-medium text-gray-800">Philip Harbach</div>
                                </div>
                            </td>
                            <td class="p-2">
                                <div class="text-left">philip.h@gmail.com</div>
                            </td>
                            <td class="p-2">
                                <div class="text-lg text-center">??</div>
                            </td>
                        </tr> 
                    </tbody>
                </table>
            </div>

        </div>
    </div>
</template>

<script>
import { RouterView } from 'vue-router'

</script>