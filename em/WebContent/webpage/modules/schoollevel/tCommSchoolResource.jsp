<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>角色管理</title>
	<meta name="decorator" content="default"/>
	<%@include file="/webpage/include/treeview.jsp" %>
	<script type="text/javascript">

	  	var validateForm;
		function doSubmit(){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		  if(validateForm.form()){
			  $("#inputForm").submit();
			  return true;
		  }

		  return false;
		}
			
		$(document).ready(function(){
			$("#name").focus();
			validateForm = $("#inputForm").validate({
			
				submitHandler: function(form){
					var ids = [], nodes = tree.getCheckedNodes(true);
					for(var i=0; i<nodes.length; i++) {
						ids.push(nodes[i].id);
					}
					$("#menuIds").val(ids);
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});

			var setting = {check:{enable:true,nocheckInherit:true},view:{selectedMulti:false},
					data:{simpleData:{enable:true}},callback:{beforeClick:function(id, node){
						tree.checkNode(node, !node.checked, true, true);
						return false;
					}}};
			
			// 用户-菜单
			var zNodes=[
					<c:forEach items="${menuList}" var="menu">{id:"${menu.id}", pId:"${not empty menu.parent.id?menu.parent.id:0}", name:"${not empty menu.parent.id?menu.name:'权限列表'}"},
		            </c:forEach>];
			// 初始化树结构
			var tree = $.fn.zTree.init($("#menuTree"), setting, zNodes);
			// 不选择父节点
			tree.setting.check.chkboxType = { "Y" : "ps", "N" : "s" };
			// 默认选择节点
			var ids = "${tCommSchoolLevel.menuIds}".split(",");
			for(var i=0; i<ids.length; i++) {
				var node = tree.getNodeByParam("id", ids[i]);
				try{tree.checkNode(node, true, false);}catch(e){}
			}
			var nodes = tree.getNodes();
			// 默认展开全部节点
			//tree.expandAll(true);
			for (var i = 0; i < nodes.length; i++) { //设置节点展开
				tree.expandNode(nodes[i], true, false, true);
            }
		
		});
		
	</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="tCommSchoolLevel" action="${ctx}/schoollevel/tCommSchoolLevel/saveResource" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<input  name="levelCode" type="hidden" value="${tCommSchoolLevel.levelCode}">
		<input  name="levelDesc" type="hidden" value="${tCommSchoolLevel.levelDesc}">
		<input  name="levelPrice" type="hidden" value="${tCommSchoolLevel.levelPrice}">
		<input  name="remarks" type="hidden" value="${tCommSchoolLevel.remarks}">
		<div id="menuTree" class="ztree" style="margin-top:3px;float:left;"></div>
			<form:hidden path="menuIds"/>
	</form:form>
</body>
</html>