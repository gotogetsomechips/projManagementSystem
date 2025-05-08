package store.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import store.bean.Salary;
import store.mapper.SalaryMapper;
import store.service.SalaryService;

@Service
public class SalaryServiceImpl implements SalaryService {

    @Autowired
    private SalaryMapper salaryMapper;

    @Override
    public int addSalary(Salary salary) {
        // 计算总工资和实发工资
        salary.setTotalSalary(salary.getBaseSalary() + salary.getBonus());
        salary.setActualSalary(salary.getTotalSalary() - salary.getDeduction());
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
        // 重新计算总工资和实发工资
        salary.setTotalSalary(salary.getBaseSalary() + salary.getBonus());
        salary.setActualSalary(salary.getTotalSalary() - salary.getDeduction());
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
    public List<Salary> getAllSalariesOrderBy(String orderBy) {
        return salaryMapper.selectAllOrderBy(orderBy);
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
    public int countAllSalaries() {
        return salaryMapper.countAll();
    }

    @Override
    public int countSalariesByCondition(Salary condition) {
        return salaryMapper.countByCondition(condition);
    }
}