package org.elm.Service;

import jakarta.annotation.Resource;
import org.elm.Service.IUserService;
import org.elm.Mapper.UserMapper;
import org.elm.domin.User;
import org.springframework.stereotype.Service;

@Service
public class UserService implements IUserService {

    @Resource
    private UserMapper userMapper;

    @Override
    public User getUserByIdAndPassword(String userId, String password) {
        return userMapper.getUserByIdAndPassword(userId, password);
    }

    @Override
    public User getUserById(String userId) {
        return userMapper.selectById(userId);
    }

    @Override
    public int saveUser(User user) {
        return userMapper.insert(user);
    }




    @Override
    public int updateUser(User user) {
        return userMapper.updateById(user);
    }
}
