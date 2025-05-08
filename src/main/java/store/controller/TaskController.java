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
import store.bean.Task;
import store.service.TaskService;

@Controller
@RequestMapping("/task")
public class TaskController {

    @Autowired
    private TaskService taskService;

    // 每页显示的记录数
    private static final int PAGE_SIZE = 10;

    @RequestMapping("/list")
    public String list(Model model,
                       @RequestParam(value = "searchColumn", required = false) String searchColumn,
                       @RequestParam(value = "keyword", required = false) String keyword,
                       @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                       @RequestParam(value = "sortField", required = false) String sortField,
                       @RequestParam(value = "sortDirection", required = false) String sortDirection,
                       @RequestParam(value = "message", required = false) String message) {

        // 添加消息处理
        if (message != null) {
            switch (message) {
                case "add_success":
                    model.addAttribute("operationMessage", "任务添加成功！");
                    break;
                case "edit_success":
                    model.addAttribute("operationMessage", "任务修改成功！");
                    break;
                case "delete_success":
                    model.addAttribute("operationMessage", "任务删除成功！");
                    break;
                case "delete_fail":
                    model.addAttribute("operationMessage", "任务删除失败！");
                    break;
            }
        }

        // 确保页码不小于1
        if (pageNum < 1) {
            pageNum = 1;
        }

        // 创建查询条件
        Task condition = new Task();
        if (searchColumn != null && keyword != null && !keyword.isEmpty()) {
            if ("title".equals(searchColumn)) {
                condition.setTitle(keyword);
            } else if ("creator".equals(searchColumn)) {
                condition.setCreator(keyword);
            } else if ("assignee".equals(searchColumn)) {
                condition.setAssignee(keyword);
            }
        }

        // 获取总记录数用于分页
        int totalCount;
        if (condition.getTitle() != null || condition.getCreator() != null || condition.getAssignee() != null) {
            totalCount = taskService.countTasksByCondition(condition);
        } else {
            totalCount = taskService.countAllTasks();
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
        List<Task> taskList;
        String orderBy = null;
        if (sortField != null && !sortField.isEmpty() && sortDirection != null && !sortDirection.isEmpty()) {
            orderBy = sortField + " " + sortDirection;
        }

        if (condition.getTitle() != null || condition.getCreator() != null || condition.getAssignee() != null) {
            if (orderBy != null) {
                taskList = taskService.getTasksByConditionOrderByWithPagination(condition, orderBy, startIndex, PAGE_SIZE);
            } else {
                taskList = taskService.getTasksByConditionWithPagination(condition, startIndex, PAGE_SIZE);
            }
        } else {
            if (orderBy != null) {
                taskList = taskService.getAllTasksOrderByWithPagination(orderBy, startIndex, PAGE_SIZE);
            } else {
                taskList = taskService.getAllTasksWithPagination(startIndex, PAGE_SIZE);
            }
        }
        // 设置分页相关属性
        model.addAttribute("list", taskList);
        model.addAttribute("pageNum", pageNum);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalCount", totalCount);

        // 保留搜索条件和排序条件
        model.addAttribute("searchColumn", searchColumn);
        model.addAttribute("keyword", keyword);
        model.addAttribute("sortField", sortField);
        model.addAttribute("sortDirection", sortDirection);

        return "task_list";
    }

    @RequestMapping("/add")
    public String add(Task task, HttpServletRequest request,
                      @RequestParam(value = "sortField", required = false) String sortField,
                      @RequestParam(value = "sortDirection", required = false) String sortDirection) {
        // 验证任务标题
        if (task.getTitle() == null || task.getTitle().isEmpty()) {
            request.setAttribute("error", "任务标题不能为空");
            return "task_add";
        }

        // 验证任务标题是否存在
        if (taskService.isTitleExist(task.getTitle())) {
            request.setAttribute("error", "任务标题已存在");
            return "task_add";
        }

        // 验证执行人
        if (task.getAssignee() == null || task.getAssignee().isEmpty()) {
            request.setAttribute("error", "执行人不能为空");
            return "task_add";
        }

        task.setCreateBy("admin"); // 实际应该从session获取当前登录用户
        int result = taskService.addTask(task);
        if (result > 0) {
            // 添加成功，设置成功消息并保留排序参数
            String redirectUrl = "redirect:/task/list?message=add_success";
            if (sortField != null && sortDirection != null) {
                redirectUrl += "&sortField=" + sortField + "&sortDirection=" + sortDirection;
            }
            return redirectUrl;
        } else {
            request.setAttribute("error", "添加任务失败");
            return "task_add";
        }
    }

    @RequestMapping("/edit")
    public String edit(Task task, HttpServletRequest request,
                       @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                       @RequestParam(value = "sortField", required = false) String sortField,
                       @RequestParam(value = "sortDirection", required = false) String sortDirection) {
        // 验证任务标题
        if (task.getTitle() == null || task.getTitle().isEmpty()) {
            request.setAttribute("error", "任务标题不能为空");
            // 重新获取任务信息
            Task originalTask = taskService.getTaskById(task.getId());
            request.setAttribute("vo", originalTask);
            return "task_edit";
        }

        // 获取原始任务数据
        Task originalTask = taskService.getTaskById(task.getId());

        // 检查任务标题是否已被修改，如果修改了，需要检查唯一性
        if (!task.getTitle().equals(originalTask.getTitle())) {
            if (taskService.isTitleExist(task.getTitle())) {
                request.setAttribute("error", "任务标题已存在");
                request.setAttribute("vo", originalTask);
                return "task_edit";
            }
        }

        // 验证执行人
        if (task.getAssignee() == null || task.getAssignee().isEmpty()) {
            request.setAttribute("error", "执行人不能为空");
            request.setAttribute("vo", originalTask);
            return "task_edit";
        }

        // 检查是否有实际修改
        boolean hasChanged = !task.getTitle().equals(originalTask.getTitle()) ||
                !task.getDescription().equals(originalTask.getDescription()) ||
                !task.getCreator().equals(originalTask.getCreator()) ||
                !task.getAssignee().equals(originalTask.getAssignee()) ||
                !task.getPriority().equals(originalTask.getPriority()) ||
                !task.getStatus().equals(originalTask.getStatus());

        if (!hasChanged) {
            request.setAttribute("error", "未做任何修改，无需提交");
            request.setAttribute("vo", originalTask);
            return "task_edit";
        }

        int result = taskService.updateTask(task);
        if (result > 0) {
            String redirectUrl = "redirect:/task/list?message=edit_success&pageNum=" + pageNum;
            if (sortField != null && sortDirection != null) {
                redirectUrl += "&sortField=" + sortField + "&sortDirection=" + sortDirection;
            }
            return redirectUrl;
        } else {
            request.setAttribute("error", "更新任务失败");
            request.setAttribute("vo", originalTask);
            return "task_edit";
        }
    }

    @RequestMapping("/delete")
    public String delete(@RequestParam("id") Integer id,
                         @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                         @RequestParam(value = "sortField", required = false) String sortField,
                         @RequestParam(value = "sortDirection", required = false) String sortDirection) {
        int result = taskService.deleteTask(id);
        String redirectUrl = "redirect:/task/list?pageNum=" + pageNum;
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
        int result = taskService.batchDelete(ids);
        String redirectUrl = "redirect:/task/list?pageNum=" + pageNum;
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
        Task task = taskService.getTaskById(id);
        model.addAttribute("vo", task);
        return "task_info";
    }

    @RequestMapping("/toAdd")
    public String toAdd() {
        return "task_add";
    }

    @RequestMapping("/toEdit")
    public String toEdit(@RequestParam("id") Integer id,
                         @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                         Model model) {
        Task task = taskService.getTaskById(id);
        model.addAttribute("vo", task);
        model.addAttribute("pageNum", pageNum);
        return "task_edit";
    }

    @ResponseBody
    @RequestMapping(value = "/checkTitle", method = RequestMethod.POST)
    public String checkTitle(@RequestParam("title") String title) {
        boolean exists = taskService.isTitleExist(title);
        return exists ? "false" : "true";
    }
}