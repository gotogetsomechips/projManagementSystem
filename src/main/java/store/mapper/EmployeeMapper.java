package store.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import store.bean.Employee;

public interface EmployeeMapper {
    int insert(Employee employee);
    int deleteById(Integer id);
    int batchDelete(@Param("ids") List<Integer> ids);
    int update(Employee employee);
    Employee selectById(Integer id);
    List<Employee> selectAll();
    List<Employee> selectByCondition(Employee condition);
    int countByEmpNo(String empNo);
    List<Employee> selectAllOrderBy(String orderBy);
    Employee selectByEmpNo(String empNo);
    List<Integer> getFixedOrderEmployeeIds(@Param("condition") Employee condition, @Param("orderBy") String orderBy);
    List<Employee> getEmployeesByIds(@Param("ids") List<Integer> ids);
    int updateStatusByEmpNo(@Param("empNo") String empNo, @Param("status") Integer status);

    // 分页相关的方法
    List<Employee> selectAllWithPagination(@Param("startIndex") int startIndex, @Param("pageSize") int pageSize);
    List<Employee> selectByConditionWithPagination(@Param("condition") Employee condition,
                                                   @Param("startIndex") int startIndex, @Param("pageSize") int pageSize);
    List<Employee> selectAllOrderByWithPagination(@Param("orderBy") String orderBy,
                                                  @Param("startIndex") int startIndex, @Param("pageSize") int pageSize);
    List<Employee> selectByConditionOrderByWithPagination(@Param("condition") Employee condition,
                                                          @Param("orderBy") String orderBy, @Param("startIndex") int startIndex, @Param("pageSize") int pageSize);

    int countAll();
    int countByCondition(Employee condition);
}