package store.service;

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
    public boolean addTask(Task task) {
        return taskMapper.insert(task) > 0;
    }

    @Override
    public boolean deleteTask(Integer id) {
        return taskMapper.deleteById(id) > 0;
    }

    @Override
    public boolean deleteTasks(List<Integer> ids) {
        return taskMapper.deleteByIds(ids) > 0;
    }

    @Override
    public boolean updateTask(Task task) {
        return taskMapper.update(task) > 0;
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
    public List<Task> getTasksWithOrder(String orderBy) {
        return taskMapper.selectWithOrder(orderBy);
    }
}