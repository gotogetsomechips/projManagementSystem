package store.service;

import java.util.List;
import store.bean.Employee;

public interface EmployeeService {
    int addEmployee(Employee employee);
    int deleteEmployee(Integer id);
    int batchDelete(List<Integer> ids);
    int updateEmployee(Employee employee);
    Employee getEmployeeById(Integer id);
    List<Employee> getAllEmployees();
    List<Employee> getEmployeesByCondition(Employee condition);
    boolean isEmpNoExist(String empNo);
    List<Employee> getAllEmployeesOrderBy(String orderBy);
    Employee getEmployeeByEmpNo(String empNo);
    void lockEmployee(String empNo);
    void unlockEmployee(String empNo);

    // 分页相关的方法
    List<Employee> getAllEmployeesWithPagination(int startIndex, int pageSize);
    List<Employee> getEmployeesByConditionWithPagination(Employee condition, int startIndex, int pageSize);
    List<Employee> getAllEmployeesOrderByWithPagination(String orderBy, int startIndex, int pageSize);
    List<Employee> getEmployeesByConditionOrderByWithPagination(Employee condition, String orderBy, int startIndex, int pageSize);

    // 新增方法：获取固定顺序的员工ID列表
    List<Integer> getFixedOrderEmployeeIds(Employee condition, String orderBy);
    // 新增方法：根据ID列表获取员工
    List<Employee> getEmployeesByIds(List<Integer> ids);
    int countAllEmployees();
    int countEmployeesByCondition(Employee condition);

    List<Employee> sortCurrentPage(List<Employee> employeeList, String sortField, String sortDirection);
}