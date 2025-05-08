package store.service;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import store.bean.Employee;
import store.mapper.EmployeeMapper;

@Service
public class EmployeeServiceImpl implements EmployeeService {

    @Autowired
    private EmployeeMapper employeeMapper;

    @Override
    public int addEmployee(Employee employee) {
        return employeeMapper.insert(employee);
    }

    @Override
    public Employee getEmployeeByEmpNo(String empNo) {
        return employeeMapper.selectByEmpNo(empNo);
    }

    @Override
    public void lockEmployee(String empNo) {
        employeeMapper.updateStatusByEmpNo(empNo, 1);
    }

    @Override
    public void unlockEmployee(String empNo) {
        employeeMapper.updateStatusByEmpNo(empNo, 0);
    }

    @Override
    public int deleteEmployee(Integer id) {
        return employeeMapper.deleteById(id);
    }

    @Override
    public int batchDelete(List<Integer> ids) {
        return employeeMapper.batchDelete(ids);
    }

    @Override
    public int updateEmployee(Employee employee) {
        return employeeMapper.update(employee);
    }

    @Override
    public Employee getEmployeeById(Integer id) {
        return employeeMapper.selectById(id);
    }

    @Override
    public List<Employee> getAllEmployees() {
        return employeeMapper.selectAll();
    }

    @Override
    public List<Employee> getEmployeesByCondition(Employee condition) {
        return employeeMapper.selectByCondition(condition);
    }

    @Override
    public boolean isEmpNoExist(String empNo) {
        return employeeMapper.countByEmpNo(empNo) > 0;
    }

    @Override
    public List<Employee> getAllEmployeesOrderBy(String orderBy) {
        return employeeMapper.selectAllOrderBy(orderBy);
    }

    @Override
    public List<Employee> getAllEmployeesWithPagination(int startIndex, int pageSize) {
        return employeeMapper.selectAllWithPagination(startIndex, pageSize);
    }

    @Override
    public List<Employee> getEmployeesByConditionWithPagination(Employee condition, int startIndex, int pageSize) {
        return employeeMapper.selectByConditionWithPagination(condition, startIndex, pageSize);
    }

    @Override
    public List<Employee> getAllEmployeesOrderByWithPagination(String orderBy, int startIndex, int pageSize) {
        return employeeMapper.selectAllOrderByWithPagination(orderBy, startIndex, pageSize);
    }

    @Override
    public List<Employee> getEmployeesByConditionOrderByWithPagination(Employee condition, String orderBy, int startIndex, int pageSize) {
        return employeeMapper.selectByConditionOrderByWithPagination(condition, orderBy, startIndex, pageSize);
    }

    @Override
    public int countAllEmployees() {
        return employeeMapper.countAll();
    }

    @Override
    public int countEmployeesByCondition(Employee condition) {
        return employeeMapper.countByCondition(condition);
    }

    @Override
    public List<Integer> getFixedOrderEmployeeIds(Employee condition, String orderBy) {
        // 这里保持固定排序方式，不受前端排序参数影响
        return employeeMapper.getFixedOrderEmployeeIds(condition, "id DESC");
    }

    @Override
    public List<Employee> getEmployeesByIds(List<Integer> ids) {
        if (ids == null || ids.isEmpty()) {
            return Collections.emptyList();
        }
        return employeeMapper.getEmployeesByIds(ids);
    }

    // 辅助方法：对当前页数据进行排序
    public List<Employee> sortCurrentPage(List<Employee> employeeList, String sortField, String sortDirection) {
        Comparator<Employee> comparator = getComparator(sortField);

        if ("DESC".equalsIgnoreCase(sortDirection)) {
            comparator = comparator.reversed();
        }

        return employeeList.stream()
                .sorted(comparator)
                .collect(Collectors.toList());
    }

    private Comparator<Employee> getComparator(String sortField) {
        switch(sortField) {
            case "empNo":
                return Comparator.comparing(Employee::getEmpNo);
            case "empName":
                return Comparator.comparing(Employee::getEmpName);
            case "phone":
                return Comparator.comparing(Employee::getPhone);
            case "email":
                return Comparator.comparing(Employee::getEmail);
            case "status":
                return Comparator.comparing(Employee::getStatus);
            default:
                return Comparator.comparing(Employee::getId);
        }
    }
}