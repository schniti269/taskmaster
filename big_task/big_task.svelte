<script lang="ts">
	import { onMount } from 'svelte';
	import BigTaskTaskElement from '$lib/big_task/big_task_task_element.svelte';
	import BigTaskHeader from '$lib/big_task/big_task_control_header.svelte';
	import { categories } from '../../stores';

	export let bigtask;
	let colormap = new Map();
	categories.subscribe(value => {
		value.forEach(category => {
			colormap.set(category.id, category.color);
		});

	});
	let tasks = bigtask.tasks;
	let doneTasks = tasks.filter(task => task.is_done);
	let todoTasks = tasks.filter(task => !task.is_done);
	let processedTodoTasks = [];
	let totalMinutes = 0;
	let todominutes = 0;
	let doneminutes = 0;

	doneTasks.forEach(task => {
		doneminutes += task.minutes;
		totalMinutes += task.minutes;
		
	});
	todoTasks.forEach(task => {
		let minutes = task.minutes;
		totalMinutes += minutes;
		
		processedTodoTasks.push({ id: task.id, name: task.title, color: colormap.get(task.category_id), minutes: minutes });
	});

	//adjust the width of the task element
	processedTodoTasks.forEach(task => {
		task.widthPercent = Math.round((task.minutes / totalMinutes) * 100);
		// typecast from string to integer ( ensure that the width is a valid INT)
		task.widthPercent = parseInt(task.widthPercent) + '%';
	});
	let completedPercent = Math.round((doneminutes / totalMinutes) * 100) + '%';
	let donetext = completedPercent;

	//calculate the time needed to do all todo tasks per day until the due date
	let today = new Date();
	let dueDate = new Date(bigtask.duedate);
	//calculate the number of days between today and the due date
	// Calculate the difference in milliseconds
	let differenceInMilliseconds: number = dueDate.getTime() - today.getTime();

	// Convert milliseconds to days
	let millisecondsPerDay: number = 1000 * 60 * 60 * 24;
	let daysDifference: number = Math.ceil(differenceInMilliseconds / millisecondsPerDay);

	//calculate the time needed to do all todo tasks per day until the due date
	todoTasks.forEach(task => {
		todominutes += task.minutes;
	});
	let minutesPerDay = Math.round(todominutes / daysDifference);

</script>

<div class="flex items-center w-full">
	<BigTaskHeader name={bigtask.title} dueDate={bigtask.duedate} id={bigtask.id} minperday={minutesPerDay} on:edit-bigtask />
	<div class="flex-grow flex gap-1 overflow-clip">
		{#each processedTodoTasks as task}
			<BigTaskTaskElement
				id={task.id}
				name={task.name}
				color={task.color}
				timeInMinutes={task.minutes}
				w={task.widthPercent}

				on:edit-task
			/>
		{/each}
		{#if doneminutes > 0 && totalMinutes > 0}
			<BigTaskTaskElement
				id={0}
				name={donetext}
				color="green"
				timeInMinutes={doneminutes}
				w={completedPercent}
				isNOTCompletedTrailer={false}
			/>
		{/if}
	</div>

</div>