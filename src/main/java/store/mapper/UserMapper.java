package store.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import store.bean.User;

public interface UserMapper {
    int insert(User user);
    int deleteById(Integer id);
    int batchDelete(@Param("ids") List<Integer> ids);
    int update(User user);
    User selectById(Integer id);
    List<User> selectAll();
    List<User> selectByCondition(User condition);
    int countByUsername(String username);
    List<User> selectAllOrderBy(String orderBy);
    User selectByUsername(String username);
    List<Integer> getFixedOrderUserIds(@Param("condition") User condition, @Param("orderBy") String orderBy);
    List<User> getUsersByIds(@Param("ids") List<Integer> ids);
    int updateStatusByUsername(@Param("username") String username, @Param("status") String status);
    // 分页相关的方法
    List<User> selectAllWithPagination(@Param("startIndex") int startIndex, @Param("pageSize") int pageSize);
    List<User> selectByConditionWithPagination(@Param("condition") User condition, 
            @Param("startIndex") int startIndex, @Param("pageSize") int pageSize);
    List<User> selectAllOrderByWithPagination(@Param("orderBy") String orderBy, 
            @Param("startIndex") int startIndex, @Param("pageSize") int pageSize);
    List<User> selectByConditionOrderByWithPagination(@Param("condition") User condition, 
            @Param("orderBy") String orderBy, @Param("startIndex") int startIndex, @Param("pageSize") int pageSize);

    int countAll();
    int countByCondition(User condition);
}