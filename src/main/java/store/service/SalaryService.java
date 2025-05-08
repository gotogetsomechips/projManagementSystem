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
    List<Salary> getAllSalariesOrderBy(String orderBy);

    // 分页相关方法
    List<Salary> getAllSalariesWithPagination(int startIndex, int pageSize);
    List<Salary> getSalariesByConditionWithPagination(Salary condition, int startIndex, int pageSize);
    List<Salary> getAllSalariesOrderByWithPagination(String orderBy, int startIndex, int pageSize);
    List<Salary> getSalariesByConditionOrderByWithPagination(Salary condition, String orderBy, int startIndex, int pageSize);

    int countAllSalaries();
    int countSalariesByCondition(Salary condition);
}