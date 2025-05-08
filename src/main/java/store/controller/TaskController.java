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
import store.bean.Task;
import store.service.TaskService;

@Controller
@RequestMapping("/task")
public class TaskController {

    @Autowired
    private TaskService taskService;

    private static final int PAGE_SIZE = 10;

    @RequestMapping("/list")
    public String list(Model model,
                       @RequestParam(value = "searchColumn", required = false) String searchColumn,
                       @RequestParam(value = "keyword", required = false) String keyword,
                       @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                       @RequestParam(value = "sortField", required = false) String sortField,
                       @RequestParam(value = "sortDirection", required = false) String sortDirection,
                       @RequestParam(value = "message", required = false) String message) {

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

        if (pageNum < 1) {
            pageNum = 1;
        }

        Task condition = new Task();
        if (searchColumn != null && keyword != null && !keyword.isEmpty()) {
            if ("title".equals(searchColumn)) {
                condition.setTitle(keyword);
            } else if ("creator".equals(searchColumn)) {
                condition.setCreator(keyword);
            } else if ("executor".equals(searchColumn)) {
                condition.setExecutor(keyword);
            }
        }

        int totalCount;
        if (condition.getTitle() != null || condition.getCreator() != null || condition.getExecutor() != null) {
            totalCount = taskService.countTasksByCondition(condition);
        } else {
            totalCount = taskService.countAllTasks();
        }

        int totalPages = (totalCount + PAGE_SIZE - 1) / PAGE_SIZE;

        if (totalPages > 0 && pageNum > totalPages) {
            pageNum = totalPages;
        }

        List<Integer> fixedOrderIds = taskService.getFixedOrderTaskIds(condition, "id DESC");

        int startIndex = (pageNum - 1) * PAGE_SIZE;
        int endIndex = Math.min(startIndex + PAGE_SIZE, fixedOrderIds.size());
        List<Integer> pageIds = fixedOrderIds.subList(startIndex, endIndex);
        List<Task> taskList = taskService.getTasksByIds(pageIds);

        if (sortField != null && !sortField.isEmpty() && sortDirection != null && !sortDirection.isEmpty()) {
            taskList = taskService.sortCurrentPage(taskList, sortField, sortDirection);
        }

        model.addAttribute("list", taskList);
        model.addAttribute("pageNum", pageNum);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalCount", totalCount);

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
        if (task.getTitle() == null || task.getTitle().isEmpty()) {
            request.setAttribute("error", "任务标题不能为空");
            return "task_add";
        }

        if (taskService.isTitleExist(task.getTitle())) {
            request.setAttribute("error", "任务标题已存在");
            return "task_add";
        }

        if (task.getContent() == null || task.getContent().isEmpty()) {
            request.setAttribute("error", "任务内容不能为空");
            return "task_add";
        }

        if (task.getCreator() == null || task.getCreator().isEmpty()) {
            request.setAttribute("error", "创建者不能为空");
            return "task_add";
        }

        if (task.getExecutor() == null || task.getExecutor().isEmpty()) {
            request.setAttribute("error", "执行人不能为空");
            return "task_add";
        }

        if (task.getPriority() == null || task.getPriority().isEmpty()) {
            request.setAttribute("error", "优先级不能为空");
            return "task_add";
        }

        if (task.getStatus() == null || task.getStatus().isEmpty()) {
            request.setAttribute("error", "状态不能为空");
            return "task_add";
        }

        int result = taskService.addTask(task);
        if (result > 0) {
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
        if (task.getTitle() == null || task.getTitle().isEmpty()) {
            request.setAttribute("error", "任务标题不能为空");
            Task originalTask = taskService.getTaskById(task.getId());
            request.setAttribute("vo", originalTask);
            return "task_edit";
        }

        Task originalTask = taskService.getTaskById(task.getId());

        if (!task.getTitle().equals(originalTask.getTitle())) {
            if (taskService.isTitleExist(task.getTitle())) {
                request.setAttribute("error", "任务标题已存在");
                request.setAttribute("vo", originalTask);
                return "task_edit";
            }
        }

        if (task.getContent() == null || task.getContent().isEmpty()) {
            request.setAttribute("error", "任务内容不能为空");
            request.setAttribute("vo", originalTask);
            return "task_edit";
        }

        boolean hasChanged = !task.getTitle().equals(originalTask.getTitle()) ||
                !task.getContent().equals(originalTask.getContent()) ||
                !task.getCreator().equals(originalTask.getCreator()) ||
                !task.getExecutor().equals(originalTask.getExecutor()) ||
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