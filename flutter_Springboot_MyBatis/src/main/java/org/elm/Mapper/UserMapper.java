package org.elm.Mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.elm.domin.User;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface UserMapper extends BaseMapper<User> {
    @Select("select * from user where userId=#{userId} and password=#{password}")
    public User getUserByIdAndPassword(@Param("userId")String userId, @Param("password")String password);




}
