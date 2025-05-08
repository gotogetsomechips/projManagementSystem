package store.service;

import java.util.List;
import store.bean.Message;

public interface MessageService {
    int addMessage(Message message);
    int deleteMessage(Integer id);
    int batchDelete(List<Integer> ids);
    int updateMessage(Message message);
    Message getMessageById(Integer id);
    List<Message> getAllMessages();
    List<Message> getMessagesByCondition(Message condition);
    List<Message> getAllMessagesOrderBy(String orderBy);
    
    // 分页相关方法
    List<Message> getAllMessagesWithPagination(int startIndex, int pageSize);
    List<Message> getMessagesByConditionWithPagination(Message condition, int startIndex, int pageSize);
    List<Message> getAllMessagesOrderByWithPagination(String orderBy, int startIndex, int pageSize);
    List<Message> getMessagesByConditionOrderByWithPagination(Message condition, String orderBy, int startIndex, int pageSize);

    int countAllMessages();
    int countMessagesByCondition(Message condition);

    List<Message> getMessagesByIds(List<Integer> ids);
    List<Integer> getFixedOrderMessageIds(Message condition, String orderBy);
    
    List<Message> sortCurrentPage(List<Message> messageList, String sortField, String sortDirection);
    boolean isTitleExist(String title);
}