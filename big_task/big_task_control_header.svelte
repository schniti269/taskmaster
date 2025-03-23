<script lang="ts">
	export let name = 'Big Task Name'; // Default name if not provided
	export let dueDate = '2024-01-01'; // Default due date if not provided
	export const description = '';
	export let id = -999999; // Default ID if not provided
	export let minperday = 0;

	import { CirclePlusOutline, EditOutline } from 'flowbite-svelte-icons';
	import { createEventDispatcher } from 'svelte';
	import { hideTaskDrawer } from '../../stores';

	const dispatch = createEventDispatcher();

	function goToEdit() {
		dispatch('edit-bigtask', { id: id });
		// Implement navigation logic here, e.g., routing to an edit page
	}

	function addTask() {
		hideTaskDrawer.set(false);
	}
</script>

<style>
    /* Removed the hidden and flex apply directives for opacity controls */
    .edit-button, .add-button {
        @apply absolute text-white font-bold rounded-full;
        @apply items-center justify-center;
        opacity: 0; /* Start fully transparent */
        transition: opacity 0.3s; /* Smooth transition for opacity */
    }

    .container:hover .edit-button, .container:hover .add-button {
        opacity: 1; /* Fully opaque on hover */
    }

    .name-container {
        @apply relative flex justify-between items-center;
        /* Adjust for proper alignment */
    }
</style>

<div
	class="container flex flex-col bg-primary rounded-lg w-[10%] mb-2 min-w-[250px] h-[15vh] shadow-lg relative hover:shadow-xl transition-shadow duration-300 ease-in-out z-10">
	<div class="flex flex-col mb-2 p-4">
		<div class="name-container">
			<div class="truncate font-semibold text-lg text-gray-800">{name}</div>
			<!-- min per day -->
			<div class="truncate text-sm text-secondary">{minperday} min/day</div>
		</div>
		<div class="truncate text-sm text-secondary">{dueDate}</div>
	</div>
	<button class="edit-button z-10 absolute end-0 bottom-11 mr-4" on:click={goToEdit}>
		<EditOutline class="text-secondary-800 size-7" />
	</button>
	<button class="add-button z-10 absolute end-0 bottom-4 mr-5 " on:click={addTask}>
		<CirclePlusOutline class="text-secondary-800 size-6" />
	</button>

</div>