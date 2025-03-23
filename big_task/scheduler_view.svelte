<script lang="ts">
    import { onMount } from 'svelte';
    import { Button, Card, Badge, Progressbar } from 'flowbite-svelte';
    import { 
        CalendarEditSolid, 
        ClockSolid, 
        CheckCircleSolid, 
        ExclamationCircleSolid 
    } from 'flowbite-svelte-icons';
    import { bigTasks, categories } from '../../stores';

    // Local state
    let tasks = [];
    let categoryMap = new Map();
    let now = new Date();
    let currentMonth = now.getMonth();
    let currentYear = now.getFullYear();
    let weeksInMonth = [];
    let monthNames = [
        'January', 'February', 'March', 'April', 'May', 'June', 
        'July', 'August', 'September', 'October', 'November', 'December'
    ];
    let currentMonthName = monthNames[currentMonth];

    // Subscribe to store changes
    bigTasks.subscribe(value => {
        if (!value) return;
        tasks = value;
        updateCalendarView();
    });

    categories.subscribe(value => {
        if (!value) return;
        categoryMap.clear();
        value.forEach(category => {
            categoryMap.set(category.id, {
                name: category.name,
                color: category.color
            });
        });
    });

    // Calendar helper functions
    function getDaysInMonth(month: number, year: number): number {
        return new Date(year, month + 1, 0).getDate();
    }

    function getFirstDayOfMonth(month: number, year: number): number {
        return new Date(year, month, 1).getDay();
    }

    function updateCalendarView(): void {
        const totalDays = getDaysInMonth(currentMonth, currentYear);
        const firstDay = getFirstDayOfMonth(currentMonth, currentYear);
        
        // Calculate the weeks in the month
        weeksInMonth = [];
        let day = 1;
        
        // For each week
        for (let i = 0; i < 6; i++) {
            const week = [];
            
            // For each day of the week
            for (let j = 0; j < 7; j++) {
                if ((i === 0 && j < firstDay) || day > totalDays) {
                    // Empty day
                    week.push({
                        day: null,
                        tasks: []
                    });
                } else {
                    // Day with potential tasks
                    const date = new Date(currentYear, currentMonth, day);
                    const tasksForDay = getTasksForDay(date);
                    
                    week.push({
                        day,
                        date,
                        isToday: isToday(date),
                        tasks: tasksForDay
                    });
                    
                    day++;
                }
            }
            
            // Add the week if it contains at least one day
            if (week.some(day => day.day !== null)) {
                weeksInMonth.push(week);
            }
        }
        
        currentMonthName = monthNames[currentMonth];
    }

    function previousMonth(): void {
        if (currentMonth === 0) {
            currentMonth = 11;
            currentYear--;
        } else {
            currentMonth--;
        }
        updateCalendarView();
    }

    function nextMonth(): void {
        if (currentMonth === 11) {
            currentMonth = 0;
            currentYear++;
        } else {
            currentMonth++;
        }
        updateCalendarView();
    }

    function goToToday(): void {
        currentMonth = now.getMonth();
        currentYear = now.getFullYear();
        updateCalendarView();
    }

    function isToday(date: Date): boolean {
        const today = new Date();
        return date.getDate() === today.getDate() && 
               date.getMonth() === today.getMonth() && 
               date.getFullYear() === today.getFullYear();
    }

    function getTasksForDay(date: Date): any[] {
        const dateStr = date.toISOString().split('T')[0]; // Format: YYYY-MM-DD
        
        return tasks.filter(task => {
            const dueDate = new Date(task.duedate);
            const dueDateStr = dueDate.toISOString().split('T')[0];
            
            return dueDateStr === dateStr;
        });
    }

    function getDayStatusColor(dayData: any): string {
        if (!dayData.day) return '';
        if (dayData.isToday) return 'bg-blue-100 dark:bg-blue-900';
        
        // Check if any task is due today and not complete
        const hasDueTask = dayData.tasks.some(task => {
            const todoTasks = task.tasks.filter(t => !t.is_done);
            return todoTasks.length > 0;
        });
        
        if (hasDueTask) {
            // Check if the date is past due
            if (dayData.date < now) {
                return 'bg-red-100 dark:bg-red-900';
            }
            // Due soon (within 3 days)
            const threeDaysFromNow = new Date();
            threeDaysFromNow.setDate(now.getDate() + 3);
            if (dayData.date <= threeDaysFromNow) {
                return 'bg-yellow-100 dark:bg-yellow-900';
            }
        }
        
        return '';
    }

    function getTaskStatusColor(task: any): "none" | "red" | "yellow" | "green" | "indigo" | "purple" | "pink" | "blue" | "dark" | "primary" {
        const totalTasks = task.tasks.length;
        if (totalTasks === 0) return "dark";
        
        const completedTasks = task.tasks.filter(t => t.is_done).length;
        const completionRate = completedTasks / totalTasks;
        
        if (completionRate === 1) return "green";
        if (completionRate >= 0.5) return "blue";
        
        const dueDate = new Date(task.duedate);
        if (dueDate < now) return "red";
        
        const threeDaysFromNow = new Date();
        threeDaysFromNow.setDate(now.getDate() + 3);
        if (dueDate <= threeDaysFromNow) return "yellow";
        
        return "blue";
    }
    
    function calculateProgress(task: any): number {
        const totalTasks = task.tasks.length;
        if (totalTasks === 0) return 0;
        
        const completedTasks = task.tasks.filter(t => t.is_done).length;
        return Math.round((completedTasks / totalTasks) * 100);
    }

    // Initial setup
    onMount(() => {
        updateCalendarView();
    });
</script>

<div class="scheduler-container p-4">
    <div class="calendar-header flex justify-between items-center mb-4">
        <div class="flex gap-2">
            <Button size="sm" outline pill on:click={previousMonth}>
                <span>&laquo;</span>
            </Button>
            <h2 class="text-2xl font-bold">{currentMonthName} {currentYear}</h2>
            <Button size="sm" outline pill on:click={nextMonth}>
                <span>&raquo;</span>
            </Button>
        </div>
        <Button size="sm" on:click={goToToday}>Today</Button>
    </div>

    <div class="calendar-grid border rounded-lg overflow-hidden bg-white dark:bg-gray-800">
        <!-- Days of week header -->
        <div class="grid grid-cols-7 border-b">
            {#each ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'] as day}
                <div class="p-2 text-center font-semibold border-r last:border-r-0">{day}</div>
            {/each}
        </div>
        
        <!-- Calendar days -->
        {#each weeksInMonth as week}
            <div class="grid grid-cols-7 border-b last:border-b-0">
                {#each week as day}
                    <div class="day-cell border-r last:border-r-0 min-h-[100px] p-2 relative {getDayStatusColor(day)}">
                        {#if day.day}
                            <div class="absolute top-1 right-1 text-sm font-semibold {day.isToday ? 'text-blue-600 dark:text-blue-400' : ''}">
                                {day.day}
                            </div>
                            
                            <div class="task-list mt-6">
                                {#each day.tasks as task}
                                    <div class="mb-2">
                                        <a href="#{task.id}" class="block">
                                            <Card padding="sm" class="!p-2 hover:bg-gray-100 dark:hover:bg-gray-700">
                                                <div class="flex items-center">
                                                    <Badge color={getTaskStatusColor(task)} class="mr-2" />
                                                    <span class="font-medium truncate">{task.title}</span>
                                                </div>
                                                <Progressbar progress={calculateProgress(task)} class="mt-1" />
                                            </Card>
                                        </a>
                                    </div>
                                {/each}
                            </div>
                        {/if}
                    </div>
                {/each}
            </div>
        {/each}
    </div>
</div>

<div class="task-list mt-8">
    <h2 class="text-2xl font-bold mb-4">Upcoming Big Tasks</h2>
    
    {#if tasks.length === 0}
        <Card>
            <p class="text-center py-4">No tasks scheduled. Start by creating a new Big Task!</p>
        </Card>
    {:else}
        {#each tasks.sort((a, b) => new Date(a.duedate).getTime() - new Date(b.duedate).getTime()) as task}
            <Card id={task.id} class="mb-4 hover:shadow-lg transition-shadow">
                <div class="flex justify-between">
                    <div>
                        <h3 class="text-xl font-bold">{task.title}</h3>
                        <p class="text-gray-500 dark:text-gray-400">{task.description}</p>
                    </div>
                    <div class="flex items-center">
                        <div class="flex items-center text-gray-600 dark:text-gray-300 mr-4">
                            <CalendarEditSolid class="mr-1 w-4 h-4" />
                            <span>{new Date(task.duedate).toLocaleDateString()}</span>
                        </div>
                        
                        <Badge color={getTaskStatusColor(task)}>
                            <div class="flex items-center">
                                {#if calculateProgress(task) === 100}
                                    <CheckCircleSolid class="mr-1 w-4 h-4" />
                                    Complete
                                {:else if new Date(task.duedate) < now}
                                    <ExclamationCircleSolid class="mr-1 w-4 h-4" />
                                    Overdue
                                {:else}
                                    <ClockSolid class="mr-1 w-4 h-4" />
                                    In Progress
                                {/if}
                            </div>
                        </Badge>
                    </div>
                </div>
                
                <Progressbar progress={calculateProgress(task)} class="mt-3" 
                    color={calculateProgress(task) === 100 ? "green" : "blue"} />
                
                <div class="mt-4">
                    <h4 class="font-medium mb-2">Subtasks ({task.tasks.filter(t => t.is_done).length}/{task.tasks.length})</h4>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-2">
                        {#each task.tasks as subtask}
                            <div class="flex items-center p-2 {subtask.is_done ? 'bg-green-50 dark:bg-green-900' : 'bg-gray-50 dark:bg-gray-700'} rounded">
                                <div class="w-3 h-3 rounded-full mr-2" 
                                    style="background-color: {subtask.category_id && categoryMap.get(subtask.category_id) ? categoryMap.get(subtask.category_id).color : '#888'}">
                                </div>
                                <span class="{subtask.is_done ? 'line-through text-gray-500' : ''}">{subtask.title}</span>
                                <div class="ml-auto flex items-center">
                                    <ClockSolid class="mr-1 w-3 h-3" />
                                    <span class="text-xs">{subtask.minutes} min</span>
                                </div>
                            </div>
                        {/each}
                    </div>
                </div>
            </Card>
        {/each}
    {/if}
</div> 