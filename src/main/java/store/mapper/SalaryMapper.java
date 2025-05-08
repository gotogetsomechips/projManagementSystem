package store.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import store.bean.Salary;

public interface SalaryMapper {
    int insert(Salary salary);
    int deleteById(Integer id);
    int batchDelete(@Param("ids") List<Integer> ids);
    int update(Salary salary);
    Salary selectById(Integer id);
    List<Salary> selectAll();
    List<Salary> selectByCondition(Salary condition);
    List<Salary> selectAllOrderBy(String orderBy);
    
    // 分页相关方法
    List<Salary> selectAllWithPagination(@Param("startIndex") int startIndex, @Param("pageSize") int pageSize);
    List<Salary> selectByConditionWithPagination(@Param("condition") Salary condition, 
                                               @Param("startIndex") int startIndex, 
                                               @Param("pageSize") int pageSize);
    List<Salary> selectAllOrderByWithPagination(@Param("orderBy") String orderBy, 
                                              @Param("startIndex") int startIndex, 
                                              @Param("pageSize") int pageSize);
    List<Salary> selectByConditionOrderByWithPagination(@Param("condition") Salary condition, 
                                                      @Param("orderBy") String orderBy, 
                                                      @Param("startIndex") int startIndex, 
                                                      @Param("pageSize") int pageSize);
    
    int countAll();
    int countByCondition(Salary condition);
}