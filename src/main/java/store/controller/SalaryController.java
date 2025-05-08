package store.controller;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

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

        // 处理消息
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
                case "pay_success":
                    model.addAttribute("operationMessage", "薪资发放成功！");
                    break;
                case "pay_fail":
                    model.addAttribute("operationMessage", "薪资发放失败！");
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

        // 先获取固定顺序的数据ID（不包含排序条件）
        List<Integer> fixedOrderIds = salaryService.getFixedOrderSalaryIds(condition, "id DESC");

        // 然后根据固定顺序ID获取分页数据
        int startIndex = (pageNum - 1) * PAGE_SIZE;
        int endIndex = Math.min(startIndex + PAGE_SIZE, fixedOrderIds.size());
        List<Integer> pageIds = fixedOrderIds.subList(startIndex, endIndex);
        List<Salary> salaryList = salaryService.getSalariesByIds(pageIds);

        // 如果有排序参数，对当前页数据进行排序
        if (sortField != null && !sortField.isEmpty() && sortDirection != null && !sortDirection.isEmpty()) {
            salaryList = salaryService.sortCurrentPage(salaryList, sortField, sortDirection);
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

        // 验证员工是否存在
        if (salaryService.isEmployeeExist(salary.getEmployeeName())) {
            request.setAttribute("error", "员工已存在");
            return "salary_add";
        }

        // 验证年份
        if (salary.getYear() == null || salary.getYear() < 2000 || salary.getYear() > 2100) {
            request.setAttribute("error", "年份必须在2000-2100之间");
            return "salary_add";
        }

        // 验证月份
        if (salary.getMonth() == null || salary.getMonth() < 1 || salary.getMonth() > 12) {
            request.setAttribute("error", "月份必须在1-12之间");
            return "salary_add";
        }

        // 验证基本工资
        if (salary.getBaseSalary() == null || salary.getBaseSalary() <= 0) {
            request.setAttribute("error", "基本工资必须大于0");
            return "salary_add";
        }

        // 验证奖金不能为负数
        if (salary.getBonus() != null && salary.getBonus() < 0) {
            request.setAttribute("error", "奖金不能为负数");
            return "salary_add";
        }

        // 验证扣款不能为负数
        if (salary.getDeduction() != null && salary.getDeduction() < 0) {
            request.setAttribute("error", "扣款不能为负数");
            return "salary_add";
        }

        // 计算应发工资和实发工资
        salary.setTotalSalary(calculateTotalSalary(salary));
        salary.setActualSalary(calculateActualSalary(salary));

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
            Salary originalSalary = salaryService.getSalaryById(salary.getId());
            request.setAttribute("vo", originalSalary);
            return "salary_edit";
        }

        // 验证奖金不能为负数
        if (salary.getBonus() != null && salary.getBonus() < 0) {
            request.setAttribute("error", "奖金不能为负数");
            Salary originalSalary = salaryService.getSalaryById(salary.getId());
            request.setAttribute("vo", originalSalary);
            return "salary_edit";
        }

        // 验证扣款不能为负数
        if (salary.getDeduction() != null && salary.getDeduction() < 0) {
            request.setAttribute("error", "扣款不能为负数");
            Salary originalSalary = salaryService.getSalaryById(salary.getId());
            request.setAttribute("vo", originalSalary);
            return "salary_edit";
        }

        // 计算应发工资和实发工资
        salary.setTotalSalary(calculateTotalSalary(salary));
        salary.setActualSalary(calculateActualSalary(salary));

        // 获取原始薪资数据
        Salary originalSalary = salaryService.getSalaryById(salary.getId());

        // 检查员工姓名、年份和月份是否被修改
        if (!salary.getEmployeeName().equals(originalSalary.getEmployeeName()) ||
                !salary.getYear().equals(originalSalary.getYear()) ||
                !salary.getMonth().equals(originalSalary.getMonth())) {

            if (salaryService.isSalaryExistByEmployeeName(salary.getEmployeeName(), salary.getYear(), salary.getMonth())) {
                request.setAttribute("error", "该员工该月份的薪资记录已存在");
                request.setAttribute("vo", originalSalary);
                return "salary_edit";
            }
        }

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

    @RequestMapping("/pay")
    public String paySalary(@RequestParam("id") Integer id,
                            @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                            @RequestParam(value = "sortField", required = false) String sortField,
                            @RequestParam(value = "sortDirection", required = false) String sortDirection) {
        int result = salaryService.paySalary(id, "admin"); // 实际应该从session获取当前登录用户
        String redirectUrl = "redirect:/salary/list?pageNum=" + pageNum;
        if (result > 0) {
            redirectUrl += "&message=pay_success";
        } else {
            redirectUrl += "&message=pay_fail";
        }
        if (sortField != null && sortDirection != null) {
            redirectUrl += "&sortField=" + sortField + "&sortDirection=" + sortDirection;
        }
        return redirectUrl;
    }

    @RequestMapping("/batchPay")
    public String batchPaySalary(@RequestParam("ids") List<Integer> ids,
                                 @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                                 @RequestParam(value = "sortField", required = false) String sortField,
                                 @RequestParam(value = "sortDirection", required = false) String sortDirection) {
        int result = salaryService.batchPaySalary(ids, "admin"); // 实际应该从session获取当前登录用户
        String redirectUrl = "redirect:/salary/list?pageNum=" + pageNum;
        if (result > 0) {
            redirectUrl += "&message=pay_success";
        } else {
            redirectUrl += "&message=pay_fail";
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

    @ResponseBody
    @RequestMapping(value = "/checkEmployee", method = RequestMethod.POST)
    public String checkEmployee(@RequestParam("employeeName") String employeeName) {
        boolean exists = salaryService.isEmployeeExist(employeeName);
        return exists ? "true" : "false";
    }

    @ResponseBody
    @RequestMapping(value = "/checkSalaryExist", method = RequestMethod.POST)
    public String checkSalaryExist(@RequestParam("employeeName") String employeeName,
                                   @RequestParam("year") Integer year,
                                   @RequestParam("month") Integer month) {
        boolean exists = salaryService.isSalaryExistByEmployeeName(employeeName, year, month);
        return exists ? "true" : "false";
    }
    // 计算应发工资
    private Double calculateTotalSalary(Salary salary) {
        double total = salary.getBaseSalary();
        if (salary.getBonus() != null) {
            total += salary.getBonus();
        }
        return total;
    }

    // 计算实发工资
    private Double calculateActualSalary(Salary salary) {
        double actual = calculateTotalSalary(salary);
        if (salary.getDeduction() != null) {
            actual -= salary.getDeduction();
        }
        return actual;
    }
}