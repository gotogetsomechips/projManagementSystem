package store.controller;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import store.bean.Salary;
import store.service.SalaryService;

@Controller
@RequestMapping("/salary")
public class SalaryController {

    @Autowired
    private SalaryService salaryService;
    private String convertCamelToUnderscore(String camelCase) {
        return camelCase.replaceAll("([a-z])([A-Z])", "$1_$2").toLowerCase();
    }
    // 每页显示的记录数
    private static final int PAGE_SIZE = 10;

    @RequestMapping("/list")
    public String list(Model model,
                      @RequestParam(value = "searchColumn", required = false) String searchColumn,
                      @RequestParam(value = "keyword", required = false) String keyword,
                      @RequestParam(value = "year", required = false) Integer year,
                      @RequestParam(value = "month", required = false) Integer month,
                      @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                      @RequestParam(value = "sortField", required = false) String sortField,
                      @RequestParam(value = "sortDirection", required = false) String sortDirection,
                      @RequestParam(value = "message", required = false) String message) {

        // 添加消息处理
        if (message != null) {
            switch (message) {
                case "add_success":
                    model.addAttribute("operationMessage", "薪资记录添加成功！");
                    break;
                case "edit_success":
                    model.addAttribute("operationMessage", "薪资记录修改成功！");
                    break;
                case "delete_success":
                    model.addAttribute("operationMessage", "薪资记录删除成功！");
                    break;
                case "delete_fail":
                    model.addAttribute("operationMessage", "薪资记录删除失败！");
                    break;
            }
        }

        // 确保页码不小于1
        if (pageNum < 1) {
            pageNum = 1;
        }

        // 创建查询条件
        Salary condition = new Salary();
        if (searchColumn != null && keyword != null && !keyword.isEmpty()) {
            if ("employeeName".equals(searchColumn)) {
                condition.setEmployeeName(keyword);
            }
        }
        if (year != null) {
            condition.setYear(year);
        }
        if (month != null) {
            condition.setMonth(month);
        }

        // 获取总记录数用于分页
        int totalCount;
        if (condition.getEmployeeName() != null || condition.getYear() != null || condition.getMonth() != null) {
            totalCount = salaryService.countSalariesByCondition(condition);
        } else {
            totalCount = salaryService.countAllSalaries();
        }

        // 计算总页数
        int totalPages = (totalCount + PAGE_SIZE - 1) / PAGE_SIZE;

        // 确保页码不超过总页数
        if (totalPages > 0 && pageNum > totalPages) {
            pageNum = totalPages;
        }

        // 计算分页起始索引
        int startIndex = (pageNum - 1) * PAGE_SIZE;

        // 获取数据时使用排序参数
        List<Salary> salaryList;
        String orderBy = null;
        if (sortField != null && !sortField.isEmpty() && sortDirection != null && !sortDirection.isEmpty()) {
            sortField = convertCamelToUnderscore(sortField);
            orderBy = sortField + " " + sortDirection;
        }

        if (condition.getEmployeeName() != null || condition.getYear() != null || condition.getMonth() != null) {
            if (orderBy != null) {
                salaryList = salaryService.getSalariesByConditionOrderByWithPagination(condition, orderBy, startIndex, PAGE_SIZE);
            } else {
                salaryList = salaryService.getSalariesByConditionWithPagination(condition, startIndex, PAGE_SIZE);
            }
        } else {
            if (orderBy != null) {
                salaryList = salaryService.getAllSalariesOrderByWithPagination(orderBy, startIndex, PAGE_SIZE);
            } else {
                salaryList = salaryService.getAllSalariesWithPagination(startIndex, PAGE_SIZE);
            }
        }

        // 设置分页相关属性
        model.addAttribute("list", salaryList);
        model.addAttribute("pageNum", pageNum);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalCount", totalCount);

        // 保留搜索条件和排序条件
        model.addAttribute("searchColumn", searchColumn);
        model.addAttribute("keyword", keyword);
        model.addAttribute("year", year);
        model.addAttribute("month", month);
        model.addAttribute("sortField", sortField);
        model.addAttribute("sortDirection", sortDirection);

        return "salary_list";
    }

    @RequestMapping("/add")
    public String add(Salary salary, HttpServletRequest request,
                     @RequestParam(value = "sortField", required = false) String sortField,
                     @RequestParam(value = "sortDirection", required = false) String sortDirection) {
        // 验证员工姓名
        if (salary.getEmployeeName() == null || salary.getEmployeeName().isEmpty()) {
            request.setAttribute("error", "员工姓名不能为空");
            return "salary_add";
        }

        // 验证基本工资
        if (salary.getBaseSalary() == null || salary.getBaseSalary() <= 0) {
            request.setAttribute("error", "基本工资必须大于0");
            return "salary_add";
        }

        salary.setCreateBy("admin"); // 实际应该从session获取当前登录用户
        int result = salaryService.addSalary(salary);
        if (result > 0) {
            // 添加成功，设置成功消息并保留排序参数
            String redirectUrl = "redirect:/salary/list?message=add_success";
            if (sortField != null && sortDirection != null) {
                redirectUrl += "&sortField=" + sortField + "&sortDirection=" + sortDirection;
            }
            return redirectUrl;
        } else {
            request.setAttribute("error", "添加薪资记录失败");
            return "salary_add";
        }
    }

    @RequestMapping("/edit")
    public String edit(Salary salary, HttpServletRequest request,
                      @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                      @RequestParam(value = "sortField", required = false) String sortField,
                      @RequestParam(value = "sortDirection", required = false) String sortDirection) {
        // 验证员工姓名
        if (salary.getEmployeeName() == null || salary.getEmployeeName().isEmpty()) {
            request.setAttribute("error", "员工姓名不能为空");
            // 重新获取薪资信息
            Salary originalSalary = salaryService.getSalaryById(salary.getId());
            request.setAttribute("vo", originalSalary);
            return "salary_edit";
        }

        // 验证基本工资
        if (salary.getBaseSalary() == null || salary.getBaseSalary() <= 0) {
            request.setAttribute("error", "基本工资必须大于0");
            // 重新获取薪资信息
            Salary originalSalary = salaryService.getSalaryById(salary.getId());
            request.setAttribute("vo", originalSalary);
            return "salary_edit";
        }

        // 获取原始薪资数据
        Salary originalSalary = salaryService.getSalaryById(salary.getId());

        int result = salaryService.updateSalary(salary);
        if (result > 0) {
            String redirectUrl = "redirect:/salary/list?message=edit_success&pageNum=" + pageNum;
            if (sortField != null && sortDirection != null) {
                redirectUrl += "&sortField=" + sortField + "&sortDirection=" + sortDirection;
            }
            return redirectUrl;
        } else {
            request.setAttribute("error", "更新薪资记录失败");
            request.setAttribute("vo", originalSalary);
            return "salary_edit";
        }
    }

    @RequestMapping("/delete")
    public String delete(@RequestParam("id") Integer id,
                         @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                         @RequestParam(value = "sortField", required = false) String sortField,
                         @RequestParam(value = "sortDirection", required = false) String sortDirection) {
        int result = salaryService.deleteSalary(id);
        String redirectUrl = "redirect:/salary/list?pageNum=" + pageNum;
        if (result > 0) {
            redirectUrl += "&message=delete_success";
        } else {
            redirectUrl += "&message=delete_fail";
        }
        if (sortField != null && sortDirection != null) {
            redirectUrl += "&sortField=" + sortField + "&sortDirection=" + sortDirection;
        }
        return redirectUrl;
    }

    @RequestMapping("/batchDelete")
    public String batchDelete(@RequestParam("ids") List<Integer> ids,
                              @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                              @RequestParam(value = "sortField", required = false) String sortField,
                              @RequestParam(value = "sortDirection", required = false) String sortDirection) {
        int result = salaryService.batchDelete(ids);
        String redirectUrl = "redirect:/salary/list?pageNum=" + pageNum;
        if (result > 0) {
            redirectUrl += "&message=delete_success";
        } else {
            redirectUrl += "&message=delete_fail";
        }
        if (sortField != null && sortDirection != null) {
            redirectUrl += "&sortField=" + sortField + "&sortDirection=" + sortDirection;
        }
        return redirectUrl;
    }

    @RequestMapping("/info")
    public String info(@RequestParam("id") Integer id, Model model) {
        Salary salary = salaryService.getSalaryById(id);
        model.addAttribute("vo", salary);
        return "salary_info";
    }

    @RequestMapping("/toAdd")
    public String toAdd() {
        return "salary_add";
    }

    @RequestMapping("/toEdit")
    public String toEdit(@RequestParam("id") Integer id,
                         @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                         Model model) {
        Salary salary = salaryService.getSalaryById(id);
        model.addAttribute("vo", salary);
        model.addAttribute("pageNum", pageNum);
        return "salary_edit";
    }
}