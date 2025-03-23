<script lang="ts">
	import BigTaskJoined from '$lib/big_task/big_task.svelte';
	import { sharedBigTasks } from '../../stores';

	let shareddashboardbigTasks: any;
	sharedBigTasks.subscribe(value => {
		shareddashboardbigTasks = value;
	});


</script>

{#if shareddashboardbigTasks && shareddashboardbigTasks.length > 0}
<div>
	<h1 class="text-white text-xl">Shared Big Tasks</h1>
	{#each shareddashboardbigTasks as bigtask}
		<div class="">
			<BigTaskJoined {bigtask} on:edit-bigtask on:edit-task />
		</div>
	{/each}
</div>
{/if}