<%--<jsp:forward page="/emps"></jsp:forward>--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" isELIgnored="false" %>
<%@page import="javax.servlet.*" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <title>Bootstrap 101 Template</title>
    <% pageContext.setAttribute("APP_PATH", request.getContextPath());%>


    <%--    <%= pageContext.setAttribute("APP_PATH",request.getContextPath())%>--%>
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- HTML5 shim 和 Respond.js 是为了让 IE8 支持 HTML5 元素和媒体查询（media queries）功能 -->
    <!-- 警告：通过 file:// 协议（就是直接将 html 页面拖拽到浏览器中）访问页面时 Respond.js 不起作用 -->
    <!--[if lt IE 9]>
    <script src="https://cdn.jsdelivr.net/npm/html5shiv@3.7.3/dist/html5shiv.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/respond.js@1.4.2/dest/respond.min.js"></script>
    <![endif]-->
</head>
<body>
<h1 class="center-block col-md-6">你好，世界！</h1>
<button class="btn btn-primary">按钮</button>
<!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
<script src="https://cdn.staticfile.org/jquery/1.10.2/jquery.min.js"></script>
<!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"></script>
<script type="text/javascript">
    var totalRecord, currentPage;
    //1、页面加载完成以后，直接去发送ajax请求，要到分页数据
    $(function () {
        to_page(1);
    });

    function to_page(pn) {
        $.ajax({
            url: "${APP_PATH}/emps",
            data: "pn=" + pn,
            type: "GET",
            success: function (result) {
                build_emps_table(result);
                build_page_info(result);
                build_page_nav(result);
            }
        });
    }

    function build_emps_table(result) {
        //清空table表格
        $("#emps_table tbody").empty();
        var emps = result.extend.pageInfo.list;
        $.each(emps, function (index, item) {
            var checkBox = $("<td><input type='checkbox' class='check_item' /></td>");
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var genderTd = $("<td></td>").append(item.gender == 'M' ? "男" : "女");
            var emailTd = $("<td></td>").append(item.email);
            var deptNameTd = $("<td></td>").append(item.department.deptName);
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn").append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
            //为编辑按钮添加一个自定以的属性，来表示当前员工id
            editBtn.attr("edit-id", item.empId);
            var deleteBtn = $("<button></button>").addClass("btn btn-primary btn-sm delete_btn").append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
            deleteBtn.attr("delete-id", item.empId);
            //append方法发执行完成以后还是返回原来的元素。
            $("<tr></tr>").append(checkBox)
                .append(empIdTd)
                .append(empNameTd)
                .append(genderTd)
                .append(emailTd)
                .append(deptNameTd)
                .append(editBtn)
                .append(deleteBtn)
                .appendTo("#emps_table tbody");
        })
    };

    function build_page_info(result) {
        $("#page_info_area").empty();

        $("#page_info_area").append("当前" + result.extend.pageInfo.pageNum + "页，总" +
            result.extend.pageInfo.pages + "页,总共" +
            result.extend.pageInfo.total + "条记录");
        totalRecord = result.extend.pageInfo.pages + 1;
        currentPage = result.extend.pageInfo.pageNum;
    };

    function build_page_nav(result) {
        $("#page_nav_area").empty();

        var ul = $("<ul></ul>").addClass("pagination");
        //构建元素
        var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
        var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
        if (result.extend.pageInfo.hasPreviousPage == false) {
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        } else {
            firstPageLi.click(function () {
                to_page(1);
            });
            prePageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum - 1);
            });
        }
        ;
        //为元素添加点击翻页的事件

        var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href", "#"));
        if (result.extend.pageInfo.hasNextPage == false) {
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        } else {
            nextPageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum + 1);
            });
            lastPageLi.click(function () {
                to_page(result.extend.pageInfo.pages);
            });
        }
        ;

        //构造添加首页和前一页的提示
        ul.append(firstPageLi).append(prePageLi);
        //1，2，3遍历ul中添加页码提示
        $.each(result.extend.pageInfo.navigatepageNums, function (index, item) {
            var numLi = $("<li></li>").append($("<a></a>").append(item));
            if (result.extend.pageInfo.pageNum == item) {
                numLi.addClass("active");
            }
            ;
            numLi.click(function () {
                to_page(item);
            });

            ul.append(numLi);
        });

        //添加下一页和末页的提示
        ul.append(nextPageLi).append(lastPageLi);

        var navEle = $("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    }

</script>
</body>

<!-- Modal -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input"
                                   placeholder="empName">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input"
                                   placeholder="email@nougat.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked">男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F">女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">dept</label>
                        <div class="col-sm-4">
                            <%--                            部门提交部门id即可--%>
                            <select class="form-control" name="dId" id="dept_add_select">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>
</div><!-- /.modal -->

<!-- Modal -->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_update_static"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_update_input"
                                   placeholder="email@nougat.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked">男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update_input" value="F">女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">dept</label>
                        <div class="col-sm-4">
                            <%--                            部门提交部门id即可--%>
                            <select class="form-control" name="dId" id="dept_update_select">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
            </div>
        </div>
    </div>
</div>
</div><!-- /.modal -->

<div class="container">
    <%--        标题--%>
    <div class="row">
        <div class="col-md-12"><h1>ssm-crud</h1></div>
    </div>
    <%--    按钮--%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
        </div>
    </div>
    <%--        显示表格数据--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-striped table-hover" id="emps_table">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox" id="check_all">
                    </th>
                    <th>#</th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>deptName</th>
                    <th>操作</th>
                </tr>
                </thead>


                <tbody>

                </tbody>
            </table>
        </div>
    </div>
    <%--     显示分页信息--%>
    <div class="row">
        <%--            分页文字信息--%>
        <div class="col-md-6" id="page_info_area">
        </div>
        <%--    分页条信息--%>
        <div class="col-md-6" id="page_nav_area">

        </div>
    </div>


</div>
<script>
    //检验结果
    function show_validate_msg(ele, status, msg) {
        $(ele).parent().removeClass("has-success has-error");
        $(ele).next("span").text("");
        if ("success" == status) {
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);
        } else if ("error" == status) {
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
        ;
    };

    //清空表单样式及内容
    function reset_form(ele) {
        $(ele)[0].reset();
        //清空表单样式
        $(ele).find("*").removeClass("has-error has-success");
        $(ele).find(".help-block").text("");
    };
    //点击新增按钮弹出模态框。
    $("#emp_add_modal_btn").click(function () {
        //清除表单数据（表单重置）
        reset_form("#empAddModal form");
        // $("#empAddModal form")[0].reset();
        //弹出模态框，查出部门信息，显示在下拉列表中。
        getDept("#empAddModal select");
        $("#empAddModal").modal({
            backdrop: "static"
        });
    });
    //发送ajax请求校验用户名是否可用。
    $("#empName_add_input").change(function () {
        var empName = this.value;
        $.ajax({
            url: "${APP_PATH}/checkUser",
            data: "empName=" + empName,
            type: "POST",
            success: function (result) {
                if (result.code == 100) {
                    show_validate_msg("#empName_add_input", "success", "用户名可用");
                    $("#emp_save_btn").attr("ajax-va", "success");

                } else {
                    show_validate_msg("#empName_add_input", "error", result.extend.va_msg);
                    $("#emp_save_btn").attr("ajax-va", "error");
                }
            }
        });
    });

    //显示更新列表中的校验信息.
    function show_update_validate_msg(status, msg) {
        $("#email_update_input").parent().removeClass("has-success has-error");
        $("#email_update_input").next("span").text("");
        if ("success" == status) {
            $("#email_update_input").parent().addClass("has-success")
            $("#email_update_input").next("span").text(msg);
            $("#emp_update_btn").attr("ajax-va", "success");
        } else if ("error" == status) {
            $("#email_update_input").parent().addClass("has-error")
            $("#email_update_input").next("span").text(msg);
            $("#emp_update_btn").attr("ajax-va", "error");
        }
        ;
    }

    //发送ajax请求校验用户更新中的邮箱是否可用。
    $("#email_update_input").change(function () {
        var email = $("#email_update_input").val()
        var regEmail = /^([a-zA-Z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if (!regEmail.test(email)) {
            show_validate_msg("#email_update_input", "error", "邮箱格式不正确。");
            $("#emp_update_btn").attr("ajax-va", "error");
            return false;
        } else {
            $.ajax({
                url: "${APP_PATH}/checkUpdateEmail",
                data: "email=" + email,
                type: "POST",
                success: function (result) {
                    if (result.code == 100) {
                        show_update_validate_msg("success", "该邮箱可用");
                        return true;
                    } else {
                        show_update_validate_msg("error", result.extend.va_update_email_msg);
                        return false;
                    }
                }
            });
        }
    });
    //发送ajax请求校验新增员工信息中的邮箱是否可用。
    $("#email_add_input").change(function () {
        var email = $("#email_update_input").val();
        $.ajax({
            url: "${APP_PATH}/checkEmail",
            data: "email=" + email,
            type: "POST",
            success: function (result) {
                if (result.code == 100) {
                    show_validate_msg("#email_add_input", "success", "邮箱可用");
                    $("#emp_save_btn").attr("ajax-va", "success");

                } else {
                    show_validate_msg("#email_add_input", "error", result.extend.va_email_msg);
                    $("#emp_save_btn").attr("ajax-va", "error");
                }
            }
        });
    });

    //获取部门信息
    function getDept(ele) {
        $(ele).empty();
        $.ajax({
            url: "${APP_PATH}/depts",
            type: "GET",
            success: function (result) {
                // console.log(result)
                $.each(result.extend.depts, function () {
                    var optionEle = $("<option></option>").append(this.deptName).attr("value", this.deptId);
                    optionEle.appendTo(ele);
                })
            }
        });
    };

    //校验表单数据
    function validate_add_form() {
        //1.拿到要校验的数据，使用正则表达式。
        var empName = $("#empName_add_input").val();
        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
        if (!regName.test(empName)) {
            // alert("用户名可以是2-5位中文或者6-16位和数字的组合。")
            show_validate_msg("#empName_add_input", "error", "用户名可以是2-5位中文或者6-16位和数字的组合。");
            return false;
        } else {
            show_validate_msg("#empName_add_input", "success", "");
        }
        ;
        //2.校验邮箱信息
        var email = $("#email_add_input").val();
        var regEmail = /^([a-zA-Z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if (!regEmail.test(email)) {
            // alert("用户名可以是2-5位中文或者6-16位和数字的组合。")
            //清空这个元素之前的样式
            show_validate_msg("#email_add_input", "error", "邮箱格式不正确。");
            return false;
        } else {
            show_validate_msg("#email_add_input", "success", "");
        }
        ;
        return true;
    };

    //点击保存，保存新增员工信息
    $("#emp_save_btn").click(function () {
        //1.模态框中填写的表单数据提交给服务器进行保存
        //2.对要提交给服务器的数据进行校验。
        if (!validate_add_form()) {
            return false;
        }

        //2.判断之前的饿ajax用户名校验是否成功，如果成功。
        if ($(this).attr("ajax-va") == "error") {
            return false;
        }
        //3.发送ajax请求保存员工
        $.ajax({
            url: "${APP_PATH}/emp",
            type: "POST",
            data: $("#empAddModal form").serialize(),
            success: function (result) {
                if (result.code == 100) {
                    //1.关闭模态框
                    $("#empAddModal").modal("hide");
                    //来到最后一页，显示刚才保存的数据
                    //发送ajax请求显示最后一页数据即可。
                    to_page(totalRecord);
                } else {
                    //显示失败信息。
                    //有哪个字段的错误信息就希纳是哪个字段的。
                    if (undefined != result.extend.errorFields.email) {
                        //显示邮箱错误详细
                        show_validate_msg("#email_add_input", "error", result.extend.errorFields.email);
                    }
                    ;
                    if (undefined != result.extend.errorFields.empName) {
                        show_validate_msg("#empName_add_input", "error", result.extend.errorFields.empName);
                    }
                    ;
                }
                ;
            }
        });
    });

    //编辑事件
    $(document).on("click", ".edit_btn", function () {
        //1.查出部门信息，并显示部门列表
        getDept("#empUpdateModal select");
        //2.查出员工信息，显示员工信息。
        getEmp($(this).attr("edit-id"));
        //3.把员工的id传递给模态框的更新按钮
        $("#emp_update_btn").attr("update-id", $(this).attr("edit-id"));
        $("#empUpdateModal form").find(".help-block").text("");
        $("#empUpdateModal").modal({
            backdrop: "static"
        });
    });

    //新增按钮获取员工信息
    function getEmp(id) {
        $.ajax({
            url: "${APP_PATH}/emp/" + id,
            type: "GET",
            success: function (result) {
                var empData = result.extend.emp;
                $("#empName_update_static").text(empData.empName);
                $("#email_update_input").val(empData.email);
                $("#empUpdateModal input[name=gender]").val([empData.gender]);
                $("#empUpdateModal select").val([empData.dId]);
            }
        });
    }

    //点击更新，更新员工信息
    $("#emp_update_btn").click(function () {
        if ($(this).attr("ajax-va") == "error") {
            return false;
        } else {
            $.ajax({
                url: "${APP_PATH}/emp/" + $(this).attr("update-id"),
                // type:"POST",
                // data:$("#empUpdateModal form").serialize()+"&_method=PUT",
                type: "PUT",
                data: $("#empUpdateModal form").serialize(),
                success: function (result) {
                    // alert(result.msg);
                    //1.关闭模态框
                    $("#empUpdateModal").modal("hide");
                    //2.回到本页面
                    to_page(currentPage);
                }
            });
        }
    });
    //全选/全不选功能
    $("#check_all").click(function () {
        $(".check_item").prop("checked", $(this).prop("checked"));
    });
    //check_item
    $(document).on("click", ".check_item", function () {
        var flag = $(".check_item:checked").length == $(".check_item").length;
        $("#check_all").prop("checked", flag);
    });

    //单个删除事件
    $(document).on("click", ".delete_btn", function () {
        //1.弹出删除对话框
        var empName = $(this).parents("tr").find("td:eq(2)").text();
        var empId = $(this).attr("delete-id");
        if (empName != "" && confirm("确认删除[" + empName + "]?")) {
            //确认,发送ajax请求删除即可
            $.ajax({
                url: "${APP_PATH}/emp/" + empId,
                type: "DELETE",
                success: function (result) {
                    alert(result.msg);
                    to_page(currentPage);
                }
            });
        }
    });

    //点击全部删除
    $("#emp_delete_all_btn").click(function () {
        var empNames = "";
        var del_idstr = "";
        $.each($(".check_item:checked"), function () {
            empNames += $(this).parents("tr").find("td:eq(2)").text() + ",";
            //组装员工id字符串
            del_idstr += $(this).parents("tr").find("td:eq(1)").text() + "-";
        });
        //去除empNames,del_idstr多余的逗号
        empNames = empNames.substring(0, empNames.length - 1);
        del_idstr = del_idstr.substring(0, del_idstr.length - 1);
        if (empNames != "" && confirm("确认删除[" + empNames + "]?")) {
            //发送ajax删除
            $.ajax({
                url: "${APP_PATH}/emp/" + del_idstr,
                type: "DELETE",
                success: function (result) {
                    alert(result.msg);
                    to_page(currentPage);
                }
            });
        }
        alert("here");
        $("#check_all").attr("checked", false);
    });
</script>
</html>