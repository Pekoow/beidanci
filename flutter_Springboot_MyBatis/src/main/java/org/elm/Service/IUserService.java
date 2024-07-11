package org.elm.Service;

import org.apache.ibatis.annotations.Param;
import org.elm.domin.User;

public interface IUserService {
    public User getUserByIdAndPassword(String userId,String password);
    public User getUserById(String userId);
    public int saveUser(User user);



    public int updateUser(User user);
}
