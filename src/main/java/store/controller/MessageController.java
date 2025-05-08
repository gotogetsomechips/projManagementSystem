package store.controller;

import java.util.*;
import java.util.stream.Collectors;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import store.bean.Message;
import store.service.MessageService;

@Controller
@RequestMapping("/message")
public class MessageController {

    @Autowired
    private MessageService messageService;

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
                    model.addAttribute("operationMessage", "消息添加成功！");
                    break;
                case "edit_success":
                    model.addAttribute("operationMessage", "消息修改成功！");
                    break;
                case "delete_success":
                    model.addAttribute("operationMessage", "消息删除成功！");
                    break;
                case "delete_fail":
                    model.addAttribute("operationMessage", "消息删除失败！");
                    break;
            }
        }

        // 确保页码不小于1
        if (pageNum < 1) {
            pageNum = 1;
        }

        // 创建查询条件
        Message condition = new Message();
        if (searchColumn != null && keyword != null && !keyword.isEmpty()) {
            if ("title".equals(searchColumn)) {
                condition.setTitle(keyword);
            } else if ("sender".equals(searchColumn)) {
                condition.setSender(keyword);
            } else if ("receiver".equals(searchColumn)) {
                condition.setReceiver(keyword);
            }
        }

        // 获取总记录数用于分页
        int totalCount;
        if (condition.getTitle() != null || condition.getSender() != null || condition.getReceiver() != null) {
            totalCount = messageService.countMessagesByCondition(condition);
        } else {
            totalCount = messageService.countAllMessages();
        }

        // 计算总页数
        int totalPages = (totalCount + PAGE_SIZE - 1) / PAGE_SIZE;

        // 确保页码不超过总页数
        if (totalPages > 0 && pageNum > totalPages) {
            pageNum = totalPages;
        }

        // 先获取固定顺序的数据ID（不包含排序条件）
        List<Integer> fixedOrderIds = messageService.getFixedOrderMessageIds(condition, "id DESC");

        // 然后根据固定顺序ID获取分页数据
        int startIndex = (pageNum - 1) * PAGE_SIZE;
        int endIndex = Math.min(startIndex + PAGE_SIZE, fixedOrderIds.size());
        List<Integer> pageIds = fixedOrderIds.subList(startIndex, endIndex);
        List<Message> messageList = messageService.getMessagesByIds(pageIds);

        // 如果有排序参数，对当前页数据进行排序
        if (sortField != null && !sortField.isEmpty() && sortDirection != null && !sortDirection.isEmpty()) {
            messageList = messageService.sortCurrentPage(messageList, sortField, sortDirection);
        }

        // 设置分页相关属性
        model.addAttribute("list", messageList);
        model.addAttribute("pageNum", pageNum);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalCount", totalCount);

        // 保留搜索条件和排序条件
        model.addAttribute("searchColumn", searchColumn);
        model.addAttribute("keyword", keyword);
        model.addAttribute("sortField", sortField);
        model.addAttribute("sortDirection", sortDirection);

        return "message_list";
    }

    @RequestMapping("/add")
    public String add(Message message, HttpServletRequest request,
                      @RequestParam(value = "sortField", required = false) String sortField,
                      @RequestParam(value = "sortDirection", required = false) String sortDirection) {
        // 验证标题
        // 验证标题
        if (message.getTitle() == null || message.getTitle().isEmpty()) {
            request.setAttribute("error", "标题不能为空");
            return "message_add";
        }

        // 检查标题是否已存在
        if (messageService.isTitleExist(message.getTitle())) {
            request.setAttribute("error", "标题已存在");
            return "message_add";
        }
        // 验证发送人
        if (message.getSender() == null || message.getSender().isEmpty()) {
            request.setAttribute("error", "发送人不能为空");
            return "message_add";
        }

        // 验证接收人
        if (message.getReceiver() == null || message.getReceiver().isEmpty()) {
            request.setAttribute("error", "接收人不能为空");
            return "message_add";
        }

        // 验证内容
        if (message.getContent() == null || message.getContent().isEmpty()) {
            request.setAttribute("error", "消息内容不能为空");
            return "message_add";
        }

        // 设置发送时间为当前时间
        message.setSendTime(new Date());
        message.setCreateBy("admin"); // 实际应该从session获取当前登录用户
        int result = messageService.addMessage(message);
        if (result > 0) {
            // 添加成功，设置成功消息并保留排序参数
            String redirectUrl = "redirect:/message/list?message=add_success";
            if (sortField != null && sortDirection != null) {
                redirectUrl += "&sortField=" + sortField + "&sortDirection=" + sortDirection;
            }
            return redirectUrl;
        } else {
            request.setAttribute("error", "添加消息失败");
            return "message_add";
        }
    }

    @RequestMapping("/edit")
    public String edit(Message message, HttpServletRequest request,
                      @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                      @RequestParam(value = "sortField", required = false) String sortField,
                      @RequestParam(value = "sortDirection", required = false) String sortDirection) {
        // 验证标题
        // 验证标题
        if (message.getTitle() == null || message.getTitle().isEmpty()) {
            request.setAttribute("error", "标题不能为空");
            Message originalMessage = messageService.getMessageById(message.getId());
            request.setAttribute("vo", originalMessage);
            return "message_edit";
        }

        // 获取原始消息数据
        Message originalMessage = messageService.getMessageById(message.getId());

        // 如果标题有修改，检查新标题是否已存在
        if (!message.getTitle().equals(originalMessage.getTitle()) &&
                messageService.isTitleExist(message.getTitle())) {
            request.setAttribute("error", "标题已存在");
            request.setAttribute("vo", originalMessage);
            return "message_edit";
        }
        // 验证发送人
        if (message.getSender() == null || message.getSender().isEmpty()) {
            request.setAttribute("error", "发送人不能为空");
            request.setAttribute("vo", originalMessage);
            return "message_edit";
        }

        // 验证接收人
        if (message.getReceiver() == null || message.getReceiver().isEmpty()) {
            request.setAttribute("error", "接收人不能为空");
            request.setAttribute("vo", originalMessage);
            return "message_edit";
        }

        // 验证内容
        if (message.getContent() == null || message.getContent().isEmpty()) {
            request.setAttribute("error", "消息内容不能为空");
            request.setAttribute("vo", originalMessage);
            return "message_edit";
        }


        // 检查是否有实际修改
        boolean hasChanged = !message.getTitle().equals(originalMessage.getTitle()) ||
                !message.getSender().equals(originalMessage.getSender()) ||
                !message.getReceiver().equals(originalMessage.getReceiver()) ||
                !message.getContent().equals(originalMessage.getContent());

        if (!hasChanged) {
            request.setAttribute("error", "未做任何修改，无需提交");
            request.setAttribute("vo", originalMessage);
            return "message_edit";
        }

        int result = messageService.updateMessage(message);
        if (result > 0) {
            String redirectUrl = "redirect:/message/list?message=edit_success&pageNum=" + pageNum;
            if (sortField != null && sortDirection != null) {
                redirectUrl += "&sortField=" + sortField + "&sortDirection=" + sortDirection;
            }
            return redirectUrl;
        } else {
            request.setAttribute("error", "更新消息失败");
            request.setAttribute("vo", originalMessage);
            return "message_edit";
        }
    }

    @RequestMapping("/delete")
    public String delete(@RequestParam("id") Integer id,
                        @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                        @RequestParam(value = "sortField", required = false) String sortField,
                        @RequestParam(value = "sortDirection", required = false) String sortDirection) {
        int result = messageService.deleteMessage(id);
        String redirectUrl = "redirect:/message/list?pageNum=" + pageNum;
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
    @RequestMapping(value = "/checkTitle", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Boolean> checkTitle(@RequestParam("title") String title) {
        boolean exists = messageService.isTitleExist(title);
        return Collections.singletonMap("exists", exists);
    }
    @RequestMapping("/batchDelete")
    public String batchDelete(@RequestParam("ids") List<Integer> ids,
                             @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                             @RequestParam(value = "sortField", required = false) String sortField,
                             @RequestParam(value = "sortDirection", required = false) String sortDirection) {
        int result = messageService.batchDelete(ids);
        String redirectUrl = "redirect:/message/list?pageNum=" + pageNum;
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
        Message message = messageService.getMessageById(id);
        model.addAttribute("vo", message);
        return "message_info";
    }

    @RequestMapping("/toAdd")
    public String toAdd() {
        return "message_add";
    }

    @RequestMapping("/toEdit")
    public String toEdit(@RequestParam("id") Integer id,
                        @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                        Model model) {
        Message message = messageService.getMessageById(id);
        model.addAttribute("vo", message);
        model.addAttribute("pageNum", pageNum);
        return "message_edit";
    }
}