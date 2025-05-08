package store.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import store.bean.Message;

public interface MessageMapper {
    int insert(Message message);
    int deleteById(Integer id);
    int batchDelete(@Param("ids") List<Integer> ids);
    int update(Message message);
    Message selectById(Integer id);
    List<Message> selectAll();
    List<Message> selectByCondition(Message condition);
    List<Message> selectAllOrderBy(String orderBy);
    int countByTitle(@Param("title") String title);
    // 分页相关方法
    List<Message> selectAllWithPagination(@Param("startIndex") int startIndex, @Param("pageSize") int pageSize);
    List<Message> selectByConditionWithPagination(@Param("condition") Message condition, 
            @Param("startIndex") int startIndex, @Param("pageSize") int pageSize);
    List<Message> selectAllOrderByWithPagination(@Param("orderBy") String orderBy, 
            @Param("startIndex") int startIndex, @Param("pageSize") int pageSize);
    List<Message> selectByConditionOrderByWithPagination(@Param("condition") Message condition, 
            @Param("orderBy") String orderBy, @Param("startIndex") int startIndex, @Param("pageSize") int pageSize);

    int countAll();
    int countByCondition(Message condition);

    List<Message> getMessagesByIds(@Param("ids") List<Integer> ids);
    List<Integer> getFixedOrderMessageIds(@Param("condition") Message condition, @Param("orderBy") String orderBy);
}