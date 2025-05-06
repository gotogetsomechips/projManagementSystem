package store.service;

import java.util.List;
import store.bean.Task;

public interface TaskService {
    boolean addTask(Task task);
    boolean deleteTask(Integer id);
    boolean deleteTasks(List<Integer> ids);
    boolean updateTask(Task task);
    Task getTaskById(Integer id);
    List<Task> getAllTasks();
    List<Task> getTasksByCondition(Task condition);
    boolean isTitleExist(String title);
    List<Task> getTasksWithOrder(String orderBy);
}