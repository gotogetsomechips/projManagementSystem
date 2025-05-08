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
import store.bean.User;
import store.service.UserService;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    // 每页显示的记录数
    private static final int PAGE_SIZE = 10;
    // 对当前页数据进行排序
    private List<User> sortCurrentPage(List<User> userList, String sortField, String sortDirection) {
        Comparator<User> comparator = null;

        switch(sortField) {
            case "username":
                comparator = Comparator.comparing(User::getUsername);
                break;
            case "realName":
                comparator = Comparator.comparing(User::getRealName);
                break;
            case "phone":
                comparator = Comparator.comparing(User::getPhone);
                break;
            case "email":
                comparator = Comparator.comparing(User::getEmail);
                break;
            case "status":
                comparator = Comparator.comparing(User::getStatus);
                break;
            default:
                comparator = Comparator.comparing(User::getId);
        }

        if ("DESC".equalsIgnoreCase(sortDirection)) {
            comparator = comparator.reversed();
        }

        return userList.stream().sorted(comparator).collect(Collectors.toList());
    }
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
                    model.addAttribute("operationMessage", "用户添加成功！");
                    break;
                case "edit_success":
                    model.addAttribute("operationMessage", "用户修改成功！");
                    break;
                case "delete_success":
                    model.addAttribute("operationMessage", "用户删除成功！");
                    break;
                case "delete_fail":
                    model.addAttribute("operationMessage", "用户删除失败！");
                    break;
            }
        }

        // 确保页码不小于1
        if (pageNum < 1) {
            pageNum = 1;
        }

        // 创建查询条件
        User condition = new User();
        if (searchColumn != null && keyword != null && !keyword.isEmpty()) {
            if ("username".equals(searchColumn)) {
                condition.setUsername(keyword);
            } else if ("realName".equals(searchColumn)) {
                condition.setRealName(keyword);
            } else if ("phone".equals(searchColumn)) {
                condition.setPhone(keyword);
            }
        }

        // 获取总记录数用于分页
        int totalCount;
        if (condition.getUsername() != null || condition.getRealName() != null || condition.getPhone() != null) {
            totalCount = userService.countUsersByCondition(condition);
        } else {
            totalCount = userService.countAllUsers();
        }

        // 计算总页数
        int totalPages = (totalCount + PAGE_SIZE - 1) / PAGE_SIZE;

        // 确保页码不超过总页数
        if (totalPages > 0 && pageNum > totalPages) {
            pageNum = totalPages;
        }

        // 先获取固定顺序的数据ID（不包含排序条件）
        List<Integer> fixedOrderIds = userService.getFixedOrderUserIds(condition, "id DESC");

        // 然后根据固定顺序ID获取分页数据
        int startIndex = (pageNum - 1) * PAGE_SIZE;
        int endIndex = Math.min(startIndex + PAGE_SIZE, fixedOrderIds.size());
        List<Integer> pageIds = fixedOrderIds.subList(startIndex, endIndex);
        List<User> userList = userService.getUsersByIds(pageIds);

        // 如果有排序参数，对当前页数据进行排序
        if (sortField != null && !sortField.isEmpty() && sortDirection != null && !sortDirection.isEmpty()) {
            userList = userService.sortCurrentPage(userList, sortField, sortDirection);
        }

        // 设置分页相关属性
        model.addAttribute("list", userList);
        model.addAttribute("pageNum", pageNum);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalCount", totalCount);

        // 保留搜索条件和排序条件
        model.addAttribute("searchColumn", searchColumn);
        model.addAttribute("keyword", keyword);
        model.addAttribute("sortField", sortField);
        model.addAttribute("sortDirection", sortDirection);

        return "user_list";
    }
    @RequestMapping("/add")
    public String add(User user, HttpServletRequest request,
                      @RequestParam(value = "sortField", required = false) String sortField,
                      @RequestParam(value = "sortDirection", required = false) String sortDirection) {
        // 验证用户名
        if (user.getUsername() == null || user.getUsername().isEmpty()) {
            request.setAttribute("error", "用户名不能为空");
            return "user_add";
        }

        // 验证用户名是否存在
        if (userService.isUsernameExist(user.getUsername())) {
            request.setAttribute("error", "用户名已存在");
            return "user_add";
        }

        // 验证密码
        if (user.getPassword() == null || user.getPassword().isEmpty()) {
            request.setAttribute("error", "密码不能为空");
            return "user_add";
        }

        // 验证密码长度至少6位
        if (user.getPassword().length() < 6) {
            request.setAttribute("error", "密码长度至少6位");
            return "user_add";
        }

        // 验证真实姓名
        if (user.getRealName() == null || user.getRealName().isEmpty()) {
            request.setAttribute("error", "真实姓名不能为空");
            return "user_add";
        }

        // 验证手机号
        if (user.getPhone() == null || user.getPhone().isEmpty()) {
            request.setAttribute("error", "联系电话不能为空");
            return "user_add";
        } else if (!user.getPhone().matches("^1[3-9]\\d{9}$")) {
            request.setAttribute("error", "手机号格式不正确，请输入11位有效手机号");
            return "user_add";
        }

        // 验证邮箱
        if (user.getEmail() == null || user.getEmail().isEmpty()) {
            request.setAttribute("error", "电子邮箱不能为空");
            return "user_add";
        } else if (!user.getEmail().matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
            request.setAttribute("error", "邮箱格式不正确，请输入有效的邮箱地址");
            return "user_add";
        }

        // 验证状态
        if (user.getStatus() == null) {
            request.setAttribute("error", "状态不能为空");
            return "user_add";
        }

        user.setCreateBy("admin"); // 实际应该从session获取当前登录用户
        int result = userService.addUser(user);
        if (result > 0) {
            // 添加成功，设置成功消息并保留排序参数
            String redirectUrl = "redirect:/user/list?message=add_success";
            if (sortField != null && sortDirection != null) {
                redirectUrl += "&sortField=" + sortField + "&sortDirection=" + sortDirection;
            }
            return redirectUrl;
        } else {
            request.setAttribute("error", "添加用户失败");
            return "user_add";
        }
    }

    @RequestMapping("/edit")
    public String edit(User user, HttpServletRequest request,
                       @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                       @RequestParam(value = "sortField", required = false) String sortField,
                       @RequestParam(value = "sortDirection", required = false) String sortDirection) {
        // 验证用户名
        if (user.getUsername() == null || user.getUsername().isEmpty()) {
            request.setAttribute("error", "用户名不能为空");
            // 重新获取用户信息
            User originalUser = userService.getUserById(user.getId());
            request.setAttribute("vo", originalUser);
            return "user_edit";
        }

        // 获取原始用户数据
        User originalUser = userService.getUserById(user.getId());

        // 检查用户名是否已被修改，如果修改了，需要检查唯一性
        if (!user.getUsername().equals(originalUser.getUsername())) {
            if (userService.isUsernameExist(user.getUsername())) {
                request.setAttribute("error", "用户名已存在");
                request.setAttribute("vo", originalUser);
                return "user_edit";
            }
        }

        // 验证密码
        if (user.getPassword() == null || user.getPassword().isEmpty()) {
            request.setAttribute("error", "密码不能为空");
            request.setAttribute("vo", originalUser);
            return "user_edit";
        }

        // 验证密码长度至少6位
        if (user.getPassword().length() < 6) {
            request.setAttribute("error", "密码长度至少6位");
            request.setAttribute("vo", originalUser);
            return "user_edit";
        }

        // 验证手机号格式
        if (user.getPhone() != null && !user.getPhone().isEmpty() && !user.getPhone().matches("^1[3-9]\\d{9}$")) {
            request.setAttribute("error", "手机号格式不正确，请输入11位有效手机号");
            request.setAttribute("vo", originalUser);
            return "user_edit";
        }

        // 验证邮箱格式
        if (user.getEmail() != null && !user.getEmail().isEmpty() && !user.getEmail().matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
            request.setAttribute("error", "邮箱格式不正确，请输入有效的邮箱地址");
            request.setAttribute("vo", originalUser);
            return "user_edit";
        }

        // 检查是否有实际修改
        boolean hasChanged = !user.getUsername().equals(originalUser.getUsername()) ||
                !user.getPassword().equals(originalUser.getPassword()) ||
                !user.getRealName().equals(originalUser.getRealName()) ||
                !user.getPhone().equals(originalUser.getPhone()) ||
                !user.getEmail().equals(originalUser.getEmail()) ||
                !user.getStatus().equals(originalUser.getStatus());

        if (!hasChanged) {
            request.setAttribute("error", "未做任何修改，无需提交");
            request.setAttribute("vo", originalUser);
            return "user_edit";
        }

        int result = userService.updateUser(user);
        if (result > 0) {
            String redirectUrl = "redirect:/user/list?message=edit_success&pageNum=" + pageNum;
            if (sortField != null && sortDirection != null) {
                redirectUrl += "&sortField=" + sortField + "&sortDirection=" + sortDirection;
            }
            return redirectUrl;
        } else {
            request.setAttribute("error", "更新用户失败");
            request.setAttribute("vo", originalUser);
            return "user_edit";
        }
    }

    @RequestMapping("/delete")
    public String delete(@RequestParam("id") Integer id,
                         @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                         @RequestParam(value = "sortField", required = false) String sortField,
                         @RequestParam(value = "sortDirection", required = false) String sortDirection) {
        int result = userService.deleteUser(id);
        String redirectUrl = "redirect:/user/list?pageNum=" + pageNum;
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
        int result = userService.batchDelete(ids);
        String redirectUrl = "redirect:/user/list?pageNum=" + pageNum;
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
        User user = userService.getUserById(id);
        model.addAttribute("vo", user);
        return "user_info";
    }

    @RequestMapping("/toAdd")
    public String toAdd() {
        return "user_add";
    }

    @RequestMapping("/toEdit")
    public String toEdit(@RequestParam("id") Integer id,
                         @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                         Model model) {
        User user = userService.getUserById(id);
        model.addAttribute("vo", user);
        model.addAttribute("pageNum", pageNum);
        return "user_edit";
    }

    @ResponseBody
    @RequestMapping(value = "/checkUsername", method = RequestMethod.POST)
    public String checkUsername(@RequestParam("username") String username) {
        boolean exists = userService.isUsernameExist(username);
        return exists ? "false" : "true";
    }
}