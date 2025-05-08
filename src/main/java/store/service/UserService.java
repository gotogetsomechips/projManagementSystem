package store.service;

import java.util.List;
import store.bean.User;

public interface UserService {
    int addUser(User user);
    int deleteUser(Integer id);
    int batchDelete(List<Integer> ids);
    int updateUser(User user);
    User getUserById(Integer id);
    List<User> getAllUsers();
    List<User> getUsersByCondition(User condition);
    boolean isUsernameExist(String username);
    List<User> getAllUsersOrderBy(String orderBy);
    User login(String username, String password);
    void lockUser(String username);
    void unlockUser(String username);
    // 分页相关的方法
    List<User> getAllUsersWithPagination(int startIndex, int pageSize);
    List<User> getUsersByConditionWithPagination(User condition, int startIndex, int pageSize);
    List<User> getAllUsersOrderByWithPagination(String orderBy, int startIndex, int pageSize);
    List<User> getUsersByConditionOrderByWithPagination(User condition, String orderBy, int startIndex, int pageSize);
    // 新增方法：获取固定顺序的用户ID列表
    List<Integer> getFixedOrderUserIds(User condition, String orderBy);
    // 新增方法：根据ID列表获取用户
    List<User> getUsersByIds(List<Integer> ids);
    int countAllUsers();
    int countUsersByCondition(User condition);

    List<User> sortCurrentPage(List<User> userList, String sortField, String sortDirection);
}