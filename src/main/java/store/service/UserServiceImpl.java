package store.service;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import store.bean.User;
import store.mapper.UserMapper;
import store.service.UserService;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public int addUser(User user) {
        return userMapper.insert(user);
    }
    @Override
    public User login(String username, String password) {
        User user = userMapper.selectByUsername(username);
        if (user != null && user.getPassword().equals(password)) {
            if ("locked".equals(user.getStatus())) {
                return null; // 账户被锁定
            }
            return user;
        }
        return null;
    }

    @Override
    public void lockUser(String username) {
        userMapper.updateStatusByUsername(username, "locked");
    }

    @Override
    public void unlockUser(String username) {
        userMapper.updateStatusByUsername(username, "active");
    }
    @Override
    public int deleteUser(Integer id) {
        return userMapper.deleteById(id);
    }

    @Override
    public int batchDelete(List<Integer> ids) {
        return userMapper.batchDelete(ids);
    }

    @Override
    public int updateUser(User user) {
        return userMapper.update(user);
    }

    @Override
    public User getUserById(Integer id) {
        return userMapper.selectById(id);
    }

    @Override
    public List<User> getAllUsers() {
        return userMapper.selectAll();
    }

    @Override
    public List<User> getUsersByCondition(User condition) {
        return userMapper.selectByCondition(condition);
    }

    @Override
    public boolean isUsernameExist(String username) {
        return userMapper.countByUsername(username) > 0;
    }

    @Override
    public List<User> getAllUsersOrderBy(String orderBy) {
        return userMapper.selectAllOrderBy(orderBy);
    }

    @Override
    public List<User> getAllUsersWithPagination(int startIndex, int pageSize) {
        return userMapper.selectAllWithPagination(startIndex, pageSize);
    }

    @Override
    public List<User> getUsersByConditionWithPagination(User condition, int startIndex, int pageSize) {
        return userMapper.selectByConditionWithPagination(condition, startIndex, pageSize);
    }

    @Override
    public List<User> getAllUsersOrderByWithPagination(String orderBy, int startIndex, int pageSize) {
        return userMapper.selectAllOrderByWithPagination(orderBy, startIndex, pageSize);
    }

    @Override
    public List<User> getUsersByConditionOrderByWithPagination(User condition, String orderBy, int startIndex, int pageSize) {
        return userMapper.selectByConditionOrderByWithPagination(condition, orderBy, startIndex, pageSize);
    }

    @Override
    public int countAllUsers() {
        return userMapper.countAll();
    }

    @Override
    public int countUsersByCondition(User condition) {
        return userMapper.countByCondition(condition);
    }
    @Override
    public List<Integer> getFixedOrderUserIds(User condition, String orderBy) {
        // 这里保持固定排序方式，不受前端排序参数影响
        return userMapper.getFixedOrderUserIds(condition, "id DESC");
    }

    @Override
    public List<User> getUsersByIds(List<Integer> ids) {
        if (ids == null || ids.isEmpty()) {
            return Collections.emptyList();
        }
        return userMapper.getUsersByIds(ids);
    }

    // 辅助方法：对当前页数据进行排序
    public List<User> sortCurrentPage(List<User> userList, String sortField, String sortDirection) {
        Comparator<User> comparator = getComparator(sortField);

        if ("DESC".equalsIgnoreCase(sortDirection)) {
            comparator = comparator.reversed();
        }

        return userList.stream()
                .sorted(comparator)
                .collect(Collectors.toList());
    }

    private Comparator<User> getComparator(String sortField) {
        switch(sortField) {
            case "username":
                return Comparator.comparing(User::getUsername);
            case "realName":
                return Comparator.comparing(User::getRealName);
            case "phone":
                return Comparator.comparing(User::getPhone);
            case "email":
                return Comparator.comparing(User::getEmail);
            case "status":
                return Comparator.comparing(User::getStatus);
            default:
                return Comparator.comparing(User::getId);
        }
    }

}