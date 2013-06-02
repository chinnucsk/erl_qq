-module(eqq_http).
-export([default_header/0,get_version/0,get_verify_code/1]).
-define(VER_URL,"http://ui.ptlogin2.qq.com/cgi-bin/ver").
-define(CHECK_URL,"http://check.ptlogin2.qq.com/check").
-define(APPID,"1003903").
default_header()->	
	[{"User-Agent","User-Agent: Mozilla/5.0 (X11; OpenBSD macppc; rv:18.0) Gecko/20100101 Firefox/18/.0"},
	{"Accept","text/html, application/xml;q=0.9, application/xhtml+xml, image/png, image/jpeg, image/gif, image/x-xbitmap, */*;1=0.1"},
	{"Accept-Language","en-US;q=0.5"},
	{"Accept-Encoding","defakte,gzip,x-gzip,identity,*;q=0"}].


get_version()->
	DefaultHeader = default_header(),
	R = ibrowse:send_req(?VER_URL,DefaultHeader,get),
	case R of
		{ok,"200",Header,Body}->
			Seg1 = string:tokens(Body,"("),
			PartTwo = hm_misc:nth_in_list(2,Seg1),
			Seg2 = string:tokens(PartTwo,")"),
			PartOne = hm_misc:nth_in_list(1,Seg2),
			erlang:list_to_integer(PartOne);
		_ ->
			-1
	end.

get_verify_code(UID)->
	DefaultHeader = default_header(),
	UIDString = erlang:integer_to_list(UID),
	Cookie = "chkuin=" ++  UIDString,
	ReqHeader = DefaultHeader ++ [{"Cookie",Cookie}],
	URLList = [?CHECK_URL,"?uin=",UIDString,"&appid=",?APPID],
	URL = lists:flatten(URLList),
	R = ibrowse:send_req(URL,ReqHeader,get),
	case R of
		 {ok,"200",Header,Body}->
			 Seg1 = string:tokens(Body,"("),
			 PartTwo = hm_misc:nth_in_list(2,Seg1),
			 Seg2 = string:tokens(PartTwo,")"),
			 PartOne = hm_misc:nth_in_list(1,Seg2),
			 Seg3 = string:tokens(PartOne,","),
			 {Seg3,Header};
		_ ->
			[]
	end.

		










