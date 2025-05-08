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
import store.bean.Employee;
import store.service.EmployeeService;

@Controller
@RequestMapping("/employee")
public class EmployeeController {

    @Autowired
    private EmployeeService employeeService;

    private static final int PAGE_SIZE = 10;

    @RequestMapping("/list")
    public String list(Model model,
                       @RequestParam(value = "searchColumn", required = false) String searchColumn,
                       @RequestParam(value = "keyword", required = false) String keyword,
                       @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                       @RequestParam(value = "sortField", required = false) String sortField,
                       @RequestParam(value = "sortDirection", required = false) String sortDirection,
                       @RequestParam(value = "message", required = false) String message) {

        // 消息处理
        if (message != null) {
            switch (message) {
                case "add_success":
                    model.addAttribute("operationMessage", "员工添加成功！");
                    break;
                case "edit_success":
                    model.addAttribute("operationMessage", "员工修改成功！");
                    break;
                case "delete_success":
                    model.addAttribute("operationMessage", "员工删除成功！");
                    break;
                case "delete_fail":
                    model.addAttribute("operationMessage", "员工删除失败！");
                    break;
            }
        }

        if (pageNum < 1) pageNum = 1;

        // 创建查询条件
        Employee condition = new Employee();
        if (searchColumn != null && keyword != null && !keyword.isEmpty()) {
            if ("empNo".equals(searchColumn)) {
                condition.setEmpNo(keyword);
            } else if ("empName".equals(searchColumn)) {
                condition.setEmpName(keyword);
            } else if ("phone".equals(searchColumn)) {
                condition.setPhone(keyword);
            }
        }

        // 获取总记录数
        int totalCount;
        if (condition.getEmpNo() != null || condition.getEmpName() != null || condition.getPhone() != null) {
            totalCount = employeeService.countEmployeesByCondition(condition);
        } else {
            totalCount = employeeService.countAllEmployees();
        }

        // 计算总页数
        int totalPages = (totalCount + PAGE_SIZE - 1) / PAGE_SIZE;
        if (totalPages > 0 && pageNum > totalPages) {
            pageNum = totalPages;
        }

        // 获取固定顺序的数据ID
        List<Integer> fixedOrderIds = employeeService.getFixedOrderEmployeeIds(condition, "id DESC");

        // 获取分页数据
        int startIndex = (pageNum - 1) * PAGE_SIZE;
        int endIndex = Math.min(startIndex + PAGE_SIZE, fixedOrderIds.size());
        List<Integer> pageIds = fixedOrderIds.subList(startIndex, endIndex);
        List<Employee> employeeList = employeeService.getEmployeesByIds(pageIds);

        // 排序当前页数据
        if (sortField != null && !sortField.isEmpty() && sortDirection != null && !sortDirection.isEmpty()) {
            employeeList = employeeService.sortCurrentPage(employeeList, sortField, sortDirection);
        }

        model.addAttribute("list", employeeList);
        model.addAttribute("pageNum", pageNum);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("searchColumn", searchColumn);
        model.addAttribute("keyword", keyword);
        model.addAttribute("sortField", sortField);
        model.addAttribute("sortDirection", sortDirection);

        return "employee_list";
    }

    // 其他方法(add, edit, delete等)与UserController类似，只需替换User为Employee
    // ...

    @ResponseBody
    @RequestMapping(value = "/checkEmpNo", method = RequestMethod.POST)
    public String checkEmpNo(@RequestParam("empNo") String empNo) {
        boolean exists = employeeService.isEmpNoExist(empNo);
        return exists ? "false" : "true";
    }
}