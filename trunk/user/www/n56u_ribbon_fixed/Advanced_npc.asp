<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - nps</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/engage.itoggle.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/bootstrap/js/engage.itoggle.min.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/itoggle.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script>
var $j = jQuery.noConflict();
<% npc_status(); %>
$j(document).ready(function() {

	init_itoggle('npc_enable');
	init_itoggle('npc_compress');
	init_itoggle('npc_crypt');

});

</script>
<script>

<% login_state_hook(); %>

function initial(){
	show_banner(2);
	show_menu(5,32);
	show_footer();

	fill_status(npc_status());

	if (!login_safe())
		textarea_scripts_enabled(0);
}

function textarea_scripts_enabled(v){
	inputCtrl(document.form['scripts.npc_script.sh'], v);
	inputCtrl(document.form['scripts.npc.conf'], v);
}
function fill_status(status_code){
	var stext = "Unknown";
	if (status_code == 0)
		stext = "<#Stopped#>";
	else if (status_code == 1)
		stext = "<#Running#>";
	$("npc_status").innerHTML = '<span class="label label-' + (status_code != 0 ? 'success' : 'warning') + '">' + stext + '</span>';
}

function applyRule(){
	showLoading();
	
	document.form.action_mode.value = " Apply ";
	document.form.current_page.value = "/Advanced_npc.asp";
	document.form.next_page.value = "";
	
	document.form.submit();
}

function done_validating(action){
	refreshpage();
}

function button_npc_wan_port(){
	var addr = document.form.npc_server_addr.value;
	var conf = document.form['scripts.npc.conf'].value;
	var m = conf.match(/server_addr\s*=\s*([^:\s\n]+)/);
	
	if (m && m[1]) {
		window.open('http://' + m[1] + ':8080', 'npc_wan_port');
	} else if (addr && addr != '127.0.0.1') {
		window.open('http://' + addr + ':8080', 'npc_wan_port');
	} else {
		alert('请先在配置或文本框中填写服务器地址 (server_addr)');
	}
}

</script>
</head>

<body onload="initial();" onunLoad="return unload_body();">

<div class="wrapper">
	<div class="container-fluid" style="padding-right: 0px">
		<div class="row-fluid">
			<div class="span3"><center><div id="logo"></div></center></div>
			<div class="span9" >
				<div id="TopBanner"></div>
			</div>
		</div>
	</div>

	<div id="Loading" class="popup_bg"></div>

	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>

	<form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">

	<input type="hidden" name="current_page" value="Advanced_npc.asp">
	<input type="hidden" name="next_page" value="">
	<input type="hidden" name="next_host" value="">
	<input type="hidden" name="sid_list" value="NpcConf;">
	<input type="hidden" name="group_id" value="">
	<input type="hidden" name="action_mode" value="">
	<input type="hidden" name="action_script" value="">
	<input type="hidden" name="wan_ipaddr" value="<% nvram_get_x("", "wan0_ipaddr"); %>" readonly="1">
	<input type="hidden" name="wan_netmask" value="<% nvram_get_x("", "wan0_netmask"); %>" readonly="1">
	<input type="hidden" name="dhcp_start" value="<% nvram_get_x("", "dhcp_start"); %>">
	<input type="hidden" name="dhcp_end" value="<% nvram_get_x("", "dhcp_end"); %>">

	<div class="container-fluid">
		<div class="row-fluid">
			<div class="span3">
				<!--Sidebar content-->
				<!--=====Beginning of Main Menu=====-->
				<div class="well sidebar-nav side_nav" style="padding: 0px;">
					<ul id="mainMenu" class="clearfix"></ul>
					<ul class="clearfix">
						<li>
							<div id="subMenu" class="accordion"></div>
						</li>
					</ul>
				</div>
			</div>

			<div class="span9">
				<!--Body content-->
				<div class="row-fluid">
					<div class="span12">
						<div class="box well grad_colour_dark_blue">
							<h2 class="box_head round_top">内网穿透 - nps / npc</h2>
							<div class="round_bottom">
								<div class="row-fluid">
									<div id="tabMenu" class="submenuBlock"></div>
									<div class="alert alert-info" style="margin: 10px;">
										欢迎使用 nps，这是一款轻量级、功能强大的内网穿透代理服务器。支持tcp、udp流量转发，支持内网http代理、内网socks5代理，同时支持snappy压缩、站点保护、加密传输、多路复用、header修改等。支持web图形化管理，集成多用户模式。
										<div>下载地址(0.26.10 版本): <a href="https://github.com/ehang-io/nps/releases" target="blank">https://github.com/ehang-io/nps/releases</a></div>
										<div>下载地址(0.26.10 版本的基础上修改): <a href="https://github.com/yisier/nps/releases" target="blank">https://github.com/yisier/nps/releases</a></div>
										<div>教程地址: <a href="https://github.com/yisier/nps/blob/master/README_zh.md" target="blank">中文文档(yisier)</a> <a href="https://ehang-io.github.io/nps/" target="blank1">nps图文教程(ehang-io)</a></div>
										<div>服务端一键安装脚本: bash &lt;(curl -L -s https://opt.cn2qq.com/opt-script/nps.sh)</div>
									</div>

									<table width="100%" align="center" cellpadding="4" cellspacing="0" class="table">
										<tr>
											<th colspan="4" style="background-color: #E3E3E3;">开关</th>
										</tr>
										<tr>
											<th width="30%">npc 开关</th>
											<td>
												<div class="main_itoggle">
													<div id="npc_enable_on_of">
														<input type="checkbox" id="npc_enable_fake" <% nvram_match_x("", "npc_enable", "1", "value=1 checked"); %><% nvram_match_x("", "npc_enable", "0", "value=0"); %>  />
													</div>
												</div>
												<div style="position: absolute; margin-left: -10000px;">
													<input type="radio" value="1" name="npc_enable" id="npc_enable_1" class="input" value="1" <% nvram_match_x("", "npc_enable", "1", "checked"); %> /><#checkbox_Yes#>
													<input type="radio" value="0" name="npc_enable" id="npc_enable_0" class="input" value="0" <% nvram_match_x("", "npc_enable", "0", "checked"); %> /><#checkbox_No#>
												</div>
											</td>
											<th width="30%">npc 运行状态</th>
											<td id="npc_status"></td>
										</tr>
										<tr>
											<th style="border-top: 0 none;">使用指定版本:</th>
											<td style="border-top: 0 none;">
												<div class="input-append">
													<input maxlength="32" class="input" size="15" name="npc_v" id="npc_v" style="width: 175px;" placeholder="留空时使用最新版本"  value="<% nvram_get_x("","npc_v"); %>" onKeyPress="return is_string(this,event);"/>
												</div>
											</td>
											<td colspan="2" style="border-top: 0 none;">
												&nbsp;<span style="color:#888;">[留空]留空时使用固件内置版本</span>
											</td>
										</tr>
										
										<tr>
											<th colspan="4" style="background-color: #E3E3E3;" >配置 npc 客户端</th>
										</tr>
										<tr>
											<th width="30%" style="border-top: 0 none;">管理界面</th>
											<td colspan="3" style="border-top: 0 none;">
												<input class="btn btn-success" type="button" value="访问 NPS 服务端 Web 界面" onclick="button_npc_wan_port()" />
											</td>
										</tr>
										<tr>
											<td colspan="4" style="border-top: 0 none;">
												<i class="icon-hand-right"></i> <a href="javascript:spoiler_toggle('script3')"><span>点这里自定义 npc 客户端配置 (npc.conf)</span></a>
												<div id="script3">
													<textarea rows="10" wrap="off" spellcheck="false" maxlength="18192" class="span12" name="scripts.npc.conf" style="font-family:'Courier New'; font-size:12px;"><% nvram_dump("scripts.npc.conf",""); %></textarea>
												</div>
											</td>
										</tr>

										<tr>
											<th colspan="4" style="background-color: #E3E3E3;" >其他可选参数 (仅在未使用自定义 npc.conf 时生效)</th>
										</tr>
										<tr>
											<th width="30%" style="border-top: 0 none;">服务器地址:</th>
											<td style="border-top: 0 none;">
												<input type="text" maxlength="50" class="input" size="50" id="npc_server_addr" name="npc_server_addr" placeholder="127.0.0.1" value="<% nvram_get_x("","npc_server_addr"); %>"  onkeypress="return is_string(this,event);" />
											</td>
											<th width="15%" style="border-top: 0 none;">端口:</th>
											<td style="border-top: 0 none;">
												<input type="text" maxlength="5" class="input" size="15" id="npc_server_port" name="npc_server_port" placeholder="8024" value="<% nvram_get_x("","npc_server_port"); %>"  onkeypress="return is_number(this,event);" />
											</td>
										</tr>
										<tr>
											<th width="30%" style="border-top: 0 none;">协议类型:</th>
											<td style="border-top: 0 none;">
												<select name="npc_protocol" id="npc_protocol" class="input" style="width: 200px">
													<option value="tcp" <% nvram_match_x("","npc_protocol", "tcp","selected"); %>>TCP</option>
													<option value="kcp" <% nvram_match_x("","npc_protocol", "kcp","selected"); %>>KCP</option>
												</select>
											</td>
											<th width="15%" style="border-top: 0 none;">密钥(vkey):</th>
											<td style="border-top: 0 none;">
												<div class="input-append">
													<input type="password" maxlength="512" class="input" size="16" name="npc_vkey" id="npc_vkey" style="width: 175px;" value="<% nvram_get_x("","npc_vkey"); %>" onKeyPress="return is_string(this,event);"/>
													<button style="margin-left: -5px;" class="btn" type="button" onclick="passwordShowHide('npc_vkey')"><i class="icon-eye-close"></i></button>
												</div>
											</td>
										</tr>
										<tr>
											<th width="30%" style="border-top: 0 none;">使用压缩传输:</th>
											<td style="border-top: 0 none;">
												<div class="main_itoggle">
													<div id="npc_compress_on_of">
														<input type="checkbox" id="npc_compress_fake" <% nvram_match_x("", "npc_compress", "1", "value=1 checked"); %><% nvram_match_x("", "npc_compress", "0", "value=0"); %>  />
													</div>
												</div>
												<div style="position: absolute; margin-left: -10000px;">
													<input type="radio" value="1" name="npc_compress" id="npc_compress_1" class="input" value="1" <% nvram_match_x("", "npc_compress", "1", "checked"); %> /><#checkbox_Yes#>
													<input type="radio" value="0" name="npc_compress" id="npc_compress_0" class="input" value="0" <% nvram_match_x("", "npc_compress", "0", "checked"); %> /><#checkbox_No#>
												</div>
											</td>
											<th width="15%" style="border-top: 0 none;">使用加密传输:</th>
											<td style="border-top: 0 none;">
												<div class="main_itoggle">
													<div id="npc_crypt_on_of">
														<input type="checkbox" id="npc_crypt_fake" <% nvram_match_x("", "npc_crypt", "1", "value=1 checked"); %><% nvram_match_x("", "npc_crypt", "0", "value=0"); %>  />
													</div>
												</div>
												<div style="position: absolute; margin-left: -10000px;">
													<input type="radio" value="1" name="npc_crypt" id="npc_crypt_1" class="input" value="1" <% nvram_match_x("", "npc_crypt", "1", "checked"); %> /><#checkbox_Yes#>
													<input type="radio" value="0" name="npc_crypt" id="npc_crypt_0" class="input" value="0" <% nvram_match_x("", "npc_crypt", "0", "checked"); %> /><#checkbox_No#>
												</div>
											</td>
										</tr>
										<tr>
											<th width="30%" style="border-top: 0 none;">日志级别:</th>
											<td colspan="3" style="border-top: 0 none;">
												<select name="npc_log_level" id="npc_log_level" class="input" style="width: 200px">
													<option value="0" <% nvram_match_x("","npc_log_level", "0","selected"); %>>Emergency</option>
													<option value="2" <% nvram_match_x("","npc_log_level", "2","selected"); %>>Critical</option>
													<option value="3" <% nvram_match_x("","npc_log_level", "3","selected"); %>>Error</option>
													<option value="4" <% nvram_match_x("","npc_log_level", "4","selected"); %>>Warning</option>
													<option value="7" <% nvram_match_x("","npc_log_level", "7","selected"); %>>Debug</option>
												</select>
											</td>
										</tr>

										<tr>
											<td colspan="4" style="border-top: 0 none;">
												<i class="icon-hand-right"></i> <a href="javascript:spoiler_toggle('script2')"><span>npc启动脚本-不懂请不要乱改！！！</span></a>
												<div id="script2">
													<textarea rows="18" wrap="off" spellcheck="false" maxlength="314571" class="span12" name="scripts.npc_script.sh" style="font-family:'Courier New'; font-size:12px;"><% nvram_dump("scripts.npc_script.sh",""); %></textarea>
												</div>
											</td>
										</tr>
										
										<tr>
											<td colspan="4" style="border-top: 0 none;">
												<br />
												<center><input class="btn btn-primary" style="width: 219px" type="button" value="<#CTL_apply#>" onclick="applyRule()" /></center>
											</td>
										</tr>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	</form>

	<div id="footer"></div>
</div>
</body>
</html>
