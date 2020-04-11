package com.nougat.test;

import com.nougat.bean.Department;
import com.nougat.bean.Employee;
import com.nougat.dao.DepartmentMapper;
import com.nougat.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

/**
 * 测试dao层的工作
 * 1、导入SpringTest模块
 * 2、@ContextConfiguration指定Spring配置文件的位置
 * 3、直接autowire要使用的组件即可
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {
    /**
     * 测试Department
     */
    @Autowired
    DepartmentMapper departmentMapper;
    @Autowired
    EmployeeMapper employeeMapper;
    @Autowired
    SqlSession sqlSession;

    @Test
    public void testCRUD() {
        //1、创建SpringIOC容器
//        ApplicationContext ioc=new ClassPathXmlApplicationContext("classpath:applicationContext.xml");
        //2、从容器中获取mapper

//        DepartmentMapper bean=ioc.getBean(DepartmentMapper.class);
        System.out.println(departmentMapper);

        //1、插入几个部门

//        departmentMapper.insertSelective(new Department(null,"d"));
//        departmentMapper.insertSelective(new Department(null,"c"));


        //2.生成员工数据，测试员工插入。
//        employeeMapper.insertSelective(new Employee(null,"Jerry","M","jerry@com.atguigu.com",1));
        //3.批量插入多个员工，使用可以执行批量操作的sqlSession
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        for (int i = 0; i < 1000; i++) {
            String uid = UUID.randomUUID().toString().substring(0, 5) + i;
            mapper.insertSelective(new Employee(null, uid, "M", "@com.atguigu.com", 1));
        }
        System.out.println("批量完成");
    }
}
