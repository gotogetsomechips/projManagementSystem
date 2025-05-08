package store.service;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import store.bean.Salary;
import store.mapper.SalaryMapper;

@Service
public class SalaryServiceImpl implements SalaryService {

    @Autowired
    private SalaryMapper salaryMapper;

    @Override
    public int addSalary(Salary salary) {
        return salaryMapper.insert(salary);
    }

    @Override
    public int deleteSalary(Integer id) {
        return salaryMapper.deleteById(id);
    }

    @Override
    public int batchDelete(List<Integer> ids) {
        return salaryMapper.batchDelete(ids);
    }

    @Override
    public int updateSalary(Salary salary) {
        return salaryMapper.update(salary);
    }

    @Override
    public Salary getSalaryById(Integer id) {
        return salaryMapper.selectById(id);
    }

    @Override
    public List<Salary> getAllSalaries() {
        return salaryMapper.selectAll();
    }

    @Override
    public List<Salary> getSalariesByCondition(Salary condition) {
        return salaryMapper.selectByCondition(condition);
    }

    @Override
    public boolean isSalaryExist(Integer employeeId, Integer year, Integer month) {
        return salaryMapper.countByEmployeeYearMonth(employeeId, year, month) > 0;
    }

    @Override
    public List<Salary> getAllSalariesWithPagination(int startIndex, int pageSize) {
        return salaryMapper.selectAllWithPagination(startIndex, pageSize);
    }

    @Override
    public List<Salary> getSalariesByConditionWithPagination(Salary condition, int startIndex, int pageSize) {
        return salaryMapper.selectByConditionWithPagination(condition, startIndex, pageSize);
    }

    @Override
    public List<Salary> getAllSalariesOrderByWithPagination(String orderBy, int startIndex, int pageSize) {
        return salaryMapper.selectAllOrderByWithPagination(orderBy, startIndex, pageSize);
    }

    @Override
    public List<Salary> getSalariesByConditionOrderByWithPagination(Salary condition, String orderBy, int startIndex, int pageSize) {
        return salaryMapper.selectByConditionOrderByWithPagination(condition, orderBy, startIndex, pageSize);
    }

    @Override
    public List<Integer> getFixedOrderSalaryIds(Salary condition, String orderBy) {
        return salaryMapper.getFixedOrderSalaryIds(condition, "id DESC");
    }

    @Override
    public List<Salary> getSalariesByIds(List<Integer> ids) {
        if (ids == null || ids.isEmpty()) {
            return Collections.emptyList();
        }
        return salaryMapper.getSalariesByIds(ids);
    }

    @Override
    public int countAllSalaries() {
        return salaryMapper.countAll();
    }

    @Override
    public int countSalariesByCondition(Salary condition) {
        return salaryMapper.countByCondition(condition);
    }

    @Override
    public List<Salary> sortCurrentPage(List<Salary> salaryList, String sortField, String sortDirection) {
        Comparator<Salary> comparator = getComparator(sortField);

        if ("DESC".equalsIgnoreCase(sortDirection)) {
            comparator = comparator.reversed();
        }

        return salaryList.stream()
                .sorted(comparator)
                .collect(Collectors.toList());
    }

    private Comparator<Salary> getComparator(String sortField) {
        switch(sortField) {
            case "employeeName":
                return Comparator.comparing(Salary::getEmployeeName);
            case "year":
                return Comparator.comparing(Salary::getYear);
            case "month":
                return Comparator.comparing(Salary::getMonth);
            case "totalSalary":
                return Comparator.comparing(Salary::getTotalSalary);
            case "actualSalary":
                return Comparator.comparing(Salary::getActualSalary);
            case "status":
                return Comparator.comparing(Salary::getStatus);
            default:
                return Comparator.comparing(Salary::getId);
        }
    }
    @Override
    public boolean isSalaryExistByEmployeeName(String employeeName, Integer year, Integer month) {
        return salaryMapper.countByEmployeeNameYearMonth(employeeName, year, month) > 0;
    }

    @Override
    public boolean isEmployeeExist(String employeeName) {
        return salaryMapper.countByEmployeeName(employeeName) > 0;
    }
    @Override
    public int paySalary(Integer id, String paymentBy) {
        return salaryMapper.updateStatusById(id, 1, paymentBy);
    }

    @Override
    public int batchPaySalary(List<Integer> ids, String paymentBy) {
        return salaryMapper.batchUpdateStatus(ids, 1, paymentBy);
    }
}