package store.service;

import java.text.Collator;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import store.bean.Message;
import store.mapper.MessageMapper;

@Service
public class MessageServiceImpl implements MessageService {

    @Autowired
    private MessageMapper messageMapper;

    // 添加中文排序的Collator
    private final Collator chineseCollator = Collator.getInstance(Locale.CHINA);

    @Override
    public int addMessage(Message message) {
        return messageMapper.insert(message);
    }

    @Override
    public int deleteMessage(Integer id) {
        return messageMapper.deleteById(id);
    }

    @Override
    public int batchDelete(List<Integer> ids) {
        return messageMapper.batchDelete(ids);
    }

    @Override
    public int updateMessage(Message message) {
        return messageMapper.update(message);
    }

    @Override
    public Message getMessageById(Integer id) {
        return messageMapper.selectById(id);
    }

    @Override
    public List<Message> getAllMessages() {
        return messageMapper.selectAll();
    }

    @Override
    public List<Message> getMessagesByCondition(Message condition) {
        return messageMapper.selectByCondition(condition);
    }

    @Override
    public List<Message> getAllMessagesOrderBy(String orderBy) {
        return messageMapper.selectAllOrderBy(orderBy);
    }

    @Override
    public List<Message> getAllMessagesWithPagination(int startIndex, int pageSize) {
        return messageMapper.selectAllWithPagination(startIndex, pageSize);
    }
    @Override
    public boolean isTitleExist(String title) {
        return messageMapper.countByTitle(title) > 0;
    }
    @Override
    public List<Message> getMessagesByConditionWithPagination(Message condition, int startIndex, int pageSize) {
        return messageMapper.selectByConditionWithPagination(condition, startIndex, pageSize);
    }

    @Override
    public List<Message> getAllMessagesOrderByWithPagination(String orderBy, int startIndex, int pageSize) {
        return messageMapper.selectAllOrderByWithPagination(orderBy, startIndex, pageSize);
    }

    @Override
    public List<Message> getMessagesByConditionOrderByWithPagination(Message condition, String orderBy, int startIndex, int pageSize) {
        return messageMapper.selectByConditionOrderByWithPagination(condition, orderBy, startIndex, pageSize);
    }

    @Override
    public int countAllMessages() {
        return messageMapper.countAll();
    }

    @Override
    public int countMessagesByCondition(Message condition) {
        return messageMapper.countByCondition(condition);
    }

    @Override
    public List<Integer> getFixedOrderMessageIds(Message condition, String orderBy) {
        return messageMapper.getFixedOrderMessageIds(condition, "id DESC");
    }

    @Override
    public List<Message> getMessagesByIds(List<Integer> ids) {
        if (ids == null || ids.isEmpty()) {
            return Collections.emptyList();
        }
        return messageMapper.getMessagesByIds(ids);
    }

    @Override
    public List<Message> sortCurrentPage(List<Message> messageList, String sortField, String sortDirection) {
        Comparator<Message> comparator = getComparator(sortField);

        if ("DESC".equalsIgnoreCase(sortDirection)) {
            comparator = comparator.reversed();
        }

        return messageList.stream()
                .sorted(comparator)
                .collect(Collectors.toList());
    }

    private Comparator<Message> getComparator(String sortField) {
        switch(sortField) {
            case "title":
                // 使用中文Collator进行字符串比较
                return (m1, m2) -> chineseCollator.compare(m1.getTitle(), m2.getTitle());
            case "sender":
                // 使用中文Collator进行字符串比较
                return (m1, m2) -> chineseCollator.compare(m1.getSender(), m2.getSender());
            case "receiver":
                // 使用中文Collator进行字符串比较
                return (m1, m2) -> chineseCollator.compare(m1.getReceiver(), m2.getReceiver());
            case "sendTime":
                return Comparator.comparing(Message::getSendTime);
            default:
                return Comparator.comparing(Message::getId);
        }
    }
}