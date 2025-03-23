<script lang="ts">
	import { Input } from 'flowbite-svelte';
	import { ClockOutline, CheckCircleOutline, EditOutline } from 'flowbite-svelte-icons';
	import { createEventDispatcher } from 'svelte';
	import { tasks } from '../../stores';


	const dispatcher = createEventDispatcher();

	export let id = 0;
	export let name = 'Task Name'; // Default name if not provided
	export let color = '#00FF00'; // Default color
	export let timeInMinutes = 60; // Default time
	export let w = '10%'; // Width will be passed by the parent component as a percentage
	export let isNOTCompletedTrailer = true; // Indicates the content condition



	function editTask() {
		dispatcher('edit-task', { id: id });
	}

	function planTask() {
		dispatcher('edit-task', { id: id });
	}

	function markTask() {
		// Update the task status
		switchTask();
	}

	async function switchTask() {
		const response = await fetch(`/api/me/tasks/${id}/mark_done`, {
			method: 'PUT',
			credentials: 'include'
		});

		if (response.ok) {
			tasks.update((tasks) => {
				tasks.map((task) => {
					if (task.id == id) {
						task.is_done = !task.is_done;
					}
					return task;
				});
				return tasks;
			});
		}
	}

</script>

<style>
    /* Added for demonstration */
    .button-container {
        opacity: 0; /* Make buttons invisible by default */
        transition: opacity 100ms ease-in-out; /* Smooth transition for the opacity */
    }

    .hovered:hover .button-container {
        opacity: 1; /* Make buttons visible when parent is hovered */
    }
</style>

<div draggable="true"
		 class={`relative my-1 overflow-hidden rounded-lg text-white ${isNOTCompletedTrailer ? 'hovered hover:position-absolute hover:scale-110 hover:min-w-[200px] transition-all duration-300 ease-in-out hover:shadow-md hover:z-30' : 'font-bold'}`}
		 style="background: {color}; --task-width: {w}; width: var(--task-width); height: 10vh;">
	{#if isNOTCompletedTrailer}
		<div class="px-2">
			{name}
		</div>
		<div class="whitespace-nowrap overflow-hidden text-ellipsis w-full px-1">
			{timeInMinutes} {timeInMinutes === 1 ? 'min' : 'mins'}
			<input type="hidden" name="task_id" value="{id}" />
		</div>
		<div class="button-container absolute right-2.5 top-1/2 transform -translate-y-1/2">
			<button class="px-1.25 my-0.5 rounded text-sm" on:click={planTask}>
				<ClockOutline />
			</button>
			<button class="px-1.25 my-0.5 rounded text-sm" on:click={markTask}>
				<CheckCircleOutline />
			</button>
			<button class="px-1.25 my-0.5 rounded text-sm" on:click={editTask}>
				<EditOutline />
			</button>
		</div>
	{:else}
		<div class="whitespace-nowrap overflow-hidden text-ellipsis w-full px-2">
			{name}
		</div>
	{/if}
</div>