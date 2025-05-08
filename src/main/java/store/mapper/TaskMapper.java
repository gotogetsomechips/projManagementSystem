package store.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import store.bean.Task;

public interface TaskMapper {
    int insert(Task task);
    int deleteById(Integer id);
    int batchDelete(@Param("ids") List<Integer> ids);
    int update(Task task);
    Task selectById(Integer id);
    List<Task> selectAll();
    List<Task> selectByCondition(Task condition);
    int countByTitle(String title);
    List<Task> selectAllOrderBy(String orderBy);

    // 分页相关的方法
    List<Task> selectAllWithPagination(@Param("startIndex") int startIndex, @Param("pageSize") int pageSize);
    List<Task> selectByConditionWithPagination(@Param("condition") Task condition, @Param("startIndex") int startIndex, @Param("pageSize") int pageSize);
    List<Task> selectAllOrderByWithPagination(@Param("orderBy") String orderBy, @Param("startIndex") int startIndex, @Param("pageSize") int pageSize);
    List<Task> selectByConditionOrderByWithPagination(@Param("condition") Task condition, @Param("orderBy") String orderBy, @Param("startIndex") int startIndex, @Param("pageSize") int pageSize);

    int countAll();
    int countByCondition(Task condition);
}