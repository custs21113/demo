package com.nougat.Controller;

import com.nougat.bean.Department;
import com.nougat.bean.Msg;
import com.nougat.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 处理部门有关的请求
 *
 * @author
 */
@Controller
public class DepartmentController {
    @Autowired
    private DepartmentService departmentService;

    @RequestMapping("/depts")
    @ResponseBody
    public Msg getDepts() {
        //查出的所有部门信息
        List<Department> list = (List<Department>) departmentService.getDepts();
        return Msg.success().add("depts", list);
    }

}
