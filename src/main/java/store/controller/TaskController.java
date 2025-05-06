package store.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

    @RequestMapping("/list")
    public String list(Model model,
                      @RequestParam(value = "orderBy", required = false) String orderBy) {
        List<Task> tasks;
        if (orderBy != null && !orderBy.isEmpty()) {
            tasks = taskService.getTasksWithOrder(orderBy);
        } else {
            tasks = taskService.getAllTasks();
        }
        model.addAttribute("tasks", tasks);
        return "task_list";
    }

    @RequestMapping("/search")
    public String search(Model model, Task condition) {
        List<Task> tasks = taskService.getTasksByCondition(condition);
        model.addAttribute("tasks", tasks);
        model.addAttribute("condition", condition);
        return "task_list";
    }

    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String addForm() {
        return "task_add";
    }

    @RequestMapping(value = "/add", method = RequestMethod.POST)
    public String add(Task task, Model model) {
        if (task.getTitle() == null || task.getTitle().trim().isEmpty() ||
            task.getCreatorName() == null || task.getCreatorName().trim().isEmpty() ||
            task.getExecutorName() == null || task.getExecutorName().trim().isEmpty()) {
            model.addAttribute("error", "必填项不能为空");
            return "task_add";
        }
        
        // 设置默认值
        task.setCreatorId(1); // 假设当前用户ID为1
        task.setStatus(1); // 默认状态为未开始
        
        boolean success = taskService.addTask(task);
        if (success) {
            return "redirect:/task/list";
        } else {
            model.addAttribute("error", "添加任务失败");
            return "task_add";
        }
    }

    @RequestMapping("/checkTitle")
    @ResponseBody
    public Map<String, Boolean> checkTitle(@RequestParam String title) {
        Map<String, Boolean> result = new HashMap<>();
        result.put("valid", !taskService.isTitleExist(title));
        return result;
    }

    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String editForm(@RequestParam Integer id, Model model) {
        Task task = taskService.getTaskById(id);
        model.addAttribute("task", task);
        return "task_edit";
    }

    @RequestMapping(value = "/edit", method = RequestMethod.POST)
    public String edit(Task task, Model model) {
        if (task.getTitle() == null || task.getTitle().trim().isEmpty() ||
            task.getCreatorName() == null || task.getCreatorName().trim().isEmpty() ||
            task.getExecutorName() == null || task.getExecutorName().trim().isEmpty()) {
            model.addAttribute("error", "必填项不能为空");
            model.addAttribute("task", task);
            return "task_edit";
        }
        
        boolean success = taskService.updateTask(task);
        if (success) {
            return "redirect:/task/list";
        } else {
            model.addAttribute("error", "更新任务失败");
            model.addAttribute("task", task);
            return "task_edit";
        }
    }

    @RequestMapping("/view")
    public String view(@RequestParam Integer id, Model model) {
        Task task = taskService.getTaskById(id);
        model.addAttribute("task", task);
        return "task_view";
    }

    @RequestMapping("/delete")
    @ResponseBody
    public Map<String, Object> delete(@RequestParam Integer id) {
        Map<String, Object> result = new HashMap<>();
        boolean success = taskService.deleteTask(id);
        result.put("success", success);
        result.put("message", success ? "删除成功" : "删除失败");
        return result;
    }

    @RequestMapping("/batchDelete")
    @ResponseBody
    public Map<String, Object> batchDelete(@RequestParam List<Integer> ids) {
        Map<String, Object> result = new HashMap<>();
        boolean success = taskService.deleteTasks(ids);
        result.put("success", success);
        result.put("message", success ? "批量删除成功" : "批量删除失败");
        return result;
    }
}