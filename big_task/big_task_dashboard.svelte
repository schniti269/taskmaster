<script lang="ts">
	import BigTaskJoined from '$lib/big_task/big_task.svelte';
	import { bigTasks } from '../../stores';
	let key = 0; // Initialize a key
	let dashboardbigTasks: any;
	bigTasks.subscribe(value => {
		dashboardbigTasks = value;
		key++; // Increment key to force rerender
	});

</script>

<div>

    {#each dashboardbigTasks as bigtask (key)}
        <div class="">
            <BigTaskJoined {bigtask} on:edit-bigtask on:edit-task />
        </div>
    {/each}

</div>