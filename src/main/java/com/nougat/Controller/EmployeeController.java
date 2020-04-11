package com.nougat.Controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.nougat.bean.Employee;
import com.nougat.bean.Msg;
import com.nougat.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ExtendedModelMap;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class EmployeeController {
    @Autowired
    EmployeeService employeeService;
//    @RequestMapping("/emps")
//    public String getEmps(@RequestParam(value = "pn",defaultValue = "1")Integer pn, Model model){
//        PageHelper.startPage(pn,5);
//        List<Employee>emps =employeeService.getAll();
//        PageInfo pageInfo=new PageInfo(emps);
//        model.addAttribute("pageInfo",pageInfo);
//        return "list";
//    }

    /**
     * 导入json包
     *
     * @param pn
     * @param model
     * @return
     */
    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn", defaultValue = "1") Integer pn, Model model) {
        PageHelper.startPage(pn, 5);
        List<Employee> emps = employeeService.getAll();
        PageInfo pageInfo = new PageInfo(emps, 5);
        model.addAttribute("pageInfo", pageInfo);
        return Msg.success().add("pageInfo", pageInfo);
    }

    @RequestMapping(value = "/emp", method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult result) {
        if (result.hasErrors()) {
            //校验失败，应该返回失败，在模态框中显示校验失败的错误信息。
            Map<String, Object> map = new HashMap<>();
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError fieldError : errors) {
                map.put(fieldError.getField(), fieldError.getDefaultMessage());
            }
            return Msg.fail().add("errorFields", map);
        } else {
            employeeService.saveEmp(employee);
            return Msg.success();
        }
    }

    @RequestMapping(value = "/emp/{id}", method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id") Integer id) {
        Employee employee = employeeService.getEmp(id);
        return Msg.success().add("emp", employee);
    }

    /**
     * 检查用户名是否可用。
     *
     * @param empName
     * @return
     */
    @RequestMapping(value = "/checkUser")
    @ResponseBody
    public Msg checkUser(@RequestParam("empName") String empName) {
        //先判断用户名是否是合法的表达式
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if (!empName.matches(regx)) {
            return Msg.fail().add("va_msg", "用户名必须是6-16位数字和字母的组合或者2-5位的中文。");
        }
        ;
        boolean flag = employeeService.checkUser(empName);
        if (flag) {
            return Msg.success();
        } else {
            return Msg.fail().add("va_msg", "用户名不可用。");
        }
    }

    /**
     * 验证邮箱是否可用
     *
     * @param email
     * @return
     */
    @RequestMapping(value = "/checkEmail")
    @ResponseBody
    public Msg checkEmail(@RequestParam("email") String email) {
        String regx = "^([a-zA-Z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$";
        if (!email.matches(regx)) {
            return Msg.fail().add("va_email_msg", "邮箱格式不正确");
        }
        boolean flag = employeeService.checkEmail(email);
        if (flag) {
            return Msg.success();
        } else {
            return Msg.fail().add("va_email_msg", "邮箱不可用");
        }
    }

    @RequestMapping(value = "/checkUpdateEmail")
    @ResponseBody
    public Msg checkUpdateEmail(@RequestParam("email") String email) {
        String regx = "^([a-zA-Z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$";
        if (!email.matches(regx)) {
            return Msg.fail().add("va_update_email_msg", "邮箱格式不正确");
        }
        boolean flag = employeeService.checkEmail(email);
        if (flag) {
            return Msg.success();
        } else {
            return Msg.fail().add("va_update_email_msg", "邮箱不可用");
        }
    }

    /**
     * 如果直接发送ajax=PUT形式的请求
     * 问题：
     * 请求体中有数据
     * 但是Employee对象封装不上
     * <p>
     * 原因：
     * Tomcat：
     * 将请求体中的数据，封装一个map
     * request.getParameter("empNmae")就会从这个map中取值
     * SpringMVC封装POJO对象的时候
     * 会把POJO中每个属性的值，request。getParamter("email")
     * <p>
     * AJAX发送PUT请求引发的血案：
     * PUT请求，请求体中的数据，request。getParam()拿不到
     * Tomcat一看是PUT不会封装请求体中的数据为map，只有POST形式的请求才封装为map
     * 解决方案
     * 我们要能支持直接发送PUT之类的请求还要封装请求体中的数据.
     * 1.配置上HttpPutFormContextFilter
     * 2.它的作用:将请求体中的数据解析包装成一个map,
     * 3.request被重新包装,request.getParameter()被重写,就会从自己凤封装过的maa中取数据
     *
     * @param employee
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{empId}", method = RequestMethod.PUT)
    public Msg saveEmp(Employee employee) {
        System.out.println(employee);
        String email = employee.getEmail();
        boolean flag = employeeService.checkEmail(email);
        if (flag) {
            employeeService.updateEmp(employee);
            return Msg.success();
        } else {
            return Msg.fail().add("va_update_email_msg", "邮箱不可用");
        }

    }

    /**
     * 根据id删除用户信息
     *
     * @param ids
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{id}", method = RequestMethod.DELETE)
    public Msg deleteEmp(@PathVariable("id") String ids) {
        //批量删除
        if (ids.contains("-")) {
            String[] str_ids = ids.split("-");
            List<Integer> del_ids = new ArrayList<>();
            //组装id的集合
            for (String string : str_ids) {
                del_ids.add(Integer.parseInt(string));
            }
            employeeService.deleteBatch(del_ids);
        } else {//单个删除
            Integer id = Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }
        return Msg.success();
    }
}
