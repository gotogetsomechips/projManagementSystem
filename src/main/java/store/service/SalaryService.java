package store.service;

import java.util.List;
import store.bean.Salary;

public interface SalaryService {
    int addSalary(Salary salary);
    int deleteSalary(Integer id);
    int batchDelete(List<Integer> ids);
    int updateSalary(Salary salary);
    Salary getSalaryById(Integer id);
    List<Salary> getAllSalaries();
    List<Salary> getSalariesByCondition(Salary condition);
    boolean isSalaryExist(Integer employeeId, Integer year, Integer month);

    // 分页相关方法
    List<Salary> getAllSalariesWithPagination(int startIndex, int pageSize);
    List<Salary> getSalariesByConditionWithPagination(Salary condition, int startIndex, int pageSize);
    List<Salary> getAllSalariesOrderByWithPagination(String orderBy, int startIndex, int pageSize);
    List<Salary> getSalariesByConditionOrderByWithPagination(Salary condition, String orderBy, int startIndex, int pageSize);

    // 固定顺序ID方法
    List<Integer> getFixedOrderSalaryIds(Salary condition, String orderBy);
    List<Salary> getSalariesByIds(List<Integer> ids);

    int countAllSalaries();
    int countSalariesByCondition(Salary condition);
    // 修改为使用员工姓名检查
    boolean isSalaryExistByEmployeeName(String employeeName, Integer year, Integer month);

    // 新增方法：检查员工姓名是否存在
    boolean isEmployeeExist(String employeeName);
    // 排序方法
    List<Salary> sortCurrentPage(List<Salary> salaryList, String sortField, String sortDirection);

    // 发放工资
    int paySalary(Integer id, String paymentBy);
    int batchPaySalary(List<Integer> ids, String paymentBy);
}