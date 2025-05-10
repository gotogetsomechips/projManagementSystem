package store.service;

import java.text.Collator;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import store.bean.Task;
import store.mapper.TaskMapper;

@Service
public class TaskServiceImpl implements TaskService {

    @Autowired
    private TaskMapper taskMapper;

    // 创建中文排序的Collator实例
    private final Collator chineseCollator = Collator.getInstance(Locale.CHINA);

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

    @Override
    public List<Integer> getFixedOrderTaskIds(Task condition, String orderBy) {
        return taskMapper.getFixedOrderTaskIds(condition, "id DESC");
    }

    @Override
    public List<Task> getTasksByIds(List<Integer> ids) {
        if (ids == null || ids.isEmpty()) {
            return Collections.emptyList();
        }
        return taskMapper.getTasksByIds(ids);
    }

    @Override
    public List<Task> sortCurrentPage(List<Task> taskList, String sortField, String sortDirection) {
        Comparator<Task> comparator = getComparator(sortField);

        if ("DESC".equalsIgnoreCase(sortDirection)) {
            comparator = comparator.reversed();
        }

        return taskList.stream()
                .sorted(comparator)
                .collect(Collectors.toList());
    }

    private Comparator<Task> getComparator(String sortField) {
        switch(sortField) {
            case "title":
                // 使用中文Collator进行title字段的排序
                return (t1, t2) -> chineseCollator.compare(t1.getTitle(), t2.getTitle());
            case "creator":
                // 使用中文Collator进行creator字段的排序
                return (t1, t2) -> chineseCollator.compare(t1.getCreator(), t2.getCreator());
            case "executor":
                // 使用中文Collator进行executor字段的排序
                return (t1, t2) -> chineseCollator.compare(t1.getExecutor(), t2.getExecutor());
            case "priority":
                // 对于可能包含中文的字段也使用Collator
                return (t1, t2) -> chineseCollator.compare(t1.getPriority(), t2.getPriority());
            case "status":
                // 对于可能包含中文的字段也使用Collator
                return (t1, t2) -> chineseCollator.compare(t1.getStatus(), t2.getStatus());
            default:
                return Comparator.comparing(Task::getId);
        }
    }
}