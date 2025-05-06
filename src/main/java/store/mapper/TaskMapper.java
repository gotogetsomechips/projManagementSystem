package store.mapper;

import java.util.List;
import store.bean.Task;

public interface TaskMapper {
    int insert(Task task);
    int deleteById(Integer id);
    int deleteByIds(List<Integer> ids);
    int update(Task task);
    Task selectById(Integer id);
    List<Task> selectAll();
    List<Task> selectByCondition(Task condition);
    int countByTitle(String title);
    List<Task> selectWithOrder(String orderBy);
}