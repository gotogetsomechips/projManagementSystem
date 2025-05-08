package store.mapper;

import java.util.Date;
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
    int countByEmployeeYearMonth(@Param("employeeId") Integer employeeId,
                                 @Param("year") Integer year,
                                 @Param("month") Integer month);

    // 分页相关方法
    List<Salary> selectAllWithPagination(@Param("startIndex") int startIndex,
                                         @Param("pageSize") int pageSize);
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

    // 固定顺序ID方法
    List<Integer> getFixedOrderSalaryIds(@Param("condition") Salary condition,
                                         @Param("orderBy") String orderBy);
    List<Salary> getSalariesByIds(@Param("ids") List<Integer> ids);

    int countAll();
    int countByCondition(Salary condition);
    int countByEmployeeNameYearMonth(@Param("employeeName") String employeeName,
                                     @Param("year") Integer year,
                                     @Param("month") Integer month);

    int countByEmployeeName(@Param("employeeName") String employeeName);
    // 更新状态方法
    int updateStatusById(@Param("id") Integer id,
                         @Param("status") Integer status,
                         @Param("paymentBy") String paymentBy);
    int batchUpdateStatus(@Param("ids") List<Integer> ids,
                          @Param("status") Integer status,
                          @Param("paymentBy") String paymentBy);
}