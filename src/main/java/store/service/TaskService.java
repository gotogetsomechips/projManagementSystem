package store.service;

import java.util.List;
import store.bean.Task;

public interface TaskService {
    int addTask(Task task);
    int deleteTask(Integer id);
    int batchDelete(List<Integer> ids);
    int updateTask(Task task);
    Task getTaskById(Integer id);
    List<Task> getAllTasks();
    List<Task> getTasksByCondition(Task condition);
    boolean isTitleExist(String title);
    List<Task> getAllTasksOrderBy(String orderBy);

    // 分页相关的方法
    List<Task> getAllTasksWithPagination(int startIndex, int pageSize);
    List<Task> getTasksByConditionWithPagination(Task condition, int startIndex, int pageSize);
    List<Task> getAllTasksOrderByWithPagination(String orderBy, int startIndex, int pageSize);
    List<Task> getTasksByConditionOrderByWithPagination(Task condition, String orderBy, int startIndex, int pageSize);

    int countAllTasks();
    int countTasksByCondition(Task condition);
}