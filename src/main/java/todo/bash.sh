#!/bin/bash


PENDING_TASKS_FILE="pending_tasks.txt"

COMPLETED_TASKS_FILE="completed_tasks.txt"

DELETED_TASKS_FILE="deleted_tasks.txt"


# Check if the files exist and create them if they don't
if [ ! -f "$PENDING_TASKS_FILE" ]; then
    touch "$PENDING_TASKS_FILE"
fi

if [ ! -f "$COMPLETED_TASKS_FILE" ]; then
    touch "$COMPLETED_TASKS_FILE"
fi

if [ ! -f "$DELETED_TASKS_FILE" ]; then
    touch "$DELETED_TASKS_FILE"
fi

# Function to add a new task to the pending tasks list
function add_task() {
    echo "$(date +"%Y-%m-%d %H:%M:%S")|$1" >> "$PENDING_TASKS_FILE"
    echo "Task \"$1\" added to the pending tasks list."
}

# Function to display pending tasks
function show_pending_tasks() {
    echo "Pending tasks:"
    awk -F"|" '{print $1, $2}' "$PENDING_TASKS_FILE"
}

# Function to display completed tasks
function show_completed_tasks() {
    echo "Completed tasks:"
    awk -F"|" '{print $1, $2}' "$COMPLETED_TASKS_FILE"
}

# Function to display deleted tasks
function show_deleted_tasks() {
    echo "Deleted tasks:"
    awk -F"|" '{print $1, $2}' "$DELETED_TASKS_FILE"
}

# Function to move a task from the pending tasks list to the completed tasks list
function complete_task() {
    local task="$1"
    echo "$(date +"%Y-%m-%d %H:%M:%S")|$task" >> "$COMPLETED_TASKS_FILE"
    sed -i "/$task/d" "$PENDING_TASKS_FILE" # Remove the task from the file
    echo "Task \"$task\" marked as completed."
}

# Function to delete a task and add it to the deleted tasks list
function delete_task() {
    local task="$1"
    echo "$(date +"%Y-%m-%d %H:%M:%S")|$task" >> "$DELETED_TASKS_FILE"
    sed -i "/$task/d" "$PENDING_TASKS_FILE" # Remove the task from the file
    echo "Task \"$task\" deleted and moved to the deleted tasks list."
}

# Function to search tasks in all lists
function search_tasks() {
    local query="$1"
    echo "Search results:"
    echo "Pending tasks:"
    grep -i "$query" "$PENDING_TASKS_FILE" | awk -F"|" '{print $1, $2}'
    echo "Completed tasks:"
    grep -i "$query" "$COMPLETED_TASKS_FILE" | awk -F"|" '{print $1, $2}'
    echo "Deleted tasks:"
    grep -i "$query" "$DELETED_TASKS_FILE" | awk -F"|" '{print $1, $2}'
}

# Read user commands and execute them
while true; do
    read -p "Enter your command (type 'help' for command list): " command

    case $command in
        "add" )
            read -p "Enter the new task: " new_task
            add_task "$new_task"
            ;;
        "show_pending" )
            show_pending_tasks
            ;;
        "show_completed" )
            show_completed_tasks
            ;;
        "show_deleted" )
            show_deleted_tasks
            ;;
        "complete" )
            read -p "Enter the task to mark as completed: " task_to_complete
            complete_task "$task_to_complete"
            ;;
        "delete" )
            read -p "Enter the task to delete: " task_to_delete
            delete_task "$task_to_delete"
            ;;
        "search" )
            read -p "Enter the search query: " search_query
            search_tasks "$search_query"
            ;;
        "help" )
            echo "Available commands:"
            echo "add: Add a new task"
            echo "show_pending: Display pending tasks"
            echo "show_completed: Display completed tasks"
            echo "show_deleted: Display deleted tasks"
            echo "complete: Mark a task as completed"
            echo "delete: Delete a task"
            echo "search: Search tasks"
            echo "help: Display this help message"
            echo "exit: Exit the program"
            ;;
        "exit" )
            break
            ;;
        * )
            echo "Invalidcommand. Please enter a valid command or type 'help' for a list of commands."
            ;;
    esac
done