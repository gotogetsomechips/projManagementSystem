package store.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import store.bean.Task;
import store.mapper.TaskMapper;
import store.service.TaskService;

@Service
public class TaskServiceImpl implements TaskService {

    @Autowired
    private TaskMapper taskMapper;

    @Override
    public int addTask(Task task) {
        return taskMapper.insert(task);
    }

    @Override
    public int deleteTask(Integer id) {
        return taskMapper.deleteById(id);
    }

    @Override
    public int batchDelete(List<Integer> ids) {
        return taskMapper.batchDelete(ids);
    }

    @Override
    public int updateTask(Task task) {
        return taskMapper.update(task);
    }

    @Override
    public Task getTaskById(Integer id) {
        return taskMapper.selectById(id);
    }

    @Override
    public List<Task> getAllTasks() {
        return taskMapper.selectAll();
    }

    @Override
    public List<Task> getTasksByCondition(Task condition) {
        return taskMapper.selectByCondition(condition);
    }

    @Override
    public boolean isTitleExist(String title) {
        return taskMapper.countByTitle(title) > 0;
    }

    @Override
    public List<Task> getAllTasksOrderBy(String orderBy) {
        return taskMapper.selectAllOrderBy(orderBy);
    }

    @Override
    public List<Task> getAllTasksWithPagination(int startIndex, int pageSize) {
        return taskMapper.selectAllWithPagination(startIndex, pageSize);
    }

    @Override
    public List<Task> getTasksByConditionWithPagination(Task condition, int startIndex, int pageSize) {
        return taskMapper.selectByConditionWithPagination(condition, startIndex, pageSize);
    }

    @Override
    public List<Task> getAllTasksOrderByWithPagination(String orderBy, int startIndex, int pageSize) {
        return taskMapper.selectAllOrderByWithPagination(orderBy, startIndex, pageSize);
    }

    @Override
    public List<Task> getTasksByConditionOrderByWithPagination(Task condition, String orderBy, int startIndex, int pageSize) {
        return taskMapper.selectByConditionOrderByWithPagination(condition, orderBy, startIndex, pageSize);
    }

    @Override
    public int countAllTasks() {
        return taskMapper.countAll();
    }

    @Override
    public int countTasksByCondition(Task condition) {
        return taskMapper.countByCondition(condition);
    }
}